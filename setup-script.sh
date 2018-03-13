#!/bin/bash

# Setup script for installing a new distro.
# ToDo: Make script distro-aware for running different commands based on
# what type of Linux I'm running the script on.

##########
# Fedora #
##########

# Install Fedy
sh -c 'curl https://www.folkswithhats.org/installer | bash'

# -------------------------------------------------------------

# Install Sublime Text
# -Install GPG Key
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

# -Select Channel (choose 1)
#   -STABLE
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
#   -DEV
#dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo

# Update DNF and install Sublime
dnf install -y sublime-text

# Install Sublime Text from tarball
wget https://download.sublimetext.com/sublime_text_3_build_3126_x64.tar.bz2 ~/Downloads
cd ~/Downloads
tar xzvf sublime_text_3_build_*.tar.bz2
rm sublime_text_3_build_*.tar.bz2


# --------------------------------------------------------------

# NeoVim

# Install nvim
dnf install -y neovim

# Configure neovim

. ~/Documents/github/dotfiles/nvim/createvimfiles.sh

# --------------------------------------------------------------

# Install Tmux
dnf install -y tmux

# Create Tmux conf
cp ~/Documents/github/dotfiles/.tmux.conf ~/

# --------------------------------------------------------------

# Install Terminator
#dnf install -y terminator

# --------------------------------------------------------------

# Git install
#dnf install -y git

# Install Python
    # Fedora
    dnf install -y py3

# Install Python Virtualenv
    # Fedora
    dnf install -y python-virtualenv

# OpenVPN/NordVPN Install
    dnf install -y openvpn

    cd /etc/openvpn
    wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip

    dnf install -y ca-certificates
    dnf install -y unzip

    unzip ovpn.zip
    rm zip
# --------------------------------------------------------------

# Themes, Fonts, and Icons

# Clone repo
#git clone https://github.com/redjax/jaxlinuxlooks.git ~/Documents/github/

# -Themes
#. ~/Documents/github/jaxlinuxlooks/themesinstall.sh

# -Fonts
#. ~/Documents/github/jaxlinuxlooks/fontsinstall.sh
