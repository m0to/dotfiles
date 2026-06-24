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

# Docker / Postgres
# Run a local Postgres instance in Docker with a persistent volume.
# Override defaults via env: PG_VERSION, PG_PORT, PG_PASSWORD.
alias docker.pg.run='docker run --name postgres -d -e POSTGRES_PASSWORD=${PG_PASSWORD:-postgres} -v pgdata:/var/lib/postgresql/data -p ${PG_PORT:-5432}:5432 postgres:${PG_VERSION:-16}'
alias docker.pg.start="docker start postgres"
alias docker.pg.stop="docker stop postgres"
alias docker.pg.rm="docker rm -f postgres"
alias docker.pg.logs="docker logs -f postgres"
alias docker.pg.psql="docker exec -it postgres psql -U postgres"

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

# Elixir / Phoenix Stuff
alias md="mix deps.get"
alias mc="mix compile"
alias mt="mix test"
alias mps="mix phx.server"
alias miex="iex -S mix"
alias reload.dev="mix ecto.drop && mix ecto.create && mix ecto.migrate"
alias reload.test="MIX_ENV=test mix ecto.reset"
