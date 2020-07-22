#!/bin/bash

# Tired of doing this shit every new install

# Install node
sudo dnf install -y nodejs nodjs-yarn

# Stop yarn's lockfile check
grep -qxF 'no-lockfile true' ~/.yarnrc || echo 'no-lockfile true' >> ~/.yarnc

# Install pynvim package
pip3 install --user pynvim

# Install npm's neovim module
sudo npm install -g neovim

# Add neovim module to yarn
sudo yarn global add neovim

# Call neovim and run the install stuff
nvim +'call coc#util#install()'
