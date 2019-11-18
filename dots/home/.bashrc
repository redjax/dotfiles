# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don$HOMEt like systemctl$HOMEs auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# Source bash_aliases file
if [[ -f ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi
