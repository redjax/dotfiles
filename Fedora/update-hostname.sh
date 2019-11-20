#!/bin/sh

# Update the hostname with passed argument
sudo hostnamectl set-hostname $1

echo "New hostname:"
hostname
echo "\n"

# Update networking for new hostname
sudo /etc/init.d/network restart