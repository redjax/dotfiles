# .bash_aliases

# Custom bash aliases

alias ls='ls --color=auto'
alias lsa='ls -a --color=auto'
alias lsla='ls -la --color=auto'
alias lsl='ls -l'

alias tmuxls='tmux ls'
alias tmuxa='tmux a -t $1'

# Run aliases as sudo

alias sudo='sudo '

# Source bashrc

alias bashrcs='source ~/.bashrc'

# Fix bullshit that happens from using a Windows environment to edit this stuff
alias d2u='dos2unix $1'

export EDITOR=nvim
export TERM=xterm-256color
