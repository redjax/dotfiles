#!/bin/bash

# Install Enpass using instructions from their site

# Add repo to sources
echo "deb https://apt.enpass.io/ stable main" > \
  /etc/apt/sources.list.d/enpass.list

# Import key
wget -O - https://apt.enpass.io/keys/enpass-linux.key | apt-key add -
