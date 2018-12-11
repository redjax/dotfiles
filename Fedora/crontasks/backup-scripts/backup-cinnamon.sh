#!/bin/bash

usr="jack"

# Backup Cinnamon settings
dconf dump /org/cinnamon > /home/$usr/cinnamon-backup.txt
