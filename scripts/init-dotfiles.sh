#!/usr/bin/env bash

set -euo pipefail

USE_HTTP=true
VERBOSE=false

if ! command -v curl &>/dev/null; then
    echo "[ERROR] curl is not installed" >&2
    exit 1
fi

## Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
    -v | --verbose)
        VERBOSE=true
        shift
        ;;
    esac
done

echo "[ Setup Dotfiles ]"
echo ""

if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi"

    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to install chezmoi" >&2
        exit 1
    fi

    export PATH="$PATH:$HOME/.local/bin"

    echo ""
    echo "Chezmoi installed. Add this to your ~/.bashrc:"
    echo "  export PATH=\"\$PATH:\$HOME/.local/bin\""
fi

if [[ "$USE_HTTP" == "true" ]]; then
    dotfiles_url="https://github.com/redjax/dotfiles.git"
else
    dotfiles_url="git@github.com:redjax/dotfiles.git"
fi

echo "Using dotfiles URL: $dotfiles_url"
echo ""

chezmoi init redjax
if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed applying chezmoi dotfiles." >&2
    exit 1
fi

echo ""
echo "Dotfiles initialized"
echo ""

echo "Running 'chezmoi apply' would do the following:"
echo ""
chezmoi apply --dry-run --verbose

echo ""
echo "Review the 'dry run' above to make sure you want to apply these changes."

echo ""
read -n 1 -r -p "Apply dotfiles with chezmoi? (y/n) " yn

case $yn in
[Yy])
    echo "Running chezmoi apply"
    if [[ "$VERBOSE" == true ]]; then
        if ! chezmoi apply --verbose >&2; then
            echo "[ERROR] Failed applying dotfiles with chezmoi" >&2
        fi
    else
        if ! chezmoi apply >&2; then
            echo "[ERROR] Failed applying dotfiles with chezmoi" >&2
        fi
    fi

    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to apply dotfiles with chezmoi." >&2
        exit $?
    fi
    ;;
[Nn])
    echo "When you are ready to apply the dotfiles, just run 'chezmoi apply'. You can do a dry run by adding --dry-run to the command."
    echo "If you get an error saying something like 'command chezmoi not found,' make sure you have this in your ~/.bashrc:"
    echo "  export PATH=\"\$PATH:\$HOME/.local/bin\""

    exit 0
    ;;
esac
