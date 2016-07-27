#!/bin/bash

# First, download the dotfiles folder
git clone git://github.com/redjax/dotfiles ~/dotfiles

# Then, we'll install Vundle before anything else
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Next, we copy the vimrc and vim folder from the dotfiles folder
cp dotfiles/vim/.vimrc ~/.vimrc
cp -R dotfiles/vim/.vim ~/.vim

#Then, we'll run the VIM command to install all the Vundle plugins
yes | vim +PluginInstall +qall
