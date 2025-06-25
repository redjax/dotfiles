#!/bin/bash

CURL_INSTALLED=$(command -v curl &> /dev/null && echo 1 || echo 0)
WGET_INSTALLED=$(command -v wget &> /dev/null && echo 1 || echo 0)

CHEZMOI_URL="chezmoi.io/getlb"
CHEZMOI_INSTALL_DIR=$HOME/.local/bin

if [[ -f $HOME/bin/chezmoi ]] || [[ -f $HOME/.local/bin/chezmoi ]]; then
  if [[ -f $HOME/bin/chezmoi ]]; then
    CHEZMOI_PATH="$HOME/bin/chezmoi"
  else
    CHEZMOI_PATH="$HOME/.local/bin/chezmoi"
  fi

  echo "chezmoi is already installed at path: $CHEZMOI_PATH"

  exit 0
fi

if [[ $CURL_INSTALLED -eq 1 ]]; then
  echo "Downloading chezmoi with curl"
  sh -c "$(curl -fsLS $CHEZMOI_URL)" -- -b $CHEZMOI_INSTALL_DIR
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed installing chezmoi with curl."
    exit $?
  fi
elif [[ $WGET_INSTALLED -eq 1 ]]; then
    echo "Downloading chezmoi with wget"
    sh -c "$(wget -qO- $CHEZMOI_URL)" -- -b $CHEZMOI_INSTALL_DIR
    if [[ $? -ne 0 ]]; then
      echo "[ERROR] Failed installing chezmoi with wget."
      exit $?
    fi
else
  echo "[ERROR] wget or curl must be installed"
  exit 1
fi

if [[ ! -f $HOME/.local/bin/chezmoi ]]; then
  echo "[ERROR] chezmoi downloaded succesfully, but binary was not found at $HOME/.local/bin/chezmoi"
  exit 1
else
  echo "Chezmoi installed successfully. Reload your shell with exec \$SHELL."
  echo "Install dotfiles with chezmoi init \$GIT_USERNAME (if your repo is at github.com/\$GIT_USERNAME/dotfiles),"
  echo "  otherwise use: chezmoi init https://github.com/\$GITHUB_USERNAME/dotfiles.git"

  exit 0
fi

