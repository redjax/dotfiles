#!/bin/bash

user = "jack"
# Install git
apt-get install -y git

# Create environment
mkdir /home/$user/Documents/git
cd /home/$user/Documents/git

# Clone repo, make, and install
git clone https://github.com/kaduke/Netgear-A6210 Netgear-A6210
cd Netgear-A6210
make
make install
