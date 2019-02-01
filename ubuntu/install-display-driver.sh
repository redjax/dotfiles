#!/bin/bash

# Change to correct driver if autoinstall does not work
driver = ""

# Detect device driver in case autoinstall doesn't work
ubuntu-drivers devices

# Try autoinstall
ubuntu-drivers autoinstall

# If autoinstall does not work, comment out autoinstall
# & uncomment below line
#apt-get install -y $driver
