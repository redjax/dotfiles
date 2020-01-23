#!/bin/bash

# Symlink tmux conf
if [[ ! -e $HOME/.tmux.conf ]];
then
    ln -s ${PWD}/home/.tmux.conf $HOME/
fi

# Symlink .bash_aliases
if [[ -e $HOME/.bash_aliases ]];
then
    mv $HOME/.bash_aliases $HOME/.bash_aliases.bak
    ln -s ${PWD}/home/.bash_aliases $HOME/
fi

# Symlink .profile
if [[ -e $HOME/.profile ]];
then
    mv $HOME/.profile $HOME/.profile.bak
    ln -s ${PWD}/home/.profile $HOME/
fi

# Symlink fail2ban jail.local
if [[ ! -e /etc/fail2ban/jail.local ]];
then
    sudo ln -s ${PWD}/etc/fail2ban/jail.local /etc/fail2ban/jail.local
# If jail.local already exists, make a copy and Symlink
elif [[ -e /etc/fail2ban/jail.local ]];
then
    sudo mv /etc/fail2ban/jail.local /etc/fail2ban/jail.local.bak
    sudo ln -s ${PWD}/etc/fail2ban/jail.local /etc/fail2ban/jail.local
fi

# Symlink ~/.local/share directory
if [[ -e $HOME/.local/share/nano ]];
then
    sudo mv $HOME/.local/share/nano $HOME/.local/share/nano-bak
    ln -s ${PWD}/.local/share/nano/ $HOME/.local/share/nano
fi

if [[ -e $HOME/.local/share/nvim ]];
then
    sudo mv $HOME/.local/share/nvim $HOME/.local/share/nvim-bak
    ln -s ${PWD}/.local/share/nvim $HOME/.local/share/nvim
fi
