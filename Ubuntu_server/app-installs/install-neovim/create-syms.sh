#!/bin/bash

# sym init.vim
if [[ ! -e $HOME/.config/nvim/init.vim ]];
then
  ln -s ${PWD}/config/init.vim $HOME/.config/nvim/
fi

# sym awesome-vim-themes colors dir
if [[ ! -e $HOME/.config/nvim/colors/ ]];
then
  ln -s ${PWD}/config/colors $HOME/.config/nvim/
fi

