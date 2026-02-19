# extends history size
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

# set vi mode
set -o vi

# bind fzf to zsh (use ctrl-r to search cmd history)
source <(fzf --zsh)

# change directories without cd
setopt autocd

# initializes zsh completion system
autoload -U compinit; compinit

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# zsh plugins
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship
eval "$(starship init zsh)"

# Git aliases
alias gst='git status'
alias gp='git push'
alias grb='git rebase'
alias gaa='git add .'
alias gcmsg='git commit -m'
alias gc!='git commit --ammend'
alias gd='git diff --color-words'
alias gco='git checkout'


