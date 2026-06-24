#!/bin/zsh
set -euo pipefail

if [ "${1:-}" = "--help" -o "${1:-}" = "help" -o "${1:-}" = "--usage" ]; then
  echo "Usage:"
  echo "$0 [dotfiles_dir] [home_dir]"
  exit
fi

repo=${1:-$(pwd)}
home=${2:-$HOME}

log() {
  echo "==> $*"
}

ensure_brew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # After installation, add Homebrew to PATH immediately for this script
  if [ -f "/opt/homebrew/bin/brew" ]; then
    # Apple Silicon Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f "/usr/local/bin/brew" ]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

brew_prefix() {
  command -v brew >/dev/null 2>&1 && brew --prefix
}

# Prime sudo up front and keep the credential alive for the whole run, so the
# script can finish unattended (the Docker setup below needs sudo, and the
# default 5-minute sudo timeout would otherwise expire during the long
# compile/daemon-wait steps). Enter your password once and walk away.
log "Requesting administrator access (used later for Docker setup)"
sudo -v
# Refresh the sudo timestamp in the background until this script exits.
while true; do
  sudo -n true 2>/dev/null || true
  sleep 60
  kill -0 "$$" 2>/dev/null || exit
done &
SUDO_KEEPALIVE_PID=$!
# Stop the keep-alive when the script exits, however it exits.
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

ensure_brew
BREW_PREFIX=$(brew_prefix)

# Add Homebrew to PATH in .zprofile for future sessions
if [ -n "${BREW_PREFIX:-}" ]; then
  SHELLENV_CMD="eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""
  if ! grep -q "$SHELLENV_CMD" "$home/.zprofile" 2>/dev/null; then
    log "Adding Homebrew shellenv to ~/.zprofile"
    echo "$SHELLENV_CMD" >> "$home/.zprofile"
  fi
  brew update
fi

# Xcode Command Line Tools provide git/clang and are required by much of what
# follows. The Homebrew installer normally installs them, but trigger it
# explicitly so the script doesn't depend on that side effect. Full Xcode (for
# iOS/RN builds) must still be installed from the App Store.
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install || true
fi

brew_install() {
  local pkg=$1
  if brew list "$pkg" >/dev/null 2>&1; then
    return
  fi
  # Don't let a single failed formula abort the whole unattended run.
  set +e
  brew install "$pkg"
  local exit_code=$?
  set -e
  if [ $exit_code -ne 0 ]; then
    log "Warning: Failed to install $pkg (continuing)"
  fi
}

brew_install_cask() {
  local cask=$1
  if brew list --cask "$cask" >/dev/null 2>&1; then
    log "$cask already installed via Homebrew, skipping"
    return
  fi
  # Try to install, but don't fail if the app is already installed manually
  # Temporarily disable exit on error for this command
  set +e
  brew install --cask "$cask"
  local exit_code=$?
  set -e

  if [ $exit_code -eq 0 ]; then
    log "$cask installed successfully"
  else
    log "Warning: Failed to install $cask (may already be installed manually)"
  fi
}

