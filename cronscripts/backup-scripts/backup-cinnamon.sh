#!/bin/bash

usr="jack"

# Backup Cinnamon settings
dconf dump /org/cinnamon > /home/$usr/Documents/backup/cinnamon-backup.txt
