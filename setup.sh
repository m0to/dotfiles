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

brew_install() {
  local pkg=$1
  if brew list "$pkg" >/dev/null 2>&1; then
    return
  fi
  brew install "$pkg"
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

brew_install zsh

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

# Install applications
log "Installing applications"
brew_install_cask docker
brew_install_cask visual-studio-code
brew_install_cask iterm2

# Configure iTerm2
if [ -f "$repo/iterm2/iTerm2-State.itermexport" ]; then
  log "Copying iTerm2 settings"
  # iTerm2 will automatically import .itermexport files from this location
  mkdir -p "$home/Library/Application Support/iTerm2/DynamicProfiles"
  cp "$repo/iterm2/iTerm2-State.itermexport" "$home/Library/Application Support/iTerm2/"
fi

brew_install_cask rectangle
brew_install_cask 1password
brew_install_cask slack

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

# Ensure history search bindings persist
if ! grep -q "history-substring-search-up" "$home/.zshrc" 2>/dev/null; then
  cat <<'EOF' >> "$home/.zshrc"

# History substring search bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
EOF
fi

log "Copy config files"
copy_with_backup "$repo/.gitconfig" "$home/.gitconfig"
copy_with_backup "$repo/.tool-versions" "$home/.tool-versions"

log "Installing compiler and tooling"
brew_install gcc
brew_install autoconf
brew_install gpg
brew_install gnu-tar
brew_install asdf

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

# Install versions from .tool-versions if it exists
if [ -f "$repo/.tool-versions" ]; then
  log "Installing tools from .tool-versions"
  cd "$repo"
  asdf install
  cd - >/dev/null
fi

echo "================================================"
echo "Don't forget to set your git config"
echo "git config --global user.name 'Your Name'"
echo "git config --global user.email 'you@example.com'"
echo "================================================"
echo ""
echo "IMPORTANT: For Oh My Posh to display correctly, set your terminal font to one of the installed Nerd Fonts (e.g., Hack Nerd Font, Fira Code Nerd Font, or FiraMono Nerd Font) in your terminal's preferences."
echo ""
