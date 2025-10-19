#!/usr/bin/env bash

set -uo pipefail

USE_HTTP=false
VERBOSE=false

if ! command -v curl &>/dev/null; then
    echo "[ERROR] curl is not installed"
    exit 1
fi

## Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
    -v | --verbose)
        VERBOSE=true
        ;;
    esac
done

echo "[ Setup Dotfiles ]"
echo ""

if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi"

    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to install chezmoi"
        exit 1
    fi

    export PATH="$PATH:$HOME/.local/bin"
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
    echo "[ERROR] Failed applying chezmoi dotfiles."
    exit 1
fi

echo ""
echo "Dotfiles initialized"
echo ""

echo "Running 'chezmoi apply' would do the following:"
echo ""
if [[ "$VERBOSE" == true ]]; then
  chezmoi apply --dry-run --verbose
else
  chezmoi apply --dry-run

echo ""
read -n 1 -r -p "Apply dotfiles with chezmoi? (y/n) " yn

case $yn in
[Yy])
    echo "Running chezmoi apply"
    if [[ "$VERBOSE" == true ]]; then
        chezmoi apply --verbose
    else
        chezmoi apply
    fi
    
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to apply dotfiles with chezmoi."
        exit $?
    fi
    ;;
[Nn])
    echo "When you are ready to apply the dotfiles, just run 'chezmoi apply'. You can do a dry run by adding --dry-run to the command."
    exit 0
    ;;
esac
