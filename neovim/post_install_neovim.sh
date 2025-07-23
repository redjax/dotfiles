#!/bin/bash

echo "Installing VimPlug plugins"
nvim "+PlugInstall" "+qall"

echo "Running VimPlug update"
nvim "+PlugUpdate" "+qall"

# echo "Run coc#util#install()"
# nvim --headless "+call coc#util#install()" +qall

# Symlink awesome-vim-colorschemes/colors dir to nvim's colors dir
ln -s ~/.local/share/nvim/plugged/awesome-vim-colorschemes/colors/ ~/.config/nvim/colors
