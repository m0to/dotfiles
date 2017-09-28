eval "$(rbenv init -)"
export PATH=/usr/local/sbin:./bin:$PATH
export EDITOR='subl -w'

export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth

alias ls='ls -G'
alias ll='ls -hl'
alias github="open \`git config -l | grep 'remote.origin.url' | sed -n 's/remote.origin.url=git@github.com:\(.*\)\/\(.*\).git/https:\/\/github.com\/\1\/\2/p'\`"


if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

export EDITOR=/usr/local/bin/subl

# Docker stuff
alias docker.default='eval "$(docker-machine env default)"'

#Config Stuff
alias config.nginx="cd /usr/local/etc/nginx/"
alias config.hosts="subl /etc/hosts"

# Server stuff
alias mongo.start="brew services start mongodb"
alias mongo.stop="brew services stop mongodb"
alias mysql.start="mysql.server start"
alias mysql.stop="mysql.server stop"
alias mysql.restart="mysql.stop && mysql.start"
alias postgres.start="brew services start postgres"
alias postgres.stop="brew services stop postgres"
alias nginx.start="sudo brew services start nginx"
alias nginx.stop="sudo brew services stop nginx"
alias nginx.restart="sudo brew services restart nginx"
alias nginx.start.all="mysql.start && php.start && nginx.start"
alias nginx.stop.all="nginx.stop && php.stop && mysql.stop"
alias php.start="sudo brew services start php70"
alias php.stop="sudo brew services stop php70"
alias php.restart="sudo brew services restart php70"
alias redis.start="redis-server /usr/local/etc/redis.conf"
alias dnsmasq.start="sudo brew services start dnsmasq"
alias dnsmasq.stop="sudo brew services stop dnsmasq"
alias dnsmasq.restart="brew services restart dnsmasq"

alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; say DNS cache flushed"

# Ruby Stuff
alias be="bundle exec"
alias reload.dev="be rake db:drop; be rake db:create; be rake db:migrate; be rake db:seed"
alias reload.test="be rake db:schema:load RAILS_ENV=test"
alias spring.stop="bin/spring stop"

# PHP Stuff
PHP_AUTOCONF="/usr/local/bin/autoconf"
