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
