#!/bin/bash

## https://wezterm.org/install/linux.html

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
PARENT_DIR="$(dirname "$SCRIPT_PATH")"

. "${PARENT_DIR}/check_installed.sh"
. "${PARENT_DIR}/add_repository.sh"
. "${PARENT_DIR}/install_nerdfont.sh"
. "${PARENT_DIR}/detect_distro.sh"

LINUX_DISTRO=$(get_distro_id)

function main {
  if command -v wezterm >/dev/null 2>&1; then
    echo "Wezterm is already installed"
    exit 0
  fi

  if ! $(check_installed curl); then
    echo "[ERROR] curl is not installed"
    return 1
  fi

  if ! $(check_installed unzip); then
    echo "[ERROR] unzip is not installed"
    return 1
  fi

  if ! $(check_installed jq); then
    echo "[ERROR] jq is not installed"
    return 1
  fi

  if ! $(check_installed fc-cache); then
    echo "[ERROR] fc-cache is not installed"
    return 1
  fi

  if ! $(check_installed wget); then
    echo "[ERROR] git is not installed"
    return 1
  fi

  case "$LINUX_DISTRO" in
    ubuntu|debian|pop|linuxmint)
      echo "Detected Debian-based distribution: $LINUX_DISTRO"

      add_wezterm_apt_repository
      if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to add wezterm apt repository"
        return 1
      fi
      
      echo "Installing wezterm"
      sudo apt install -y wezterm
      if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to install wezterm"
        return 1
      fi

      ;;
    fedora|rhel|centos|rocky|almalinux)
      echo "Detected Red Hat-based distribution: $DISTRO_ID"

      add_wezterm_rpm_repository
      sudo dnf install -y wezterm
      if [[ $? -ne 0 ]]; then
          echo "[ERROR] Failed to install wezterm"
          return 1
      fi

      ;;
    *)
      echo "[ERROR] Unsupported Linux distribution: $LINUX_DISTRO"
      return 1

      ;;
  esac

  echo "Wezterm installed successfully"
  return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
  if [[ $? -ne 0 ]]; then
    echo "Failed to install wezterm"
    exit 1
  fi

  echo "Installed wezterm successfully"
  exit 0
fi
