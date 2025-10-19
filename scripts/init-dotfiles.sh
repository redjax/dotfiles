#!/usr/bin/env bash

set -uo pipefail

USE_HTTP=false

if ! command -v curl &>/dev/null; then
    echo "[ERROR] curl is not installed"
    exit 1
fi

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
chezmoi apply --dry-run -v 2>&1 | tee chezmoi_dry_run.log

echo ""
read -n 1 -r -p "Apply dotfiles with chezmoi? (y/n) " yn

case $yn in
[Yy])
    echo "Running chezmoi apply"
    chezmoi apply -v 2>&1 | tee chezmoi_apply.log
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
