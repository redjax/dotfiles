#!/bin/bash

# Orchestrate scripts to install neovim

# Create ~/.config/nvim directory
mkdir -p ~/.config/nvim

# Start with dependencies install
./install-dependencies.sh

# Install vim-plug
./install-vimplug.sh

# Create symlinks
./create-syms.sh

# Run additional setup script
./neovim-additional-setup.sh

# Run neovim and :PlugInstall
nvim --headless +PlugInstall +qa

echo -e "\n"
echo -e "\n"
echo "Now running :PlugInstall in the background"
echo -e "\n"
