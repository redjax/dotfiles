#!/bin/bash

# Create symlinks for nano

this_dir="$(dirname "$(readlink -f "$0")")"
nano_sym="$this_dir/nano/.nanorc"
nano_dot_sym="${this_dir}/nano/.nano"

create_sym () {
    if [[ ! -e $HOME/.nanorc ]];
    then
        cd $HOME/
        ln -s $nano_sym .nanorc
    fi
}

create_sym2 () {
    if [[ ! -e $HOME/.nano ]];
    then
        cd $HOME
        ln -s $nano_dot_sym .nano
    fi
}
create_sym
create_sym2
