#!/bin/bash

# Create symlinks for nvim

this_dir="$(dirname "$(readlink -f "$0")")"
nvim_sym="$this_dir/nvim/"

# Symlink nvim dir
create_sym () {
    if [[ ! -e $HOME/.config/nvim ]];
    then
        cd $HOME/.config/
        ln -s $nvim_sym nvim
    fi
}

create_sym
