#!/bin/bash

usr="jack"

# Dump extensions list to backup file
dconf dump /org/gnome/shell/extensions/ > /home/$usr/Documents/backup/gnome_backup.txt
