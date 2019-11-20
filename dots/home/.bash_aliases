# .bash_aliases

#
# OS Specific
#
# This code is not ready to use yet, but the template
# can be used to create os-specific aliases.
#
### Get os name via uname ###
# _myos="$(uname)"
#
### add alias as per os using $_myos ###
#case $_myos in
#       Linux) alias foo='/path/to/linux/bin/foo';;
#          FreeBSD|OpenBSD) alias foo='/path/to/bsd/bin/foo' ;;
#             SunOS) alias foo='/path/to/sunos/bin/foo' ;;
#                *) ;;
#            esac
#


# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
        alias reboot='sudo reboot'
            alias update='sudo apt-get upgrade'
fi

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

# Quick steps with cd
alias ..='cd ..'
alias ....='cd ../../'
alias ......='cd ../../../'

# Create parent directories as needed
alias mkdir='mkdir -pv'

# Colorize diff output
alias diff='colodiff'

# Resume wget downloads by default
alias wget='wget -c'

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
