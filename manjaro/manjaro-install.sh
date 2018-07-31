#!/bin/bash

# Run this script after installing Manjaro.
# Many commands here from: http://stephenmyall.com/manjaro/

#+---------------------------------------------------------

# Variables
usern=jack

# Update to fastest Manjaro mirrors
pacman-mirrors -g
# R/W access to /usr/share
chown -R $usern /usr/share

# Upgrade/optimize Pacman database
pacman-db-upgrade --noconfirm && pacman-optimize --noconfirm && sync

# Install multimedia codecs
pacman -S exfat-utils fuse-exfat a52dec faac faad2 flac jasper lame libdca 
libdv gst-libav libmad libmpeg2 libtheora libvorbis libxv wavpack x264 
xvidcore gstreamer0.10-plugins flashplugin libdvdcss libdvdread libdvdnav 
gecko-mediaplayer dvd+rw-tools dvdauthor dvgrab --noconfirm

# File utilities
pacman -S file-roller seahorse-nautilus nautilus-share zlib unzip zip

# Printer utilities
pacman -S lib32-libcups cups gutenprint libpaper foomatic-db-engine 
ghostscript gsfonts foomatic-db foomatic-filters cups-pdf 
system-config-printer --noconfirm

    # Enable printer utils
systemctl enable org.cups.cupsd.service
systemctl enable cups-browsed.service
systemctl start org.cups.cupsd.service
systemctl start cups-browsed.service

# Enable numlock at startup
gsettings set org.gnome.settings-daemon.peripherals.keyboard numlock-state 
on

# Install preload to speed up performance
pacman -S preload --noconfirm
systemctl enable preload.service

# Install Neovim
pacman -S neovim --noconfirm
. ~/Documents/git/dotfiles/nvim/createvimfiles.sh

# +------------------------------------------------+

# Fonts
pacman -Ss adobe-source-code-pro-fonts --noconfirm

yaourt -S visual-studio-code-bin --noconfirm
