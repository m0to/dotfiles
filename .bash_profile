eval "$(rbenv init -)"
export PATH=/usr/local/sbin:./bin:$PATH
export EDITOR='subl -w'

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth

alias ls='ls -G'
alias ll='ls -hl'
alias github="open \`git config -l | grep 'remote.origin.url' | sed -n 's/remote.origin.url=git@github.com:\(.*\)\/\(.*\).git/https:\/\/github.com\/\1\/\2/p'\`"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git::\1)/'
}

parse_svn_branch() {
  parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print "(svn::"$1 "/" $2 ")"}'
}

parse_svn_url() {
  svn info 2>/dev/null | grep -e '^URL*' | sed -e 's#^URL: *\(.*\)#\1#g '
}

parse_svn_repository_root() {
  svn info 2>/dev/null | grep -e '^Repository Root:*' | sed -e 's#^Repository Root: *\(.*\)#\1\/#g'
}

export PS1="\[\033[00m\]\u@\h\[\033[01;36m\] \W\[\033[31m\] \$(parse_git_branch)\$(parse_svn_branch) \[\033[00m\]$\[\033[00m\] "

export EDITOR=/usr/local/bin/subl

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi

# Intern-X Tools
alias start_mongo="mongod --config /usr/local/etc/mongod.conf"
alias prod_beans="echo 'stats-tube profile_campaign_score' | nc -c 54.88.130.189 11300"

# Server stuff
alias mysql.start="mysql.server start"
alias mysql.stop="mysql.server stop"
alias mysql.restart="mysql.stop && mysql.start"
alias postgres.start="postgres -D /usr/local/var/postgres"
alias nginx.start="sudo nginx"
alias nginx.stop="sudo nginx -s stop"
alias nginx.restart="nginx.stop && nginx.start"

# Ruby Stuff
alias resetdb='rake db:drop; rake db:create; rake db:migrate; rake db:seed'
