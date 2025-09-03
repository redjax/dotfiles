#!/bin/bash

##
# Script to detect OS and install restic accordingly.
##

set -euo pipefail

function install_restic_linux() {
    ## Detect distro and install using native package managers
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION_ID=$VERSION_ID
    else
        echo "Cannot detect Linux distribution."
        exit 1
    fi

    echo "Detected Linux distro: $DISTRO version $VERSION_ID"

    case $DISTRO in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y restic
            ;;
        fedora)
            sudo dnf install -y restic
            ;;
        centos|rhel)
            sudo yum install -y epel-release
            sudo yum install -y restic
            ;;
        arch|manjaro)
            sudo pacman -Sy --noconfirm restic
            ;;
        alpine)
            sudo apk add restic
            ;;
        *)
            echo "Linux distribution $DISTRO is not supported by this script."
            echo "Please install restic manually: https://restic.readthedocs.io/en/latest/020_installation.html"
            exit 1
            ;;
    esac
}

function install_restic_macos() {
    ## Use Homebrew if available
    if command -v brew >/dev/null 2>&1; then
        echo "Installing restic using Homebrew..."
        brew install restic
    else
        echo "Homebrew not found. Please install Homebrew or install restic manually:"
        echo "https://restic.readthedocs.io/en/latest/020_installation.html"
        exit 1
    fi
}

function main() {
    OS=$(uname -s)

    case "$OS" in
        Linux)
            install_restic_linux
            ;;
        Darwin)
            install_restic_macos
            ;;
        *)
            echo "Unsupported operating system: $OS"
            exit 1
            ;;
    esac

    echo "Restic installation completed."
}

main
