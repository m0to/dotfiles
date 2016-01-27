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

cp "$home/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings" "$repo/sublime/"
cp "$home/Library/Application Support/Sublime Text 3/Packages/User/Package Control.sublime-settings" "$repo/sublime/"
echo "Copied Sublime Settings"
