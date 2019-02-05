#!/bin/bash

usr="jack"

# Dump extensions list to backup file
dconf dump /org/gnome/shell/extensions/ > /home/$usr/gnome_backup.txt
