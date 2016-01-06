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

GIT_PS1_DESCRIBE_STYLE='describe'
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWCOLORHINTS=1

export PS1='\u@local \e[33m\w\e[31m$(__git_ps1)\[\033[00m\]$ '

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

# Ruby Stuff
alias resetdb="rake db:drop; rake db:create; rake db:migrate; rake db:seed"
alias be="bundle exec"
alias spring.stop="bin/spring stop"

# PHP Stuff
PHP_AUTOCONF="/usr/local/bin/autoconf"
