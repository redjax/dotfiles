#!/bin/bash

## Ripped off from https://github.com/ryanoasis/nerd-fonts?tab=readme-ov-file#option-7-install-script

function install_nerdfont {
    FONT_NAME=$1
    REPO_PATH=$2

    if ! command -v git --version > /dev/null 2>&1 ; then
        echo "[ERROR] git is not installed."
        exit 1
    fi

    if [[ "${FONT_NAME}" == "" ]]; then
        FONT_NAME="Hack"
    fi

    if [[ "${REPO_PATH}" == "" ]]; then
        REPO_PATH="$HOME/.nerdfonts"
    fi

    if [[ ! -d "${REPO_PATH}" ]]; then
        echo "Cloning ryanoasis/nerd-fonts to ${REPO_PATH}"
        git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git "${REPO_PATH}"
        if [[ $? -ne 0 ]]; then
            echo "[ERROR] error while cloning ryanoasis/nerd-fonts to ${REPO_PATH}"
            exit 1
        fi
    fi

    echo "Installing font ${FONT_NAME}"
    "${REPO_PATH}/install.sh" "${FONT_NAME}"
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] error while installing font ${FONT_NAME}"
        exit 1
    fi

    echo "Installed font ${FONT_NAME}"
    exit 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nerdfont "$@"
  if [[ $? -ne 0 ]]; then
    echo "Failed to install nerdfont"
    exit 1
  fi
fi
