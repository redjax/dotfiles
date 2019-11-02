#!/bin/bash
# Setup script for Fedora
#
#

# Create variables
gitcl='${gitcl} --verbose'
this_dir="$(dirname "$(readlink -f "$0")")"  # Get path to script in case it's not in my regular spot
app_installs="$this_dir/app-installs"
app_install_scripts="$app_installs/app-install-scripts"
crontasks_dir="$this_dir/crontasks"

# --------------------------------------------------------------

function install_dnf_apps () {
    # Install apps via dnf if no app-install script exists
    apps="git curl python3 python3-pip tmux terminator tilix alacarte android-tools"

    echo -e "\n Installing $apps\n"
    sudo dnf install -y $apps
}

function install_apps () {
    # Loop over app-installs dir & run app install scripts
    for script in $app_install_scripts
    do
        $(./$script)
    done
}

function install_nvim () {
    # Install nvim
    echo -e "\nRunning nvim install script\n"
    nvim_installer="$app_installs/nvim-setup.sh"
    exec $nvim_installer
}

function create_cron_jobs () {
    # Move cron jobs into cron dir & create cron jobs

    # Create folder in /opt and copy scripts to it
    exec $(mkdir /opt/backup-scripts)
    exec $(cp -R "$crontasks_dir/backup-scripts/*" /opt/backup-scripts)

    # Create cron job for backing up Gnome
    echo "0 0 */3 * * /opt/backup-scripts/backup-gnome.sh" | crontab -

    # Restore Gnome settings on new installation
    # ./opt/backup-scripts/restore-gnome.sh
}

function main () {
    # Main script to run functions

    clear
    # Install dnf apps first
    install_dnf_apps

    # Run nvim install script
    # install_nvim

    # Run the app install scripts in app-install-scripts
    # install_apps
}

main

# Themes, Fonts, and Icons

# Clone repo
# ${gitcl} https://github.com/redjax/jaxlinuxlooks.git ${home}/Documents/git/

# # -Themes
# . ${home}/Documents/git/jaxlinuxlooks/themesinstall.sh

# # -Fonts
# . ${home}/Documents/git/jaxlinuxlooks/fontsinstall.sh
