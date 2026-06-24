# dotfiles

Bootstrap or reset a macOS machine for development. One script installs the
shell environment, CLI tools, GUI apps, language runtimes, and copies over my
config files.

## Before you run this

- **macOS on an admin account.** The script is macOS-only (Homebrew casks, App
  Store apps, `~/Library` paths) and needs `sudo` — it prompts for your password
  once near the start (for Docker + Xcode setup) and keeps the credential alive
  for the rest of the run, so you can walk away after entering it.
- **Xcode Command Line Tools** (for `git`/`clang`). On a clean machine the first
  `git clone` below will prompt to install them; you can also run
  `xcode-select --install` first. The script re-runs this too, so it's safe
  either way.
- **(Optional, for iOS builds) Install full Xcode from the App Store first.**
  Homebrew can't install Xcode itself. If it's already present when you run the
  script, the script selects its toolchain and accepts its license for you;
  otherwise do that step later.
- **A good internet connection and free disk space.** The run downloads a lot
  (Android SDK + system image, Android Studio, Docker) and compiles some
  runtimes (Erlang, Python, Ruby) from source, so it takes a while.

Note: the script **overwrites `~/.zshrc` and `~/.gitconfig`** (and a few others),
backing up any existing copy to `<file>.bak.<timestamp>` first. Your git identity
is read from separate `~/.gitconfig-identity` / `~/.gitconfig-work` files (see
[Notes](#notes)), which are never overwritten.

## Usage

```sh
git clone <this-repo> ~/workplace/dotfiles
cd ~/workplace/dotfiles
./setup.sh
```

Optionally pass a different repo dir and home dir:

```sh
./setup.sh [dotfiles_dir] [home_dir]    # defaults: $(pwd) and $HOME
```

The script is idempotent — re-running it skips anything already installed and
backs up any existing config file before overwriting it (`<file>.bak.<timestamp>`).

After it finishes, restart your shell (or `source ~/.zshrc`) and set your
terminal font to one of the installed Nerd Fonts so Oh My Posh renders correctly.

## What it installs

- **Shell:** Oh My Zsh + Oh My Posh prompt, plus zsh plugins
  (autosuggestions, syntax-highlighting, completions, history-substring-search,
  vscode)
- **Fonts:** Hack Nerd Font, Fira Code, FiraMono Nerd Font
- **CLI tools:** git, wget, jq, tree, htop, gcc, autoconf, gpg, gnu-tar, asdf
- **Dev CLI tools:** gh, ripgrep, fd, fzf, bat, direnv, git-delta, git-extras, trash-cli
- **Apps (casks):** Docker Desktop, Visual Studio Code, iTerm2, Rectangle, 1Password, Slack
  (Docker is set up unattended — license accepted, daemon started and waited on)
- **React Native tooling:** watchman, cocoapods, Temurin JDK **17**, Android
  Studio, Android command-line tools. The script also installs Android SDK
  components (platform-tools, emulator, API 35, build-tools, a system image) via
  `sdkmanager`, sets `ANDROID_HOME`/`JAVA_HOME`/PATH in `.zshrc`, and — if full
  Xcode is present — selects its toolchain and accepts the license. Full Xcode
  itself is App Store only.
- **Runtimes (via asdf, versions pinned in `.tool-versions`):** Node.js, Yarn,
  Bun, Erlang, Elixir, Python, Ruby
- **Language build deps:** openssl, readline, sqlite3, xz, zlib, tcl-tk
  (Python); libyaml (Ruby); wxwidgets, libxslt, fop (Erlang)
- **VS Code extensions:** reinstalled from `vscode/extensions.txt` if the `code`
  CLI is available

## What it configures

| Repo file                    | Installed to                          |
| ---------------------------- | ------------------------------------- |
| `zsh/.zshrc`                 | `~/.zshrc`                            |
| `zsh/alias.zsh`              | `$ZSH_CUSTOM/alias.zsh`               |
| `.gitconfig`                 | `~/.gitconfig`                        |
| `.gitconfig-identity.example`| `~/.gitconfig-identity` (if absent)   |
| `.gitconfig-work.example`    | `~/.gitconfig-work` (if absent)       |
| `.tool-versions`             | `~/.tool-versions`                    |

## Layout

```
setup.sh                     # the bootstrap script
.gitconfig                   # git aliases, colors, defaults; includes the identity files below
.gitconfig-identity.example  # template for default name/email (real values live in ~/.gitconfig-identity)
.gitconfig-work.example      # template for work name/email (real values live in ~/.gitconfig-work)
.tool-versions               # asdf runtime versions
vscode/extensions.txt        # VS Code extensions to reinstall
zsh/.zshrc                   # shell config (oh-my-zsh + oh-my-posh + asdf)
zsh/alias.zsh                # shell aliases
```

## Notes

- **Git identity is kept out of this (public) repo.** `.gitconfig` pulls your
  name/email from `~/.gitconfig-identity`, and repos under `~/workplace/radicle/`
  override it with `~/.gitconfig-work`. `setup.sh` seeds both from the
  `*.example` templates (without overwriting existing files); edit them with your
  real values. The real files are gitignored and never committed.
- Refresh the VS Code extension list on your primary machine with
  `code --list-extensions | sort > vscode/extensions.txt`.
