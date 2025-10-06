#!/usr/bin/env bash

set -euo pipefail

## Get the directory where this script is located (regardless of where it's called from)
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Repository root is 2 levels up from this script
REPO_ROOT="$(cd "${THIS_DIR}/../.." && pwd)"

## Detect OS and architecture
detect_os() {
    local os=""
    local arch=""
    
    ## Detect OS
    case "$(uname -s)" in
        Linux*)
            os="linux"
            ;;
        Darwin*)
            os="darwin"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            os="windows"
            ;;
        *)
            echo "[ERROR] Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
    
    ## Detect architecture
    case "$(uname -m)" in
        x86_64|amd64)
            arch="x64"
            ;;
        aarch64|arm64)
            arch="arm64"
            ;;
        armv7l)
            arch="armv7"
            ;;
        *)
            echo "[ERROR] Unsupported architecture: $(uname -m)"
            exit 1
            ;;
    esac
    
    echo "${os}_${arch}"
}

## Get Linux distribution info (for package manager detection)
get_linux_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

## Check if gitleaks is installed
check_gitleaks() {
    if command -v gitleaks &> /dev/null; then
        echo "Gitleaks is already installed: $(gitleaks version)"
        return 0
    else
        echo "[WARNING] Gitleaks is not installed"
        return 1
    fi
}

## Install gitleaks
install_gitleaks() {
    echo "Installing Gitleaks..."
    
    local os_arch
    os_arch=$(detect_os)
    
    local os="${os_arch%_*}"
    local arch="${os_arch#*_}"
    
    # Map architecture names to gitleaks naming convention
    case "$arch" in
        x64)
            arch="x64"
            ;;
        arm64)
            arch="arm64"
            ;;
        armv7)
            arch="armv7"
            ;;
    esac
    
    ## Get latest version
    echo "Fetching latest Gitleaks version..."
    local latest_version
    latest_version=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    
    if [ -z "$latest_version" ]; then
        echo "[ERROR] Failed to fetch latest Gitleaks version"
        exit 1
    fi
    
    echo "Latest version: $latest_version"
    
    ## Construct download URL
    local download_url
    if [ "$os" = "windows" ]; then
        download_url="https://github.com/gitleaks/gitleaks/releases/download/${latest_version}/gitleaks_${latest_version#v}_${os}_${arch}.zip"
    else
        download_url="https://github.com/gitleaks/gitleaks/releases/download/${latest_version}/gitleaks_${latest_version#v}_${os}_${arch}.tar.gz"
    fi
    
    echo "Downloading from: $download_url"
    
    ## Create temporary directory
    local temp_dir
    temp_dir=$(mktemp -d)
    
    ## Download and extract
    if [ "$os" = "windows" ]; then
        curl -sL "$download_url" -o "${temp_dir}/gitleaks.zip"
        unzip -q "${temp_dir}/gitleaks.zip" -d "${temp_dir}"
    else
        curl -sL "$download_url" | tar -xz -C "${temp_dir}"
    fi
    
    ## Determine installation directory
    local install_dir
    if [ -w "/usr/local/bin" ]; then
        install_dir="/usr/local/bin"
    elif [ -d "$HOME/.local/bin" ]; then
        install_dir="$HOME/.local/bin"
        mkdir -p "$install_dir"
    else
        install_dir="$HOME/bin"
        mkdir -p "$install_dir"
    fi
    
    ## Move binary to installation directory
    if [ -w "$install_dir" ]; then
        mv "${temp_dir}/gitleaks" "${install_dir}/gitleaks"
        chmod +x "${install_dir}/gitleaks"
        echo "Gitleaks installed to: ${install_dir}/gitleaks"
    else
        echo "No write permission to $install_dir, attempting with sudo..."
        sudo mv "${temp_dir}/gitleaks" "${install_dir}/gitleaks"
        sudo chmod +x "${install_dir}/gitleaks"
        echo "Gitleaks installed to: ${install_dir}/gitleaks (with sudo)"
    fi
    
    ## Cleanup
    rm -rf "$temp_dir"
    
    ## Verify installation
    if command -v gitleaks &> /dev/null; then
        echo "Gitleaks successfully installed: $(gitleaks version)"
    else
        echo "[ERROR] Installation completed but gitleaks is not in PATH"
        echo "You may need to add ${install_dir} to your PATH"
        exit 1
    fi
}

## Run gitleaks scan
run_scan() {
    local config_file="${REPO_ROOT}/.gitleaks.toml"
    
    if [ ! -f "$config_file" ]; then
        echo "[ERROR] Gitleaks config not found: $config_file"
        exit 1
    fi
    
    echo "Repository root: ${REPO_ROOT}"
    echo "Config file: ${config_file}"
    echo "Running Gitleaks scan..."
    
    echo ""
    echo "================================"
    echo "Starting Gitleaks Secret Scan"
    echo "================================"
    echo ""
    
    # Run gitleaks detect
    if gitleaks detect --source="${REPO_ROOT}" --config="${config_file}" --verbose; then
        echo ""
        echo "================================"
        echo "SUCCESS: No secrets detected"
        echo "================================"
        return 0
    else
        echo ""
        echo "================================"
        echo "[ERROR] Secrets detected"
        echo "================================"
        return 1
    fi
}

## Main execution
main() {
    echo "Gitleaks Scan Script"
    echo "Script location: ${THIS_DIR}"
    echo "Repository root: ${REPO_ROOT}"
    echo "OS/Architecture: $(detect_os)"
    
    if [ "$(uname -s)" = "Linux" ]; then
        echo "Linux distribution: $(get_linux_distro)"
    fi
    
    echo ""
    
    ## Check and install gitleaks if needed
    if ! check_gitleaks; then
        read -p "Gitleaks is not installed. Install it now? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_gitleaks
        else
            echo "[ERROR] Gitleaks is required to run this script"
            exit 1
        fi
    fi
    
    echo ""
    
    # Run the scan
    if run_scan; then
        exit 0
    else
        exit 1
    fi
}

## Run main function
main "$@"
