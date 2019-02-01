#!/bin/bash

user = "jack"
userhome = "/home/$user"
dotfiles = "$userhome/Documents/git/dotfiles"

# This script echoes cron jobs to the crontab.
# Some scripts may need to be created/placed before echoed.

# Move scripts to place cron will look for them

mkdir /opt/scripts
	# Tilix conf backup script
cp $dotfiles/tilix/tilixbackup.sh /opt/scripts/

# Syntax:
#    (crontab -l ; echo "* * * * 1-5 command") | crontab -

(crontab -l ; echo "0 8 * * 0 /opt/scripts/tilixbackup.sh") | crontab -
