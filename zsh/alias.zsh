alias ls='ls -G'
alias ll='ls -hl'

# Docker stuff
alias docker.default='eval "$(docker-machine env default)"'
alias docker.mongo.run="docker run --name mongo -d  -v ~/mongo/data:/data/db -p 27017:27017 mongo:latest"
alias docker.mongo.stop="docker stop mongo"

#Config Stuff
alias config.nginx="cd /usr/local/etc/nginx/"
alias config.hosts="code /etc/hosts"

# Shortcuts
alias wp="cd ~/workplace"
alias dl="cd ~/Downloads"

# Git Stuff
alias gcleanup='git checkout master && comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin | sed "s/^.*origin\///g") | xargs -L1 -J % git branch -D %'

# Activbody Stuff
alias ngrok.activ5="./ngrok http 4000"

alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; say DNS cache flushed"



# Ruby Stuff
alias be="bundle exec"
alias reload.dev="be rake db:drop; be rake db:create; be rake db:migrate; be rake db:seed"
alias reload.test="be rake db:test:prepare"
alias spring.stop="bin/spring stop"
