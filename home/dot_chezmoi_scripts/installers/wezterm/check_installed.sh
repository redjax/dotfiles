#!/bin/bash

function check_installed {
    if ! command -v "$1" >/dev/null 2>&1; then
      return 1
    else
      return 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    check_installed "$1"
    if [[ $? -eq 0 ]]; then
      echo "$1 is installed"
      exit 0
    else
      echo "$1 not installed"
      exit 1
    fi
fi
