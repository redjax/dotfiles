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

## Check if chezmoi is installed
check_chezmoi() {
    if command -v chezmoi &> /dev/null; then
        echo "Chezmoi is installed: $(chezmoi --version 2>&1 | head -n1)"
        return 0
    else
        echo "[WARNING] Chezmoi is not installed"
        return 1
    fi
}

## Render chezmoi templates to temporary directory
render_chezmoi() {
    local temp_dir="${1:-/tmp/chezmoi-rendered-$$}"
    
    if ! command -v chezmoi &> /dev/null; then
        echo "[ERROR] Chezmoi is not installed. Cannot render templates."
        return 1
    fi
    
    echo "Creating temporary directory: ${temp_dir}" >&2
    mkdir -p "$temp_dir"
    
    echo "Rendering chezmoi templates..." >&2
    
    ## Set chezmoi data values to avoid prompts
    export CHEZMOI_DATA_custom_hostname="scan-test"
    
    ## Archive rendered templates (redirect warnings to /dev/null)
    chezmoi archive --output="${temp_dir}.tar" --source="${REPO_ROOT}" 2>/dev/null
    
    ## Check if archive was created
    if [ ! -f "${temp_dir}.tar" ]; then
        echo "[ERROR] Failed to create chezmoi archive" >&2
        rm -rf "$temp_dir"
        return 1
    fi
    
    ## Extract rendered templates (suppress tar warnings)
    tar -xf "${temp_dir}.tar" -C "$temp_dir" 2>/dev/null
    
    ## Check if extraction succeeded
    if [ ! "$(ls -A "$temp_dir" 2>/dev/null)" ]; then
        echo "[ERROR] Failed to extract chezmoi archive or archive is empty" >&2
        rm -rf "$temp_dir" "${temp_dir}.tar"
        return 1
    fi
    
    rm -f "${temp_dir}.tar"
    echo "Successfully rendered chezmoi templates to: ${temp_dir}" >&2
    
    ## Show what was rendered
    echo "Rendered files:" >&2
    find "$temp_dir" -type f | head -n 10 >&2
    local file_count=$(find "$temp_dir" -type f | wc -l)
    if [ "$file_count" -gt 10 ]; then
        echo "... and $((file_count - 10)) more files" >&2
    fi
    
    ## Return the path via stdout
    echo "$temp_dir"
    return 0
}

## Run gitleaks scan
run_scan() {
    local config_file="${REPO_ROOT}/.gitleaks.toml"
    local scan_mode="${1:-current}"
    
    if [ ! -f "$config_file" ]; then
        echo "[ERROR] Gitleaks config not found: $config_file"
        exit 1
    fi
    
    echo "Repository root: ${REPO_ROOT}"
    echo "Config file: ${config_file}"
    
    echo ""
    echo "================================"
    
    ## Run gitleaks detect based on scan mode
    if [ "$scan_mode" = "full" ]; then
        echo "Starting FULL Gitleaks Secret Scan (all history and branches)"
        echo "================================"
        echo ""
        
        ## Scan entire git history across all branches
        if gitleaks detect --source="${REPO_ROOT}" --config="${config_file}" --verbose --log-opts="--all"; then
            echo ""
            echo "================================"
            echo "SUCCESS: No secrets detected in full history"
            echo "================================"
            return 0
        else
            echo ""
            echo "================================"
            echo "[ERROR] Secrets detected in git history"
            echo "================================"
            return 1
        fi
    elif [ "$scan_mode" = "rendered" ]; then
        echo "Starting Gitleaks Scan on rendered Chezmoi Templates"
        echo "================================"
        echo ""
        
        ## Render chezmoi templates
        local rendered_dir
        rendered_dir=$(render_chezmoi "/tmp/chezmoi-rendered-$$")
        
        if [ -z "$rendered_dir" ] || [ ! -d "$rendered_dir" ]; then
            echo "[ERROR] Failed to render templates"
            return 1
        fi
        
        echo ""
        echo "Scanning rendered templates at: ${rendered_dir}"
        echo ""
        
        ## Scan rendered templates
        local scan_result=0
        if gitleaks detect --source="${rendered_dir}" --config="${config_file}" --verbose --no-git; then
            echo ""
            echo "================================"
            echo "SUCCESS: No secrets detected in rendered templates"
            echo "================================"
        else
            echo ""
            echo "================================"
            echo "[ERROR] Secrets detected in rendered templates"
            echo "================================"
            scan_result=1
        fi
        
        ## Cleanup
        echo ""
        echo "Cleaning up temporary directory: ${rendered_dir}"
        rm -rf "$rendered_dir"
        
        return $scan_result
    else
        echo "Starting Gitleaks Secret Scan (current state)"
        echo "================================"
        echo ""
        
        ## Scan current state only (no git history)
        if gitleaks detect --source="${REPO_ROOT}" --config="${config_file}" --verbose --no-git; then
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
    fi
}

## Main execution
main() {
    local scan_mode="current"
    
    ## Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full|--all|-f)
                scan_mode="full"
                shift
                ;;
            --rendered|--chezmoi|-r)
                scan_mode="rendered"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --full, --all, -f        Scan entire git history and all branches"
                echo "  --rendered, --chezmoi, -r  Render chezmoi templates and scan the rendered output"
                echo "  --help, -h               Show this help message"
                echo ""
                echo "Default: Scans current state only (no git history)"
                exit 0
                ;;
            *)
                echo "[ERROR] Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    echo "Gitleaks Scan Script"
    echo "Script location: ${THIS_DIR}"
    echo "Repository root: ${REPO_ROOT}"
    echo "OS/Architecture: $(detect_os)"
    echo "Scan mode: ${scan_mode}"
    
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
    
    ## Check for chezmoi if rendering is requested
    if [ "$scan_mode" = "rendered" ]; then
        if ! check_chezmoi; then
            echo "[ERROR] Chezmoi is required for --rendered mode"
            echo "Install chezmoi first: https://www.chezmoi.io/install/"
            exit 1
        fi
    fi
    
    echo ""
    
    ## Run the scan with specified mode
    if run_scan "$scan_mode"; then
        exit 0
    else
        exit 1
    fi
}

## Run main function
main "$@"
