#!/bin/bash

# Install Brave beta browser

apt install -y curl

curl -s https://brave-browser-apt-beta.s3.brave.com/brave-core-nightly.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-beta.gpg add -

source /etc/os-release

echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ $UBUNTU_CODENAME main" | tee /etc/apt/sources.list.d/brave-browser-beta-${UBUNTU_CODENAME}.list

apt update

apt install brave-browser-beta
