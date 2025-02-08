alias ls='ls -G'
alias ll='ls -hl'

# Docker stuff
alias docker.default='eval "$(docker-machine env default)"'
alias docker.mongo.run="docker run --name mongo -d  -v ~/mongo/data:/data/db -p 27017:27017 mongo:latest"
alias docker.mongo.stop="docker stop mongo"
alias docker.postgres.run="docker run -d --name postgres-dev -e POSTGRES_PASSWORD=Gr00vy1 -e PGDATA=/var/lib/postgresql/data/pgdata -v /tmp/postgres-data:/var/lib/postgresql/data -p 54320:5432 postgres"
alias docker.postgres.restart="docker restart postgres-dev"
alias docker.postgres.stop="docker stop postgres-dev"
alias docker_clean_images='docker rmi $(docker images -a --filter=dangling=true -q)'
alias docker_clean_ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'

#Config Stuff
alias config.nginx="cd /usr/local/etc/nginx/"
alias config.hosts="code /etc/hosts"

# Shortcuts
alias wp="cd ~/workplace"
alias dl="cd ~/Downloads"

# Git Stuff
alias gcleanup='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'

# Tools
alias ngrok="./ngrok http 4000"
alias wind=/Applications/Windsurf.app/Contents/MacOS/Electron

alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; say DNS cache flushed"

# Ruby Stuff
alias be="bundle exec"
alias reload.dev="be rake db:drop; be rake db:create; be rake db:migrate; be rake db:seed"
alias reload.test="be rake db:test:prepare"
alias spring.stop="bin/spring stop"

alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
