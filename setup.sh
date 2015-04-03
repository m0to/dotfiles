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
cp "$repo/sublime/Preferences.sublime-settings" "$home/Library/Application Support/Sublime Text 3/Packages/User"
echo "Copied Sublime Configs"

echo "Making alias for sublime"
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "/usr/local/bin/subl"
