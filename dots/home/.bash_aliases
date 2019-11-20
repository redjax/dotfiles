# .bash_aliases

###################
# System Commands #
###################

# Make ls more useful
alias ls='ls --color=auto'
alias lsa='ls -a --color=auto'
alias lsla='ls -la --color=auto'
alias lsl='ls -l --color=auto'

# Run aliases as sudo
alias sudo='sudo '

# Source bashrc
alias bashrcs='source ~/.bashrc'

# Shorten systemctl
alias sctl='systemctl '

########
# Tmux #
########

alias tmuxls='tmux ls'
alias tmuxa='tmux a -t $1'

##########
# Custom #
##########

# Quick edit bash_aliases
alias addalias='$EDITOR $HOME/.bash_aliases'

# Fix bullshit that happens from using a Windows environment to edit this stuff
alias d2u='dos2unix $1'

###############
# Environment #
###############

export EDITOR=nvim
export TERM=xterm-256color
