# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set ZSH theme to empty since we're using Oh My Posh
ZSH_THEME=""

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  vscode
  zsh-completions
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
export EDITOR='code -w'

autoload -U add-zsh-hook

# Initialize ASDF
# Use $HOMEBREW_PREFIX (set by `brew shellenv` in ~/.zprofile) instead of
# `brew --prefix`, which forks brew on every shell start.
: "${HOMEBREW_PREFIX:=/opt/homebrew}"
[ -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ] && . "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

# fzf key bindings and fuzzy completion
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# direnv (per-project environment variables)
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# React Native / Android development
export ANDROID_HOME="$HOME/Library/Android/sdk"
if [ -d "$ANDROID_HOME" ]; then
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin"
fi
# JDK 17 for Android/Gradle builds (only export if a JDK 17 is actually present)
_java17="$(/usr/libexec/java_home -v 17 2>/dev/null)"
[ -n "$_java17" ] && export JAVA_HOME="$_java17"
unset _java17

# trash-cli is keg-only; put trash-put on PATH for the `trash-clean` git alias
[ -d "$HOMEBREW_PREFIX/opt/trash-cli/bin" ] && export PATH="$HOMEBREW_PREFIX/opt/trash-cli/bin:$PATH"

# Initialize Oh My Posh (skip in Apple Terminal for compatibility)
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # You can customize the theme by adding --config flag:
  # eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"
  eval "$(oh-my-posh init zsh)"
fi

# History substring search bindings (provided by the history-substring-search plugin)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
