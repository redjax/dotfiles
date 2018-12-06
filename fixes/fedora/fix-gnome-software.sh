#!/bin/bash

# Search for gnome-software process & kill
kill -9 $(pidof gnome-software)

# Rebuild rpmdb
rpmdb -v --rebuilddb
