#!/bin/sh
# Create symlinks to my .bash[rc/_aliases/_profile]

this_dir="$(dirname "$(readlink -f "$0")")"

# Create backups of current files
create_backup () {
    if [[ -f $1 ]]; then
        mv $1 $1.bak
    fi
}

# Make symlinks
create_sym () {
    this_dir="$(dirname "$(readlink -f "$0")")"
    home_dots="$this_dir/home"

    cd $HOME
    ln -s $home_dots/$1

}

create_backup $HOME/.bashrc
create_backup $HOME/.bash_aliases
create_backup $HOME/.bash_profile
create_backup $HOME/.tmux
create_backup $HOME/.tmux.conf

# Create symlinks
create_sym .bashrc
cd $this_dir
create_sym .bash_aliases
cd $this_dir
create_sym .bash_profile
cd $this_dir
create_sym .tmux.conf
cd $this_dir
create_sym .tmux/

# Source new bashrc
if [[ -f $HOME/.bashrc ]]; then
    . $HOME/.bashrc
fi
