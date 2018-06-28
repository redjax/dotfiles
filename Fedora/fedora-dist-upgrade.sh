#!/bin/bash
# Script to upgrade Fedora. Pass the desired version as an argument when
# running the script, i.e. "./fedora-dist-upgrade.sh 28"

# Refresh upgrades list
dnf upgrade -y --refresh

# Install DNF plugin, if it's not installed
dnf install dnf-plugin-system-upgrade -y

# Start upgrade
dnf system-upgrade download -y --releasever=$1

# Reboot system to finish upgrade
dnf system-upgrade reboot
