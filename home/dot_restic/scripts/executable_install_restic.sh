#!/bin/bash


##
# Script to detect OS and install restic accordingly.
##

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESTIC_ROOT="$(realpath -m "${THIS_DIR}/../..")"
SCRIPTS_DIR="${RESTIC_ROOT}/scripts"

## Check if input is a valid IP address
function validate_ip() {
    local ip="$1"
    local stat=1
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    
    if [[ "$ip" =~ $regex ]]; then
        IFS='.' read -ra ip <<< "$ip"
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

## Check if input is a valid TCP/UDP port
function validate_tcpip_port() {
    local port="$1"
    local -i port_num="10#${port}" 2>/dev/null || return 1
    (( port_num >= 1 && port_num <= 65535 ))
}

function detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

function install_rclone_linux() {
    echo "Installing rclone using official install script..."
    # Runs as root, downloads latest stable binary, installs globally
    if ! curl -s https://rclone.org/install.sh | sudo bash; then
        echo "Failed to install rclone using official script."
        return 1
    fi
    echo "rclone installed successfully."
    return 0
}

function install_backrest_linux() {
    local INSTALL_SCRIPT="${SCRIPTS_DIR}/apps/backrest/install-backrest.sh"
    local bind_addr="127.0.0.1"
    local port="9898"
    local allow_remote="false"

    if [[ ! -f "${INSTALL_SCRIPT}" ]]; then
      echo "[ERROR] Could not find Backrest install script at path: ${INSTALL_SCRIPT}"
      return 1
    fi

    echo "Installing Backrest webUI for Restic."
    echo ""

    echo "Backrest requires some options. Please answer the prompts below, or press Enter to sksip & use the default."
    echo ""

    ## Set bind address
    while true; do
        read -r -p "[-] Set bind address (default: ${bind_addr}): " input
        echo ""
        if [[ -z "$input" ]]; then
            bind_addr="127.0.0.1"
            break
        elif validate_ip "$input"; then
            bind_addr="$input"
            break
        else
            echo "[ERROR] Invalid IP address. Enter valid IPv4 (e.g., 127.0.0.1 or 0.0.0.0)."
        fi
    done

    ## Set port
    while true; do
        read -r -p "[-] Set webUI port (default: ${port:-9898}): " input
        echo ""
        if [[ -z "$input" ]]; then
            port="9898"
            break
        elif validate_port "$input"; then
            port="$input"
            break
        else
            echo "Invalid port. Enter number between 1-65535."
        fi
    done

    ## Set allow remote access
    while true; do
        read -r -n 1 -p "[-] Allow remote access? (y/n, default: n): " input
        echo ""
        case "${input,,}" in
            y|yes) allow_remote="true"; break ;;
            n|no|"") allow_remote="false"; break ;;
            *) echo "Enter y/n or Enter for default." ;;
        esac
    done

    echo ""
    if [[ "$allow_remote" ]]; then
        "${INSTALL_SCRIPT} -b ${bind_addr} -p ${port} --allow-remote-access"
    else
        "${INSTALL_SCRIPT} -b ${bind_addr} -p ${port}"
    fi

    echo ""

    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed installing Backrest."
        return $?
    fi
}

function install_resticprofile_linux() {
    echo "Downloading & executing resticprofile install script."
    sudo sh -c "$(curl -fsLS https://raw.githubusercontent.com/creativeprojects/resticprofile/master/install.sh)" -- -b /usr/local/bin

    if [[ $? -ne 0 ]]; then
        echo "Failed installing resticprofile."
        return 1 ## always return a numeric code
    else
        echo "resticprofile installed successfully."
        return 0
    fi
}

