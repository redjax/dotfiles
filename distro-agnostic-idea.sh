#!/bin/bash

# Setup script that will check which distro a user is running, and change commands based on distro.
# DOES NOT WORK IN CURRENT STATE.

# +-------------[Variables]-------------+
# Distro variables
distro=na  # Set this to be current distro, i.e. "fedora"
disver=na # Set this to current distro version, i.e. "26"

# Install syntax
fedin='dnf install'
ubuin='apt-get install'
arcin='pacman -S'

# Distro-specific "no confirm" syntax
fedin-noconf='-y'
ubuin-noconf='-y'
arcin-noconf='--noconfirm'

# User/environment variables
usern='jack'
gitfolder='/home/'"$usern"'/Documents/git/'

# +-------------[Script]-------------+
