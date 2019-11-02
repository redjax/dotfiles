#!/bin/bash
gitcl='${gitcl} --verbose'
this_dir="$(dirname "$(readlink -f "$0")")"
app_installs="$this_dir/app-installs"
app_install_scripts="$app_installs/app-install-scripts"
crontasks_dir="$this_dir/crontasks"

# Setup script for installing a new distro.
# ToDo: Make script distro-aware for running different commands based on
# what type of Linux I'm running the script on.

##########
# Fedora #
##########

# Install dependencies for the rest of the script
sudo dnf install -y git curl python3 python3-pip

# Install nvim
nvim_installer="$app_installs/nvim-setup.sh"
./$nvim_installer

# ------------------------------------------------------------

# Install Sublime Text
sublime_installer="$app_install_scripts/sublime-text-install.sh"
./$sublime_installer

# --------------------------------------------------------------

# Create Cron jobs

  # Create folder in /opt and copy scripts to it
  mkdir /opt/backup-scripts
  cp -R "$crontasks_dir/backup-scripts/*" /opt/backup-scripts

  # Create cron job for backing up Gnome
  echo "0 0 */3 * * /opt/backup-scripts/backup-gnome.sh" | crontab -

  # Restore Gnome settings on new installation
  # ./opt/backup-scripts/restore-gnome.sh
# --------------------------------------------------------------

# Install Tmux
sudo dnf install -y tmux

# Create Tmux conf
cp "$HOME/Documents/git/dotfiles/.tmux.conf ~/"

# --------------------------------------------------------------

# Install Terminator
sudo dnf install -y terminator

# --------------------------------------------------------------

# Install tilix
sudo dnf install -y tilix

# --------------------------------------------------------------

# Install TLP, laptop battery saving
tlp_installer="$app_install_scripts/tlp-install.sh"
./$tlp_installer
# --------------------------------------------------------------

# VSCode Install
vscode_installer="$app_install_scripts/vscode-install.sh"
./$vscode_installer

# --------------------------------------------------------------

# Albert Launcher
albert_installer="$app_install_scripts/albert-installer.sh"
./$albert_installer

# --------------------------------------------------------------

# Alacarte
sudo dnf install -y alacarte

# --------------------------------------------------------------

# Android Tools (ADB, Fastboot)
sudo dnf install -y android-tools

# --------------------------------------------------------------

# Themes, Fonts, and Icons

# Clone repo
# ${gitcl} https://github.com/redjax/jaxlinuxlooks.git ${home}/Documents/git/

# # -Themes
# . ${home}/Documents/git/jaxlinuxlooks/themesinstall.sh

# # -Fonts
# . ${home}/Documents/git/jaxlinuxlooks/fontsinstall.sh
