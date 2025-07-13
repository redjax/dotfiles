#!/bin/bash

## Detect OS
function get_os() {
  OS="$(uname -s)"

  echo "$OS"
}

## Detect CPU architecture
function get_cpu_arch() {
  ARCH="$(uname -m)"

  echo "$ARCH"
}

## Detect distro using /etc/os-release
function detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID=$ID

    echo "$DISTRO_ID"
  else
    echo "Cannot detect Linux distribution." >&2
    return 1
  fi
}

## Detect package manager based on distribution
function detect_pkg_manager() {
  ## Determine OS release and family
  if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS_RELEASE=$NAME
      OS_VERSION=${VERSION_ID:-"Unknown"}
      OS_FAMILY="Unknown"

      ## Check for ID_LIKE or use ID as a fallback
      if [ -n "$ID_LIKE" ]; then
          if echo "$ID_LIKE" | grep -q "debian"; then
              OS_FAMILY="Debian-family"
          elif echo "$ID_LIKE" | grep -q "rhel"; then
              OS_FAMILY="RedHat-family"
          fi
      elif [ -n "$ID" ]; then
          if echo "$ID" | grep -qE "debian|ubuntu"; then
              OS_FAMILY="Debian-family"
          elif echo "$ID" | grep -qE "rhel|fedora|centos"; then
              OS_FAMILY="RedHat-family"
          fi
      fi
  else
      OS_RELEASE="Unknown"
      OS_VERSION="Unknown"
      OS_FAMILY="Unknown"
  fi

  if [[ -z "$OS_FAMILY" || "$OS_FAMILY" == "Unknown" || -z "$OS_RELEASE" || "$OS_RELEASE" == "Unknown" || -z "$OS_VERSION" || "$OS_VERSION" == "Unknown" ]]; then
      echo "Cannot detect OS release info."
      return 1
  fi

  ## Determine the CPU architecture
  CPU_ARCH=$(uname -m)

  ## Export the variables
  export OS_TYPE OS_RELEASE OS_FAMILY CPU_ARCH

  ## Set PKG_MGR var
  if [[ $OS_FAMILY == "RedHat-family" ]]; then
      if [[ $DEBUG -eq 1 ]]; then
          echo "[DEBUG] RedHat-family OS detected." >&2
      fi

      if ! command -v dnf >/dev/null 2>&1; then
          echo "dnf not detected. Trying yum" >&2

          if ! command -v yum 2 >/dev/null &>1; then
              echo "[ERROR] RedHat family OS was detected, but script could not find dnf or yum package manager..."

              return 1
          else
              PKG_MGR="yum"
          fi
      else
          PKG_MGR="dnf"
      fi
  elif [[ $OS_FAMILY == "Debian-family" ]]; then
      if [[ $DEBUG -eq 1 ]]; then
          echo "[DEBUG] Debian-family OS detected." >&2
      fi

      if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
          echo "Script detected a container environment. Fallback to apt-get" >&2
          PKG_MGR="apt-get"
      else
          PKG_MGR="apt"
      fi
  else
      echo "[WARNING] Platform not supported: [ OS Family: $OS_FAMILY, Release: $OS_RELEASE, Version: $OS_VERSION ]"
      # if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
      ## Pause in a Docker environment to see output
      # sleep 6
      # fi

      return 1
  fi

  echo "$PKG_MGR"
}