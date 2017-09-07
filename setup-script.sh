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
dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo

# Update DNF and install Sublime
dnf install -y sublime-text

# --------------------------------------------------------------

# NeoVim

# Install nvim
dnf install -y neovim

# Configure neovim

. ~/Documents/github/dotfiles/nvim/createvimfiles.sh

# --------------------------------------------------------------

# Git install
dnf install -y git

# --------------------------------------------------------------

# Themes, Fonts, and Icons

# Clone repo
git clone https://github.com/redjax/jaxlinuxlooks.git ~/Documents/github/

# -Themes
. ~/Documents/github/jaxlinuxlooks/themesinstall.sh

# -Fonts
. ~/Documents/github/jaxlinuxlooks/fontsinstall.sh
