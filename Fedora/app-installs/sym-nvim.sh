#!/bin/sh

# Create symlinks for nvim

this_dir="$(dirname "$(readlink -f "$0")")"
nvim_sym="$this_dir/nvim/sym-me"

# Symlink nvim dir
create_sym () {
    cd $HOME/.config/
    
    ln -s $nvim_sym nvim
}

create_sym
