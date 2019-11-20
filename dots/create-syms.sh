#!/bin/sh

# Create symlinks for dots

# Starting out, this script will just find and run scripts.
# Eventually, I'll consolidate them into this one script.

# Symlink bash dots
this_dir="$(dirname "$(readlink -f "$0")")"

. $this_dir/symlink-bashdots.sh
. $this_dir/home/config/sym-nvim.sh
