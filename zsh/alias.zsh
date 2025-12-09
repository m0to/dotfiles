# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias wp="cd ~/workplace"
alias dl="cd ~/Downloads"

# List directory contents
alias ls='ls -G'
alias ll='ls -hl'
alias la='ls -lah'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Docker stuff
alias docker.mongo.run="docker run --name mongo -d -v ~/mongo/data:/data/db -p 27017:27017 mongo:latest"
alias docker.mongo.stop="docker stop mongo"
alias docker.mongo.rm="docker rm mongo"

# Git Stuff
# Cleanup merged branches - works with both 'main' and 'master'
alias gcleanup='git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@" | xargs -I {} git checkout {} && comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin | sed "s/^.*origin\///g") | xargs -L1 -J % git branch -D %'
alias gs='git status'
alias gp='git pull'
alias gf='git fetch'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --decorate --graph'

# Network Stuff
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; say DNS cache flushed"

# Ruby/Rails Stuff
alias be="bundle exec"
alias reload.dev="be rake db:drop; be rake db:create; be rake db:migrate; be rake db:seed"
alias reload.test="be rake db:test:prepare"
alias spring.stop="bin/spring stop"
