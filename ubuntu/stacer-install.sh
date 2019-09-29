#!/bin/bash

# Install Stacer, a system profiler/cleaner

dlfolder="/home/jack/Downloads/"
ver="1.1.0"
fullappname="Stacer_${ver}_amd64.deb"
dlurl="https://github.com/oguzhaninan/Stacer/releases/download/v${ver}/${fullappname}"

# Change to downloads & get package
cd ${dlfolder}
wget ${dlurl}

# Install app
sudo dpkg --install ${fullappname}
