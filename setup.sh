#!/bin/bash

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
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

echo "Installing zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
git clone https://github.com/valentinocossar/vscode.git $ZSH_CUSTOM/plugins/vscode
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestionsgit
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

brew install zsh zsh-completions
brew install zsh-syntax-highlighting

# Bind keys for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Setup fonts
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font
brew cask install font-fira-code
brew cask install font-firamono-nerd-font-mono

cp "$repo/zsh/.zshrc" "$home/.zshrc"
cp "$repo/zsh/alias.zsh" "$ZSH_CUSTOM/alias.zsh"

echo "Copy config files"
cp "$repo/.gitconfig" "$home/.gitconfig"
echo "Copied .gitconfig"
cp "$repo/.pryrc" "$home/.pryrc"
echo "Copied .pryrc"

echo "Installing apple-gcc"
brew install gcc49

echo "Installing autoconf"
brew install autoconf

echo "Installing rbenv and ruby-build"
brew install rbenv ruby-build

echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash


echo "================================================"
echo "Don't forget to set your git config"
echo "git config --global user.name 'Your Name'"
echo "git config --global user.email 'you@example.com'"
echo "================================================"
