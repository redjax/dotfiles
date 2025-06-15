#!/bin/bash

if ! command -v git > /dev/null 2>&1; then
  echo "[ERROR] git is not installed"
  exit 1
fi

if [[ -d /tmp/pl-fonts ]]; then
  echo "Powerline fonts were already downloaded. Attempting to install."
else
    echo "Cloning powerline fonts"
    git clone --depth 1 https://github.com/powerline/fonts /tmp/pl-fonts
    if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed cloning powerline fonts"
    exit 1
    fi
fi

cd /tmp/pl-fonts

echo "Installing powerline fonts"
./install.sh
if [[ $? -ne 0 ]]; then
  echo "[ERROR] Failed installing powerline fonts"
  exit 1
fi

echo "Powerline fonts installed"
exit 0
