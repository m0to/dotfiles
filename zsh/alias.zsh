alias ls='ls -G'
alias ll='ls -hl'

# Docker stuff
alias docker.default='eval "$(docker-machine env default)"'

#Config Stuff
alias config.nginx="cd /usr/local/etc/nginx/"
alias config.hosts="code /etc/hosts"

# Shortcuts
alias wp="cd ~/workplace"

# Git Stuff
alias gcleanup='git checkout master && comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin | sed "s/^.*origin\///g") | xargs -L1 -J % git branch -D %'

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
alias nginx.test="sudo nginx -t"
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
alias redis.start="brew services start redis"
alias redis.stop="brew services stop redis"
alias redis.restart="brew services restart redis"

# Loomly Stuff
alias ngrok.calendy="./ngrok http 3000 -subdomain=calendyjason"
alias foreman.calendy="foreman start -f Procfile.dev"
alias foreman.console="foreman run rails console"
alias postgres96.start="brew services start postgresql@9.6"
alias postgres96.stop="brew services stop postgresql@9.6"
alias postgres96.restart="brew services restart postgresql@9.6"

alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; say DNS cache flushed"

# Javascript/PM2
alias pm2.staging.setup="pm2 deploy ecosystem.config.js staging setup"
alias pm2.staging.update="pm2 deploy ecosystem.config.js staging update"
alias pm2.production.setup="pm2 deploy ecosystem.config.js production setup"
alias pm2.production.update="pm2 deploy ecosystem.config.js production update"

# Ruby Stuff
alias be="bundle exec"
alias reload.dev="be rake db:drop; be rake db:create; be rake db:migrate; be rake db:seed"
alias reload.test="be rake db:test:prepare"
alias spring.stop="bin/spring stop"