function install_restic_linux() {
    echo "Determining latest Restic release..."

    # Get latest version tag using GitHub API
    RESTIC_VERSION=$(curl -s https://api.github.com/repos/restic/restic/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    if [[ -z "$RESTIC_VERSION" ]]; then
        echo "Failed to retrieve latest Restic version."
        return 1
    fi

    echo "Latest Restic version is $RESTIC_VERSION"

    # Remove leading 'v' if present for URL construction
    RESTIC_VERSION_CLEAN=${RESTIC_VERSION#v}

    # Construct download URL
    URL="https://github.com/restic/restic/releases/download/${RESTIC_VERSION}/restic_${RESTIC_VERSION_CLEAN}_linux_amd64.bz2"

    # Create temporary directory
    TMPDIR=$(mktemp -d)

    # Download binary
    echo "Downloading Restic from $URL..."
    curl -L "$URL" -o "${TMPDIR}/restic.bz2"
    if [[ $? -ne 0 ]]; then
        echo "Failed to download restic binary."
        rm -rf "$TMPDIR"
        return 1
    fi

    # Extract the binary
    bunzip2 "${TMPDIR}/restic.bz2"
    if [[ $? -ne 0 ]]; then
        echo "Failed to decompress restic binary."
        rm -rf "$TMPDIR"
        return 1
    fi

    # Move to /usr/local/bin and mark executable
    sudo mv "${TMPDIR}/restic" /usr/local/bin/restic
    sudo chmod +x /usr/local/bin/restic

    # Cleanup temporary directory
    rm -rf "$TMPDIR"

    echo "Restic installed to /usr/local/bin/restic"
    return 0
}

function install_autorestic() {
    local WGET_INSTALLED=""
    local CURL_INSTALLED=""

    if command -v wget >/dev/null 2>&1; then
        WGET_INSTALLED="true"
    fi

    if command -v curl >/dev/null 2>&1; then
        CURL_INSTALLED="true"
    fi

    if [[ "$WGET_INSTALLED" == "" ]] && [[ "$CURL_INSTALLED" == "" ]]; then
        echo "[ERROR] Missing both wget & curl. Install one or both and try again."
        return 1 ## do not use exit inside a function
    fi

    if [[ "$WGET_INSTALLED" == "true" ]]; then
        echo "Installing autorestic"
        wget -qO- https://raw.githubusercontent.com/cupcakearmy/autorestic/master/install.sh | sudo bash ## corrected raw URL syntax

        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to install autorestic."
            return 1 ## properly handle install failure
        fi
    elif [[ "$CURL_INSTALLED" == "true" ]]; then
        echo "Installing autorestic"
        curl -LsSf https://raw.githubusercontent.com/cupcakearmy/autorestic/master/install.sh | sudo bash ## corrected raw URL syntax

        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to install autorestic."
            return 1 ## properly handle install failure
        fi
    fi
}

function install_rclone_macos() {
    if command -v brew >/dev/null 2>&1; then
        echo "Installing rclone using Homebrew..."
        brew install rclone
    else
        echo "Homebrew not found. Please install Homebrew or install rclone manually: https://rclone.org/install/"
        echo ""
        return 1
    fi
}

function install_restic_macos() {
    ## Use Homebrew if available
    if command -v brew >/dev/null 2>&1; then
        echo "Installing restic using Homebrew..."
        brew install restic
    else
        echo "Homebrew not found. Please install Homebrew or install restic manually:"
        echo "https://restic.readthedocs.io/en/latest/020_installation.html"
        return 1
    fi
}

function install_resticprofile_macos() {
    ## Use Homebrew if available
    if command -v brew >/dev/null 2>&1; then
        echo "Installing resticprofile using Homebrew..."
        brew install resticprofile ## fixed: proper Homebrew package name instead of restic
    else
        echo "Homebrew not found. Please install Homebrew or install resticprofile manually:"
        echo "https://restic.readthedocs.io/en/latest/020_installation.html"
        return 1
    fi
}

function main() {
    OS=$(uname -s)
    DISTRO=$(detect_distro)

    local RESTIC_INSTALLED="false"
    local RCLONE_INSTALLED="false"
    local AUTORESTIC_INSTALLED="false"
    local RESTICPROFILE_INSTALLED="false"
    local BACKREST_INSTALLED="false"
    local INSTALL_RESTIC="false"
    local INSTALL_RCLONE="false"
    local INSTALL_AUTORESTIC="false"
    local INSTALL_RESTICPROFILE="false"
    local INSTALL_BACKREST="false"

    ## Check restic is installed
    if command -v restic &>/dev/null; then
        echo "Restic is already installed."
        RESTIC_INSTALLED="true"
    else
        INSTALL_RESTIC="true"  ## Set this so install runs below in OS case block
    fi

    ## Check rclone is installed
    if command -v rclone &>/dev/null; then
        echo "Rclone is already installed."
        RCLONE_INSTALLED="true"
    else
        read -rp "Do you want to install rclone as a backend for restic? [y/N]: " rclone_reply
        if [[ "$rclone_reply" =~ ^[Yy]$ ]]; then
            INSTALL_RCLONE="true"
        fi
    fi

    ## Check autorestic is installed
    if command -v autorestic &>/dev/null; then
        echo "Autorestic is already installed."
        AUTORESTIC_INSTALLED="true"
    else
        read -rp "Do you want to install autorestic? [y/N]: " reply
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            INSTALL_AUTORESTIC="true"
        fi
    fi

    ## Check resticprofile is installed
    if command -v resticprofile &>/dev/null; then
        echo "Resticprofile is already installed."
        RESTICPROFILE_INSTALLED="true"
    else
        read -rp "Do you want to install resticprofile? [y/N]: " reply
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            INSTALL_RESTICPROFILE="true"
        fi
    fi

    ## Check backrest is installed
    if command -v backrest &>/dev/null; then
        echo "Backrest is already installed."
        BACKREST_INSTALLED="true"
    else
        read -rp "Do you want to install backrest? [y/N]: " reply
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            INSTALL_BACKREST="true"
        fi
    fi

    ## Detect OS and install accordingly
    case "$OS" in
        Linux)
            if [[ "$INSTALL_RESTIC" == "true" ]]; then
                install_restic_linux
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install restic."
                    return 1
                fi
            fi

            if [[ "$INSTALL_RCLONE" == "true" && "$RCLONE_INSTALLED" == "false" ]]; then
                install_rclone_linux
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install rclone."
                    return 1
                fi
            fi

            if [[ "$INSTALL_AUTORESTIC" == "true" && "$AUTORESTIC_INSTALLED" == "false" ]]; then
                install_autorestic
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install autorestic."
                    return 1
                fi
            fi

            if [[ "$INSTALL_BACKREST" == "true" ]] && "$BACKREST_INSTALLED" == "false" ]]; then
                install_backrest_linux
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install backrest."
                    return 1
            fi

            if [[ "$INSTALL_RESTICPROFILE" == "true" && "$RESTICPROFILE_INSTALLED" == "false" ]]; then
                install_resticprofile_linux
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install resticprofile."
                    return 1
                fi
            fi
            ;;
        Darwin)
            if [[ "$INSTALL_RESTIC" == "true" ]]; then
                install_restic_macos
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install restic."
                    return 1
                fi
            fi

            if [[ "$INSTALL_RCLONE" == "true" && "$RCLONE_INSTALLED" == "false" ]]; then
                install_rclone_macos
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install rclone."
                    return 1
                fi
            fi

            if [[ "$INSTALL_AUTORESTIC" == "true" && "$AUTORESTIC_INSTALLED" == "false" ]]; then
                install_autorestic
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install autorestic."
                    return 1
                fi
            fi

            if [[ "$INSTALL_RESTICPROFILE" == "true" && "$RESTICPROFILE_INSTALLED" == "false" ]]; then
                install_resticprofile_macos
                if [[ $? -ne 0 ]]; then
                    echo "Failed to install resticprofile."
                    return 1
                fi
            fi
            ;;
        *)
            echo "Unsupported operating system: $OS"
            return 1
            ;;
    esac

    echo "Restic installation completed."
    [[ "$INSTALL_RCLONE" == "true" ]] && echo "Rclone installation completed."
    [[ "$INSTALL_AUTORESTIC" == "true" ]] && echo "Autorestic installation completed."
    [[ "$INSTALL_RESTICPROFILE" == "true" ]] && echo "Resticprofile installation completed."
}

main
if [[ $? -ne 0 ]]; then
    echo "Installation failed."
    exit 1
fi
