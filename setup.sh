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

cp "$repo/.bash_profile" "$home/.bash_profile"
echo "Copied .bash_profile"
cp "$repo/.gitconfig" "$home/.gitconfig"
echo "Copied .gitconfig"
cp "$repo/.pryrc" "$home/.pryrc"
echo "Copied .pryrc"
cp "$repo/sublime/Preferences.sublime-settings" "$home/Library/Application Support/Sublime Text 3/Packages/User"
cp "$repo/sublime/Package\ Control.sublime-settings" "$home/Library/Application Support/Sublime Text 3/Packages/User"
echo "Copied Sublime Configs"

echo "Making alias for sublime"
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing up Git"
brew install git

echo "Installing bash prompt goodness"
brew install bash-completion
brew install bash-git-prompt

echo "Installing apple-gcc42"
brew install homebrew/dupes/apple-gcc42

echo "Installing autoconf"
brew install autoconf

echo "Installing rbenv and ruby-build"
brew install rbenv ruby-build

echo "Installing PostGres"
brew install postgresql

echo "Installing MySQL"
brew install mysql

echo "Installing nginx & PHP"
brew install nginx
brew tap homebrew/dupes
brew tap josegonzalez/homebrew-php
brew install --without-apache --with-fpm --with-mysql php55

echo "################################################"
echo "Don't forget to set your git config"
echo "git config --global user.name 'Your Name'"
echo "git config --global user.email 'you@example.com'"
echo "################################################"
