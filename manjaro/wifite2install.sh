#!/bin/bash
# Script to install Wifite2 from https://github.com/derv82/wifite2

# Ensure dependencies are met
pacman -S iwconfig ifconfig aircrack-ng aireplay-ng airmon-ng airodump-ng packetforge-ng --noconfirm

# Optional dependencies
pacman -S wireshark-cli wireshark-common wireshark-gtk --noconfirm

# Install Wifite
cd /opt/
git clone https://github.com/derv82/wifite2.git
echo "Wifite2 installed in /opt/wifite2"
