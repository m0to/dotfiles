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

echo "Installing zsh"
brew install zsh zsh-completions
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
git clone https://github.com/valentinocossar/vscode.git $ZSH_CUSTOM/plugins/vscode
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
brew tap caskroom/fonts
brew cask install font-hack-nerd-font

cp "$repo/zsh/.zshrc" "$home/.zshrc"
cp "$repo/zsh/.zshenv" "$home/.zshenv"
cp "$repo/zsh/alias.zsh" "$ZSH_CUSTOM/alias.zsh"

cp "$repo/.gitconfig" "$home/.gitconfig"
echo "Copied .gitconfig"
cp "$repo/.pryrc" "$home/.pryrc"
echo "Copied .pryrc"
cp "$repo/.hyper.js" "$home/.hyper.js"
cp "$repo/.hyperlayout" "$home/.hyperlayout"
echo "Copied Hyper Terminal settings"

echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing up Git"
brew install git

echo "Installing apple-gcc"
brew install gcc49

echo "Installing autoconf"
brew install autoconf

echo "Installing rbenv and ruby-build"
brew install rbenv ruby-build

echo "Installing Node"
brew install node

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

echo "Securing & setting up databases"
mysql_secure_installation
echo "MySQL Setup"
createdb `whoami`

echo "################################################"
echo "Add zsh to your allowed shells in `/etc/shells`"
echo "Update to use zsh"
echo "chsh -s $(which zsh)"
echo "================================================"
echo "Don't forget to set your git config"
echo "git config --global user.name 'Your Name'"
echo "git config --global user.email 'you@example.com'"
echo "================================================"
echo "Set your PHP-FPM Config 'user' and 'group'"
echo "/usr/local/etc/php/7.0/php-fpm.d/www.conf"
echo "================================================"
echo "Setup Ruby too. 'rbenv install –l' for latest"
echo "Set local default 'rbenv local x.x.x'"
echo "Set global default 'rbenv global x.x.x' to set global default"
echo "################################################"
