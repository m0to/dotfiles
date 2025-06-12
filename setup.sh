#!/bin/zsh

if [ "$1" = "--help" -o "$1" = "help" -o "$1" = "--usage" ]; then
  echo "Usage:"
  echo "$0 [dotfiles_dir] [home_dir]"
  exit
fi

repo=$1
if [ -z "$repo" ]; then
  repo=`pwd`
fi

home=$2
if [ -z "$home" ]; then
  home=~
fi

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Add Homebrew to PATH if not already present
if ! grep -q 'eval "$'"(/opt/homebrew/bin/brew shellenv)"'"' ~/.zprofile 2>/dev/null; then
  echo 'eval "$'"(/opt/homebrew/bin/brew shellenv)"'"' >> ~/.zprofile
fi
eval "$('/opt/homebrew/bin/brew' shellenv)"
brew update

echo "Installing zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# when prompted to change default to zsh, enter y
# enter sudo password again

brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Ensure $ZSH_CUSTOM is set (Oh My Zsh sets this, but fallback if not)
if [ -z "$ZSH_CUSTOM" ]; then
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
fi
git clone https://github.com/valentinocossar/vscode.git $ZSH_CUSTOM/plugins/vscode
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

brew install zsh zsh-completions
brew install zsh-syntax-highlighting

# Bind keys for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Setup fonts
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install --cask font-fira-code
brew install --cask font-firamono-nerd-font-mono

cp "$repo/zsh/.zshrc" "$home/.zshrc"
# Ensure $ZSH_CUSTOM is set (Oh My Zsh sets this, but fallback if not)
if [ -z "$ZSH_CUSTOM" ]; then
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
fi
cp "$repo/zsh/alias.zsh" "$ZSH_CUSTOM/alias.zsh"

echo "Copy config files"
cp "$repo/.gitconfig" "$home/.gitconfig"
echo "Copied .gitconfig"

echo "Installing apple-gcc"
brew install gcc49

echo "Installing autoconf"
brew install autoconf

echo "Installing ASDF"
brew install asdf

echo "================================================"
echo "Don't forget to set your git config"
echo "git config --global user.name 'Your Name'"
echo "git config --global user.email 'you@example.com'"
echo "================================================"
echo ""
echo "IMPORTANT: For Oh My Posh to display correctly, set your terminal font to one of the installed Nerd Fonts (e.g., Hack Nerd Font, Fira Code Nerd Font, or FiraMono Nerd Font) in your terminal's preferences."
echo ""
