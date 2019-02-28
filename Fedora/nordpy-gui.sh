#!/bin/bash

# Clone repo
cd ~/Downloads
git clone https://github.com/morpheusthewhite/NordPy.git nordpy

# Install dependencies
dnf install -y python3 python3-tk python3-requests openvpn wget unzip strongswan strongswan-ikev2 libstrongswan-standard-plugins libstrongswan-extra-plugins libcharon-extra-plugins networkmanager-openvpn

# Run install script
cd nordpy/
./install.sh
