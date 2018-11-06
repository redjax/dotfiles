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

# --------------------------------------------------------------

# NeoVim

# Install nvim
dnf install -y neovim

# Configure neovim

. ~/Documents/git/dotfiles/nvim/createvimfiles.sh

# --------------------------------------------------------------

# Install Tmux
dnf install -y tmux

# Create Tmux conf
cp ~/Documents/git/dotfiles/.tmux.conf ~/

# --------------------------------------------------------------

# Install Terminator
dnf install -y terminator

# --------------------------------------------------------------

# Git install
dnf install -y git

# VSCode Install
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf check-update
dnf install -y code

# --------------------------------------------------------------

# Albert Launcher
rpm --import \ # Add repo
  https://build.opensuse.org/projects/home:manuelschneid3r/public_key

dnf install -y albert

# --------------------------------------------------------------

# Alacarte
dnf install -y alacarte

# --------------------------------------------------------------

# Themes, Fonts, and Icons

# Clone repo
git clone --progress https://github.com/redjax/jaxlinuxlooks.git ~/Documents/git/

# -Themes
. ~/Documents/github/jaxlinuxlooks/themesinstall.sh

# -Fonts
. ~/Documents/github/jaxlinuxlooks/fontsinstall.sh
