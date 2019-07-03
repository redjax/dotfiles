#!/bin/bash

# Install neovim on Raspberry Pi
#
# The version that comes in the Pi's repos is very out of date
# and a lot of plugins don't work with it.
#
# This script builds neovim from source for the raspberry pi

usr="pi"

# Install dependencies
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

# Clone repository
cd /home/pi/Documents/git/
git clone https://github.com/neovim/neovim
cd neovim

# Run install commands
make CMAKE_BUILD_TYPE=Release
sudo make install
pip install --user neovim

# Next, we copy the init.nvim and autoload folder from the dotfiles folder
# I am trying something new here, where I create the init.vim file, and then just $cat the contents of the nvim file in the cloned directory to the new one. This way I can also simply update my init.vim folder on future releases.
#mkdir ~/.config/nvim

# Copy contents of init.nvim to new init.nvim file.
#touch ~/.config/nvim/init.vim
#cat init.vim > ~/.config/nvim/init.vim
#cp -R autoload ~/.config/nvim/

# Clone Vim-Plug into autoload directory
#curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Then, we'll run the VIM command to install all the Plug plugins
#nvim +PlugInstall

# Install deoplete requirements for Python
pip install neovim
pip install pynvim
pip install jedi
