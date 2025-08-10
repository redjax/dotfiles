#!/bin/bash

function get_distro_id() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "${ID}-${VERSION_ID:-unknown}"
    else
        echo "unknown"
    fi
}

function install_zellij_linux() {
    LINUX_DISTRO="$(get_distro_id)"
    echo "[INFO] Detected Linux distro: $LINUX_DISTRO"

    ## Use static binary for simplicity
    echo "[INFO] Downloading Zellij static binary"
    curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz -o /tmp/zellij.tar.gz
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to download Zellij static binary"
        return 1
    fi

    echo "[INFO] Extracting Zellij static binary"
    tar -xzf /tmp/zellij.tar.gz -C /tmp
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to extract Zellij static binary"
        return 1
    fi
    
    sudo mv /tmp/zellij /usr/local/bin/
    sudo chmod +x /usr/local/bin/zellij
    
    echo "[OK] Zellij installed to /usr/local/bin/zellij"
}

function install_zellij_mac() {
    if ! command -v brew 2>&1 > /dev/null; then
        echo "[ERROR] Homebrew not installed. Please install Homebrew and retry."
        exit 1
    fi

    echo "[INFO] Installing Zellij via Homebrew"
    brew install zellij
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to install Zellij via Homebrew"
        return 1
    fi
    
    echo "[OK] Zellij installed via Homebrew"
}

function main() {
    OS_NAME="$(uname -s)"
    echo "[INFO] Detected OS: $OS_NAME"

    if [[ "$OS_NAME" == "Darwin" ]]; then
        install_zellij_mac
        if [[ $? -ne 0 ]]; then
            return 1
        fi
    elif [[ "$OS_NAME" == "Linux" ]]; then
        install_zellij_linux
        if [[ $? -ne 0 ]]; then
            return 1
        fi
    else
        echo "[ERROR] Unsupported OS: $OS_NAME"
        return 1
    fi

    return 0
}

if ! command -v curl 2>&1 > /dev/null; then
    echo "[ERROR] curl is not installed. Please install curl and retry."
    exit 1
fi

if ! command -v tar 2>&1 > /dev/null; then
    echo "[ERROR] tar is not installed. Please install tar and retry."
    exit 1
fi

main
if [[ $SUCCESS -ne 0 ]]; then
    echo "[ERROR] Failed to install Zellij"
    exit 1
else
    echo "[OK] Zellij installed successfully"
    exit 0
fi
