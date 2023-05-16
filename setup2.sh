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
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

echo "Installing iTerm"
brew install --cask iterm2

echo "Installing updated git"
brew install git

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Install powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

echo "Install zsh addons"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Bind keys for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

echo "Copy config files"
cp "$repo/.gitconfig" "$home/.gitconfig"
cp "$repo/zsh/.zshrc" "$home/.zshrc"
cp "$repo/zsh/alias.zsh" "$ZSH_CUSTOM/alias.zsh"

echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

echo "Installing Pyenv"
brew install pyenv
