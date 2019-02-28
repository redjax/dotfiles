#!/bin/bash

usr='jack'
home='/home/${usr}'
gitcl='${gitcl} --verbose'

# Setup script for installing a new distro.
# ToDo: Make script distro-aware for running different commands based on
# what type of Linux I'm running the script on.

##########
# Fedora #
##########

# Install Fedy
sh -c 'curl https://www.folkswithhats.org/installer | bash'

# -------------------------------------------------------------

# Install Brave Browser Dev
# dnf config-manager --add-repo https://brave-browser-rpm-dev.s3.brave.com/x86_64/
# rpm --import https://brave-browser-rpm-dev.s3.brave.com/brave-core-nightly.asc
# dnf install -y brave-browser-dev

# Brave Browser Beta
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install brave-browser brave-keyring

# ------------------------------------------------------------

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

# Create Cron jobs

  # Create folder in /opt and copy scripts to it
  mkdir /opt/backup-scripts
  cp -R crontasks/backup-scripts/* /opt/backup-scripts

  # Create cron job for backing up Gnome
  echo "0 0 */3 * * /opt/backup-scripts/backup-gnome.sh" | crontab -

  # Restore Gnome settings on new installation
  ./opt/backup-scripts/restore-gnome.sh
# --------------------------------------------------------------

# NeoVim

# Install nvim
dnf install -y neovim

# Configure neovim

. ${home}/Documents/git/dotfiles/nvim/createvimfiles.sh

# --------------------------------------------------------------

# Install Tmux
dnf install -y tmux

# Create Tmux conf
cp ${home}/Documents/git/dotfiles/.tmux.conf ~/

# --------------------------------------------------------------

# Install Terminator
dnf install -y terminator

# --------------------------------------------------------------

# Install tilix
dnf install -y tilix

# --------------------------------------------------------------

# Install TLP, laptop battery saving
dnf install -y tlp tlp-rdw

  # Thinkpad-specific
  dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

  dnf install http://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm

  # Optional

    # akmod-tp_smapi (battery charge threshold, recalibration
    # akmod-acpi_call (X220/T420, X230/T430, etc)
    # kernel-devel (needed for akmod packages)
    dnf install -y akmod-tp_smapi akmod-acpi_call kernel-devel

# --------------------------------------------------------------

# Git install
dnf install -y git

# VSCode Install
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf check-update
dnf install -y code

# --------------------------------------------------------------
# Joaoapps Join
# curl "http://autoremotejoaomgcd.appspot.com/registerpc?key=YOUR_KEY&name=NAME_TO_APPEAR_ON_YOUR_PHONE&id=ANY_UNIQUE_ID&type=linux&publicip=YOUR_PUBLIC_IP_OR_HOST_NAME&localip=$(sudo ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}')"<Paste>

# Still need to get personal key and finish steup

# --------------------------------------------------------------
# Albert Launcher
rpm --import \ # Add repo
  https://build.opensuse.org/projects/home:manuelschneid3r/public_key

dnf install -y albert

# --------------------------------------------------------------

# Alacarte
dnf install -y alacarte

# --------------------------------------------------------------

# Android Tools (ADB, Fastboot)
dnf install -y android-tools

# --------------------------------------------------------------

# Themes, Fonts, and Icons

# Clone repo
${gitcl} https://github.com/redjax/jaxlinuxlooks.git ${home}/Documents/git/

# -Themes
. ${home}/Documents/git/jaxlinuxlooks/themesinstall.sh

# -Fonts
. ${home}/Documents/git/jaxlinuxlooks/fontsinstall.sh
