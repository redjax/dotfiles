#!/bin/bash

# This is for personal use. I am trying to get my setup script to recognize
# which OS the computer is running. I like to distro-hop, so I am hoping to build my setup
# script around these checks.

# ----------------------------------------------------------------------------------------

OS="$(lsb_release -is)"
OSRELEASE="$(lsb_release -sr)"

if [[  $OS=="Fedora" ]]
then

    # If Fedora 22 or higher, use DNF
    if [[ $OSRELEASE>21 ]]
        then
            # Use dnf instead of YUM for
            echo "Your release is higher than 21."

    elif [[ $OSRELEASE<22 ]]
        then
            . ~/Documents/github/dotfiles/setup-scripts/fedora-setup.sh
    fi

elif [[ $OS=="Ubuntu" ]]
    then
        # If using Ubuntu, use "apt-get"
        echo "You are using Ubuntu."

elif [[ $OS=="Arch" ]]
    then
        # Use pacman
        echo "You are using Arch."

else
    echo "Could not discover OS."

fi
