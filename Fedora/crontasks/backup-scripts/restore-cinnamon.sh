#!/bin/bash

usr="jack"

# Restore Cinnamon backup
dconf load /org/cinnamon/ < /home/$usr/Documents/backup/cinnamon-backup.txt
