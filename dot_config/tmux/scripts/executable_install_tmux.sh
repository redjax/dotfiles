#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
PARENT_DIR="$(dirname "$SCRIPT_PATH")"

## Source functions from other scripts
. "${PARENT_DIR}/install_tpm.sh"
. "${PARENT_DIR}/install_xclip.sh"
. "${PARENT_DIR}/install_fzf.sh"
. "${PARENT_DIR}/install_lazygit.sh"

echo "--[ Installing tmux dependencies"
install_xclip
install_fzf
install_lazygit

echo "--[ Installing tmux"
if ! command -v tmux 2>&1 > /dev/null; then
    sudo apt install -y tmux
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed installing tmux"
        exit 1
    fi

    echo "Tmux installed successfully."
else
    echo "Tmux is already installed."
fi

echo "--[ Installing Tmux Plugin Manager (tpm)"
install_tpm