log "Installing Oh My Zsh (unattended)"
if [ ! -d "$home/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already installed, skipping"
fi

brew_install jandedobbeleer/oh-my-posh/oh-my-posh

# Ensure $ZSH_CUSTOM is set (Oh My Zsh sets this, but fallback if not)
if [ -z "${ZSH_CUSTOM:-}" ]; then
  ZSH_CUSTOM="$home/.oh-my-zsh/custom"
fi
mkdir -p "$ZSH_CUSTOM/plugins"

clone_or_update() {
  local repo_url=$1
  local dest=$2
  if [ -d "$dest/.git" ]; then
    git -C "$dest" pull --ff-only
  elif [ -d "$dest" ]; then
    log "Skipping $dest (exists and not a git repo)"
  else
    git clone "$repo_url" "$dest"
  fi
}

log "Installing zsh plugins"
clone_or_update https://github.com/valentinocossar/vscode.git "$ZSH_CUSTOM/plugins/vscode"
clone_or_update https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
clone_or_update https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_update https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

# Setup fonts
log "Installing fonts"
brew_install_cask font-hack-nerd-font
brew_install_cask font-fira-code
brew_install_cask font-fira-mono-nerd-font

# Install CLI tools
log "Installing CLI tools"
brew_install git
brew_install wget
brew_install jq
brew_install tree
brew_install htop

# Developer quality-of-life tools
log "Installing developer CLI tools"
brew_install gh
brew_install ripgrep
brew_install fd
brew_install fzf
brew_install bat
brew_install direnv
brew_install git-delta
brew_install git-extras   # provides `git delete-merged-branches` (used by the `brd` alias)
brew_install trash-cli    # provides `trash-put` (used by the `trash-clean` alias)

# Install applications
log "Installing applications"
brew_install_cask docker-desktop
brew_install_cask visual-studio-code
brew_install_cask iterm2

# Set up Docker Desktop unattended: accept the license, install the privileged
# helper + CLI symlinks, then start the daemon and wait for it to be ready.
setup_docker() {
  local app="/Applications/Docker.app"
  [ -d "$app" ] || { log "Docker.app not found, skipping Docker setup"; return; }

  if [ -x "$app/Contents/MacOS/install" ]; then
    log "Configuring Docker Desktop (accepting license, installing helper — needs sudo)"
    sudo "$app/Contents/MacOS/install" --accept-license --user="$(whoami)" || \
      log "Warning: Docker headless install step failed (may already be configured)"
  fi

  if ! docker info >/dev/null 2>&1; then
    log "Starting Docker Desktop"
    open -a Docker
    log "Waiting for the Docker daemon to be ready..."
    local i=0
    until docker info >/dev/null 2>&1; do
      i=$((i + 1))
      if [ "$i" -ge 60 ]; then
        log "Warning: Docker daemon not ready after 2 minutes; check Docker Desktop manually"
        break
      fi
      sleep 2
    done
    if [ "$i" -lt 60 ]; then
      log "Docker daemon is ready"
    fi
  else
    log "Docker daemon already running"
  fi
}
setup_docker

brew_install_cask rectangle
brew_install_cask 1password
brew_install_cask slack

# React Native tooling
log "Installing React Native tooling"
brew_install watchman
brew_install cocoapods
brew_install_cask temurin@17    # JDK 17 — required by React Native's Android/Gradle toolchain
brew_install_cask android-studio
brew_install_cask android-commandlinetools  # provides sdkmanager/avdmanager

# If full Xcode is installed, point the toolchain at it and accept the license.
if [ -d "/Applications/Xcode.app" ]; then
  log "Selecting Xcode toolchain and accepting its license"
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer || true
  sudo xcodebuild -license accept || true
fi

# Install Android SDK components non-interactively (skips the Studio GUI wizard).
export JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 17 2>/dev/null || true)}"
export ANDROID_HOME="$home/Library/Android/sdk"
if command -v sdkmanager >/dev/null 2>&1; then
  log "Installing Android SDK components (this can take a while)"
  mkdir -p "$ANDROID_HOME"
  # Accept all SDK licenses first so package installs don't prompt.
  yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses >/dev/null 2>&1 || true
  sdkmanager --sdk_root="$ANDROID_HOME" \
    "platform-tools" \
    "emulator" \
    "platforms;android-35" \
    "build-tools;35.0.0" \
    "system-images;android-35;google_apis;arm64-v8a" \
    || log "Warning: some Android SDK components failed to install"
else
  log "sdkmanager not found; install the Android SDK via Android Studio's setup wizard"
fi

copy_with_backup() {
  local src=$1
  local dest=$2
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && ! cmp -s "$src" "$dest"; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    log "Backing up $dest to ${dest}.bak.${ts}"
    cp "$dest" "${dest}.bak.${ts}"
  fi
  cp "$src" "$dest"
}

