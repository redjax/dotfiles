#!/bin/bash

#$user = "jack"
#$userhome = "/home/$user"
#$dotfiles = "$userhome/Documents/git/dotfiles"

dconf dump /com/gexperts/Tilix/ > /home/jack/Documents/git/dotfiles/tilix/tilix.dconf
