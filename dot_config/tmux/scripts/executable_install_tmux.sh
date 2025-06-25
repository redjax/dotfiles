#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
PARENT_DIR="$(dirname "$SCRIPT_PATH")"

## Source functions from other scripts
. "${PARENT_DIR}/install_tpm.sh"
. "${PARENT_DIR}/install_xclip.sh"
. "${PARENT_DIR}/install_fzf.sh"
. "${PARENT_DIR}/install_lazygit.sh"

. "${PARENT_DIR}/get_distro.sh"
LINUX_DISTRO=$(get_distro_id)

echo "--[ Installing tmux dependencies"
install_xclip
install_fzf
install_lazygit

echo "--[ Installing tmux"
if ! command -v tmux 2>&1 > /dev/null; then
  case "$LINUX_DISTRO" in
    ubuntu|debian|pop|linuxmint)
      sudo apt install -y tmux
      if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed installing tmux"
        exit 1
      fi

      ;;
    fedora|rhel|centos|rocky|almalinux)
      sudo dnf install -y tmux
      if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed installing tmux"
        exit 1
      fi

      ;;
    *)
      echo "[ERROR] Unsupported distro: $LINUX_DISTRO"
      exit 1

      ;;
  esac

  echo "Tmux installed successfully."
else
    echo "Tmux is already installed."
fi

echo "--[ Installing Tmux Plugin Manager (tpm)"
install_tpm
