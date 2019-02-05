#!/bin/bash

usr="jack"

# Restore the configuration
dconf load /org/gnome/shell/extensions/ < /home/$usr/Documents/backup/gnome_backup.txt
