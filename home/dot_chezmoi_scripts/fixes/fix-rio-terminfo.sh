#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl >&/dev/null; then
  echo "[ERROR] curl is not installed" >&2
  exit 1
fi

## Check if terminfo is already installed
if infocmp rio 2>/dev/null; then
  echo "Rio terminfo already installed"
else
  echo "Installing Rio terminfo"
  curl -o rio.terminfo https://raw.githubusercontent.com/raphamorim/rio/main/misc/rio.terminfo
  sudo tic -xe xterm-rio,rio rio.terminfo
  rm rio.terminfo
fi
