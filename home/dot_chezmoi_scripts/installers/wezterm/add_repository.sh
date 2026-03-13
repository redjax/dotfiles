#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
PARENT_DIR="$(dirname "$SCRIPT_PATH")"

function add_wezterm_apt_repository {
  if ! command -v curl >/dev/null 2>&1; then
    echo "[ERROR] curl is not installed"
    return 1
  fi

  echo "Adding wezterm apt repository GPG key"
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to add wezterm GPG key"
    return 1
  fi

  echo "Adding wezterm apt repository source"
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to add wezterm apt repository source"
    return 1
  fi

  echo "Updating apt package index"
  sudo apt update -y
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to update apt package index"
    return 1
  fi

  echo "Wezterm apt repository added successfully"
  return 0
}

function add_wezterm_rpm_repository {
  echo "Adding DNF Copr repository for Wezterm"
  sudo dnf copr enable wezfurlong/wezterm-nightly -y
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to add DNF Copr repository for Wezterm"
    return 1
  fi

  echo "Wezterm DNF Copr repository added successfully"
  return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  . "${PARENT_DIR}/check_installed.sh"
  . "${PARENT_DIR}/detect_distro.sh"

  LINUX_DISTRO=$(get_distro_id)

  case "${LINUX_DISTRO}" in
    ubuntu|debian|pop|linuxmint)
      add_wezterm_apt_repository
      if [[ $? -ne 0 ]]; then
        echo "Failed to install wezterm"
        exit 1
      fi

      ;;
    fedora|rhel|centos|rocky|almalinux)
      add_wezterm_rpm_repository
      if [[ $? -ne 0 ]]; then
        echo "Failed to install wezterm"
        exit 1
      fi
      ;;
    *)
      echo "Unsupported Linux distribution: ${LINUX_DISTRO}"
      exit 1
      ;;
  esac
fi
