#!/bin/bash

# >dep indicates a line that I intend to deprecate.

# Next, we copy the init.nvim and autoload folder from the dotfiles folder
# I am trying something new here, where I create the init.vim file, and then just $cat the contents of the nvim file in the cloned directory to the new one. This way I can also simply update my init.vim folder on future releases.
mkdir ~/.config/nvim

# Copy contents of init.nvim to new init.nvim file.
touch ~/.config/nvim/init.vim
cat init.vim > ~/.config/nvim/init.vim
cp -R autoload ~/.config/nvim/

# Clone Vim-Plug into autoload directory
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Then, we'll run the VIM command to install all the Plug plugins
nvim +PlugInstall
