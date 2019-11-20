#!/bin/sh

this_dir="$(dirname "$(readlink -f "$0")")"
dots_dir="../../../dots"

# Install tmux
sudo dnf install -y tmux

# Symlink configuration
cd $dots_dir/app-dots
ln -s .tmux.conf $HOME/.tmux.conf
