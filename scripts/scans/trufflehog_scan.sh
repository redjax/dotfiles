#!/usr/bin/env bash

set -euo pipefail

## Get the directory where this script is located
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Repository root is 2 levels up from this script
REPO_ROOT="$(cd "${THIS_DIR}/../.." && pwd)"

## Detect OS and architecture
detect_os() {
    local os=""
    local arch=""
    
    case "$(uname -s)" in
        Linux*)     os="linux" ;;
        Darwin*)    os="darwin" ;;
        MINGW*|MSYS*|CYGWIN*) os="windows" ;;
        *)          os="unknown" ;;
    esac
    
    case "$(uname -m)" in
        x86_64|amd64)   arch="amd64" ;;
        arm64|aarch64)  arch="arm64" ;;
        i386|i686)      arch="386" ;;
        *)              arch="unknown" ;;
    esac
    
    echo "${os}_${arch}"
}

## Install trufflehog if not present
install_trufflehog() {
    if command -v trufflehog &> /dev/null; then
        echo "Trufflehog is already installed: $(trufflehog --version 2>&1 | head -n1)"
        return 0
    fi
    
    echo "Installing trufflehog..."
    
    local platform
    platform=$(detect_os)
    
    case "$platform" in
        linux_amd64|linux_arm64|darwin_amd64|darwin_arm64)
            echo "Detected platform: ${platform}"
            
            ## Use official installation script
            if curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b "${HOME}/.local/bin"; then
                echo "Trufflehog installed successfully to ${HOME}/.local/bin"
                
                ## Add to PATH if not already there
                if [[ ":$PATH:" != *":${HOME}/.local/bin:"* ]]; then
                    export PATH="${HOME}/.local/bin:$PATH"
                    echo "Added ${HOME}/.local/bin to PATH for this session"
                fi
                
                if command -v trufflehog &> /dev/null; then
                    echo "Trufflehog version: $(trufflehog --version 2>&1 | head -n1)"
                    return 0
                fi
            fi
            ;;
        windows_amd64)
            echo "Windows detected. Please install trufflehog manually:"
            echo "  Download from: https://github.com/trufflesecurity/trufflehog/releases"
            echo "  Or use: choco install trufflehog (if you have Chocolatey)"
            return 1
            ;;
        *)
            echo "Unsupported platform: ${platform}"
            echo "Please install trufflehog manually from:"
            echo "  https://github.com/trufflesecurity/trufflehog/releases"
            return 1
            ;;
    esac
    
    echo "[ERROR] Failed to install trufflehog"
    return 1
}

## Render chezmoi templates to a temporary directory
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
    export CHEZMOI_DATA_custom_hostname="trufflehog-scan"
    
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
    
    ## Return the path via stdout
    echo "$temp_dir"
    return 0
}

## Run trufflehog scan
run_scan() {
    local scan_mode="${1:-current}"
    local results_filter="${2:-verified,unknown}"
    local output_format="${3:-text}"
    
    if ! command -v trufflehog &> /dev/null; then
        echo "[ERROR] Trufflehog is not installed. Run with --install to install it."
        return 1
    fi
    
    echo "Trufflehog version: $(trufflehog --version 2>&1 | head -n1)"
    echo "Repository root: ${REPO_ROOT}"
    echo "Scan mode: ${scan_mode}"
    echo "Results filter: ${results_filter}"
    echo "Output format: ${output_format}"
    echo ""
    
    case "$scan_mode" in
        current)
            echo "Scanning current repository state..."
            echo "Command: trufflehog filesystem \"${REPO_ROOT}\" --results=${results_filter} --${output_format}"
            echo ""
            
            if [ "$output_format" = "json" ]; then
                trufflehog filesystem "${REPO_ROOT}" --results="${results_filter}" --json
            else
                trufflehog filesystem "${REPO_ROOT}" --results="${results_filter}"
            fi
            ;;
        full)
            echo "Scanning full git history..."
            echo "Command: trufflehog git file://${REPO_ROOT} --results=${results_filter} --${output_format}"
            echo ""
            
            if [ "$output_format" = "json" ]; then
                trufflehog git "file://${REPO_ROOT}" --results="${results_filter}" --json
            else
                trufflehog git "file://${REPO_ROOT}" --results="${results_filter}"
            fi
            ;;
        rendered)
            echo "Rendering chezmoi templates and scanning..."
            local rendered_dir
            rendered_dir=$(render_chezmoi "/tmp/trufflehog-scan-$$")
            
            if [ -z "$rendered_dir" ] || [ ! -d "$rendered_dir" ]; then
                echo "[ERROR] Failed to render templates"
                return 1
            fi
            
            echo ""
            echo "Scanning rendered templates in: ${rendered_dir}"
            echo "Command: trufflehog filesystem \"${rendered_dir}\" --results=${results_filter} --${output_format}"
            echo ""
            
            if [ "$output_format" = "json" ]; then
                trufflehog filesystem "${rendered_dir}" --results="${results_filter}" --json
            else
                trufflehog filesystem "${rendered_dir}" --results="${results_filter}"
            fi
            
            local exit_code=$?
            
            ## Cleanup
            echo ""
            echo "Cleaning up: ${rendered_dir}"
            rm -rf "$rendered_dir"
            
            return $exit_code
            ;;
        *)
            echo "[ERROR] Invalid scan mode: ${scan_mode}"
            echo "Valid modes: current, full, rendered"
            return 1
            ;;
    esac
}

## Main execution
main() {
    local scan_mode="current"
    local results_filter="verified,unknown"
    local output_format="text"
    local auto_install="false"
    
    ## Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full)
                scan_mode="full"
                shift
                ;;
            --rendered)
                scan_mode="rendered"
                shift
                ;;
            --current)
                scan_mode="current"
                shift
                ;;
            --install)
                auto_install="true"
                shift
                ;;
            --results|-r)
                results_filter="$2"
                shift 2
                ;;
            --json)
                output_format="json"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Scan for secrets using Trufflehog"
                echo ""
                echo "Scan Modes:"
                echo "  --current    Scan current repository state (default)"
                echo "  --full       Scan full git history"
                echo "  --rendered   Render chezmoi templates and scan them"
                echo ""
                echo "Options:"
                echo "  --install          Install trufflehog if not present"
                echo "  --results, -r STR  Results to show (default: verified,unknown)"
                echo "                     Options: verified, unknown, unverified, filtered_unverified"
                echo "  --json             Output in JSON format"
                echo "  --help, -h         Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0 --current                           # Scan current state"
                echo "  $0 --full --results verified           # Scan git history, verified only"
                echo "  $0 --rendered --json                   # Scan rendered templates, JSON output"
                echo "  $0 --install --full                    # Install trufflehog and scan"
                exit 0
                ;;
            *)
                echo "[ERROR] Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    echo "Trufflehog Scan Script"
    echo "Script location: ${THIS_DIR}"
    echo "Repository root: ${REPO_ROOT}"
    echo ""
    
    ## Install trufflehog if requested or if not found
    if [ "$auto_install" = "true" ] || ! command -v trufflehog &> /dev/null; then
        if ! install_trufflehog; then
            exit 1
        fi
        echo ""
    fi
    
    ## Run the scan
    run_scan "$scan_mode" "$results_filter" "$output_format"
}

## Run main function
main "$@"
