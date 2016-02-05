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

# Server stuff
alias mongo.start="mongod --config /usr/local/etc/mongod.conf"
alias mysql.start="mysql.server start"
alias mysql.stop="mysql.server stop"
alias mysql.restart="mysql.stop && mysql.start"
alias postgres.start="postgres -D /usr/local/var/postgres"
alias nginx.start="sudo nginx"
alias nginx.stop="sudo nginx -s stop"
alias nginx.restart="nginx.stop && nginx.start"
alias nginx.start.all="mysql.start && php.start && nginx.start"
alias nginx.stop.all="nginx.stop && php.stop && mysql.stop"
alias php.start="brew services start php56"
alias php.stop="brew services stop php56"
alias php.restart="brew services restart php56"
alias redis.start="redis-server /usr/local/etc/redis.conf"

# Ruby Stuff
alias be="bundle exec"
alias reload.dev="be rake db:drop; be rake db:create; be rake db:migrate; be rake db:seed"
alias reload.test="be rake db:schema:load RAILS_ENV=test"
alias spring.stop="bin/spring stop"

# PHP Stuff
PHP_AUTOCONF="/usr/local/bin/autoconf"
