#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl &> /dev/null; then
    echo "[ERROR] curl is not installed." >&2
    exit 1
fi

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "[WARNING] ~/.oh-my-zsh already exists." >&2

    read -r -n 1 -p "Do you want to overwrite it? [y/N] " response
    echo

    case "$response" in
        [yY][eE][sS]|[yY])
            echo "Overwriting ~/.oh-my-zsh"
            rm -rf "$HOME/.oh-my-zsh"
            ;;
        *)
            echo "Aborting installation."
            exit 0
            ;;
    esac
fi

echo "Installing Oh-My-Zsh"

if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    echo "[ERROR] Failed to install Oh-My-Zsh." >&2
    exit 1
fi