copy_with_backup "$repo/zsh/.zshrc" "$home/.zshrc"
copy_with_backup "$repo/zsh/alias.zsh" "$ZSH_CUSTOM/alias.zsh"

log "Copy config files"
copy_with_backup "$repo/.gitconfig" "$home/.gitconfig"
copy_with_backup "$repo/.tool-versions" "$home/.tool-versions"

# Seed local git identity files from the templates, but never clobber real
# values already on the machine. Edit these with your name/email after setup;
# they are gitignored and stay out of this (public) repo.
seed_from_example() {
  local example=$1
  local dest=$2
  if [ -f "$dest" ]; then
    log "$dest already exists, leaving it untouched"
  elif [ -f "$example" ]; then
    log "Seeding $dest from $(basename "$example") — edit it with your real name/email"
    cp "$example" "$dest"
  fi
}
seed_from_example "$repo/.gitconfig-identity.example" "$home/.gitconfig-identity"
seed_from_example "$repo/.gitconfig-work.example" "$home/.gitconfig-work"

# Install VS Code extensions from the tracked list. Refresh the list on your
# primary machine with: code --list-extensions | sort > vscode/extensions.txt
if command -v code >/dev/null 2>&1 && [ -f "$repo/vscode/extensions.txt" ]; then
  log "Installing VS Code extensions"
  installed=$(code --list-extensions 2>/dev/null)
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    case "$ext" in \#*) continue ;; esac
    if printf '%s\n' "$installed" | grep -qix "$ext"; then
      continue
    fi
    code --install-extension "$ext" --force >/dev/null 2>&1 \
      && log "Installed VS Code extension: $ext" \
      || log "Warning: Failed to install VS Code extension: $ext"
  done < "$repo/vscode/extensions.txt"
else
  log "Skipping VS Code extensions (code CLI or vscode/extensions.txt not found)"
fi

log "Installing compiler and tooling"
brew_install gcc
brew_install autoconf
brew_install gpg
brew_install gnu-tar
brew_install asdf

# Build dependencies for compiling language runtimes via asdf
log "Installing language build dependencies"
brew_install openssl@3
brew_install readline
brew_install sqlite3
brew_install xz
brew_install zlib
brew_install tcl-tk      # Python
brew_install libyaml     # Ruby (psych/YAML)
brew_install wxwidgets   # Erlang (observer/wx)
brew_install libxslt     # Erlang
brew_install fop         # Erlang (docs)

# Source asdf for use in this script
if [ -n "${BREW_PREFIX:-}" ]; then
  . "${BREW_PREFIX}/opt/asdf/libexec/asdf.sh"
fi

asdf_plugin_add() {
  local plugin=$1
  if asdf plugin list | grep -q "^${plugin}$"; then
    log "asdf plugin ${plugin} already installed"
  else
    log "Installing asdf plugin: ${plugin}"
    asdf plugin add "$plugin"
  fi
}

log "Installing asdf plugins"
asdf_plugin_add nodejs
asdf_plugin_add yarn
asdf_plugin_add bun
asdf_plugin_add erlang
asdf_plugin_add elixir
asdf_plugin_add python
asdf_plugin_add ruby

# Install versions from .tool-versions if it exists
if [ -f "$repo/.tool-versions" ]; then
  log "Installing tools from .tool-versions"
  cd "$repo"
  asdf install
  cd - >/dev/null
fi

echo "================================================"
echo "Set your git identity (these files are gitignored, not committed):"
echo "  \$EDITOR ~/.gitconfig-identity   # default name/email"
echo "  \$EDITOR ~/.gitconfig-work       # work name/email (~/workplace/radicle/ repos)"
echo "================================================"
echo ""
echo "IMPORTANT: For Oh My Posh to display correctly, set your terminal font to one of the installed Nerd Fonts (e.g., Hack Nerd Font, Fira Code Nerd Font, or FiraMono Nerd Font) in your terminal's preferences."
echo ""
