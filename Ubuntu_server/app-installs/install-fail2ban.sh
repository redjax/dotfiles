#!/bin/bash

# Install fail2ban
sudo apt install -y fail2ban

# Enable & start fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

