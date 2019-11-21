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

# Search for running process
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

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

####################
# Custom Functions #
####################

# Create a directory & cd to it
mkcd () {
    mkdir -p $1
    cd $1
}

# Run proper extract command based on file extension
function extract {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

###############
# Environment #
###############

export EDITOR=nvim
export TERM=xterm-256color
