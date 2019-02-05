#!/bin/bash

usr="jack"

# Restore Cinnamon backup
dconf load /org/cinnamon/ < /home/$usr/cinnamon-backup.txt
