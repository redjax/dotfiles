#!/bin/bash

usr="jack"

# Restore the configuration
dconf load /org/gnome/shell/extensions/ < /home/$usr/gnome/gnome_backup.txt
