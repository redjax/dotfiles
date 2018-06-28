#!/bin/bash

# Install i3 and i3 components
dnf install -y i3 i3status dmenu conky

# To re-run the setup wizard, type: i3-config-wizard

# Add i3 exec to .xinitrc
echo "exec i3" > ~/.xinitrc

# Remove and mask gdm
#systemctl mask gdm.service
#dnf remove gdm
# Undo gdm removal
#dnf install -y gdm
#systemctl enable gdm.service

# Disable Gnome automatic updates
#dconf write /org/gnome/software/download-updates false
# Enable Gnome automatic updates (going back to Gnome/Cinnamon
#dconf write /org/gnome/software/download-updates true

# Enable lightdm
#systemctl enable lightdm.service

# i3 Utilities install
dnf install xbacklight NetworkManager-tui scrot ImageMagick pavucontrol feh arandr i3lock dunst xcompmgr network-manager-applet nethogs

