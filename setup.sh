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
brew install php70
brew install php70-mcrypt
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
mkdir -p /usr/local/etc/nginx/ssl
mkdir -p /usr/local/etc/nginx/logs
echo "Nginx: Copying config files"
cp "$repo/nginx/conf.d/php-fpm" /usr/local/etc/nginx/conf.d/php-fpm
cp "$repo/nginx/nginx.conf" /usr/local/etc/nginx/nginx.conf
cp "$repo/nginx/site-available" /usr/local/etc/nginx/sites-available
ln -s /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled
echo "Nginx: Config Files Copied"

echo "dnsmasq: Setting up local DNS"
brew install dnsmasq
cd $(brew --prefix); mkdir etc; echo 'address=/.dev/127.0.0.1' > etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
echo "dnsmasq: Setup and configured"

echo "Setting screenshot location"
mkdir -p /Users/jasonliebrecht/Desktop/Screenshots
defaults write com.apple.screencapture location /Users/jasonliebrecht/Desktop/Screenshots
killall SystemUIServer

echo "################################################"
echo "Don't forget to set your git config"
echo "git config --global user.name 'Your Name'"
echo "git config --global user.email 'you@example.com'"
echo "================================================"
echo "Set your PHP-FPM Config 'user' and 'group'"
echo "/usr/local/etc/php/7.0/php-fpm.d/www.conf"
echo "################################################"
