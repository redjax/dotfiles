#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
PARENT_DIR="$(dirname "$SCRIPT_PATH")"

. "${PARENT_DIR}/get_distro.sh"
LINUX_DISTRO=$(get_distro_id)

function install_fzf {
    if command -v fzf 2>&1 > /dev/null; then
        echo "fzf is already installed."
        return 0
    fi

    echo "Installing fzf"

    case "$LINUX_DISTRO" in
      ubuntu|debian|pop|linuxmint)
        sudo apt install -y fzf
        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to install fzf"
            return 1
        fi

        ;;
      fedora|rhel|centos|rocky|almalinux)
        sudo dnf install -y fzf
        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to install fzf"
            return 1
        fi

        ;;
      *)
        echo "[ERROR] Unsupported distro: $LINUX_DISTRO"
        return 1
        ;;
    esac

    echo "fzf installed"
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_fzf "$@"
  if [[ $? -ne 0 ]]; then
    echo "Failed to install fzf"
    exit 1
  fi
fi
