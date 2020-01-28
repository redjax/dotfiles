#!/bin/bash

#
# Script to install Joplin & create desktop icon
#
# Works on Fedora/Ubuntu officially, according to Joplin's homepage

cd $HOME/Downloads
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
