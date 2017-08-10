#!/bin/bash

# First, download the dotfiles folder
git clone git://github.com/redjax/dotfiles ~/dotfiles

# Next, we copy the vimrc and vim folder from the dotfiles folder
mkdir ~/.config/nvim
cp dotfiles/nvim/init.vim ~/.config/nvim/init.vim

# Copy extra folders
cp -R dotfiles/nvim/bundle ~/.config/nvim/
cp -R dotfiles/nvim/plugged ~/.config/nvim/plugged

# Then, we'll install Vundle before anything else
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

#Then, we'll run the VIM command to install all the Vundle plugins
# yes | nvim +PluginInstall +qall

chmod u+x vundleupdate.sh
./vundleupdate.sh
