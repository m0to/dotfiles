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

# place this after nvm initialization!
autoload -U add-zsh-hook

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

[ -f "$HOME/.zshenv" ] && source "$HOME/.zshenv"

# Initialize ASDF
. "$(brew --prefix asdf)/libexec/asdf.sh"

# Initialize Oh My Posh (skip in Apple Terminal for compatibility)
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # You can customize the theme by adding --config flag:
  # eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"
  eval "$(oh-my-posh init zsh)"
fi
