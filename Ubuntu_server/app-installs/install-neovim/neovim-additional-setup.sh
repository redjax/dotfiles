#!/bin/bash

# Perform some additional setup after running other scripts

# Copy colorschemes from awesome-vim-colorschemes
mkdir -p ~/.config/nvim/colors
cp ~/.local/share/nvim/plugged/awesome-vim-colorschemes/colors/* ~/.config/nvim/colors
