#!/bin/sh

# Create symlinks for nvim

this_dir="$(dirname "$(readlink -f "$0")")"
powerline_sym="$this_dir/powerline/sym-me"

# Symlink powerline dir
create_sym () {
    cd $HOME/.config/

    ln -s $powerline_sym powerline
}

create_sym
