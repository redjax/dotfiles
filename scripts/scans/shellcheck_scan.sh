#!/usr/bin/env bash

set -euo pipefail

## Get the directory where this script is located (regardless of where it's called from)
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Repository root is 2 levels up from this script
REPO_ROOT="$(cd "${THIS_DIR}/../.." && pwd)"

## Check if shellcheck is installed
check_shellcheck() {
    if command -v shellcheck &> /dev/null; then
        echo "Shellcheck is installed: $(shellcheck --version | head -n2 | tail -n1)"
        return 0
    else
        echo "[WARNING] Shellcheck is not installed"
        return 1
    fi
}

## Install shellcheck
install_shellcheck() {
    echo "Installing shellcheck..."
    
    ## Detect OS
    case "$(uname -s)" in
        Linux*)
            ## Try to detect package manager
            if command -v apt-get &> /dev/null; then
                echo "Using apt to install shellcheck..."
                sudo apt-get update && sudo apt-get install -y shellcheck
            elif command -v dnf &> /dev/null; then
                echo "Using dnf to install shellcheck..."
                sudo dnf install -y ShellCheck
            elif command -v yum &> /dev/null; then
                echo "Using yum to install shellcheck..."
                sudo yum install -y ShellCheck
            elif command -v pacman &> /dev/null; then
                echo "Using pacman to install shellcheck..."
                sudo pacman -S --noconfirm shellcheck
            else
                echo "[ERROR] No supported package manager found"
                echo "Please install shellcheck manually: https://github.com/koalaman/shellcheck#installing"
                return 1
            fi
            ;;
        Darwin*)
            if command -v brew &> /dev/null; then
                echo "Using homebrew to install shellcheck..."
                brew install shellcheck
            else
                echo "[ERROR] Homebrew not found"
                echo "Please install shellcheck manually: https://github.com/koalaman/shellcheck#installing"
                return 1
            fi
            ;;
        *)
            echo "[ERROR] Unsupported OS: $(uname -s)"
            echo "Please install shellcheck manually: https://github.com/koalaman/shellcheck#installing"
            return 1
            ;;
    esac
    
    ## Verify installation
    if command -v shellcheck &> /dev/null; then
        echo "Shellcheck successfully installed: $(shellcheck --version | head -n2 | tail -n1)"
    else
        echo "[ERROR] Installation completed but shellcheck is not available"
        return 1
    fi
}

## Find all shell scripts in the repository
find_shell_scripts() {
    local search_path="${1:-$REPO_ROOT}"
    
    ## Find shell scripts by:
    ## 1. Direct extensions (.sh, .bash, .zsh, .ksh)
    ## 2. Chezmoi templates with shell extensions (.sh.tmpl, .bash.tmpl, .zsh.tmpl)
    ## 3. Chezmoi dotfiles that are shell configs (dot_bashrc, dot_zshrc, dot_profile, etc.)
    ## 4. Bash/Zsh loader files (dot_bash_loader/*, dot_zsh_loader/*)
    ## 5. Executable files with shell shebang
    
    {
        ## Find files with shell script extensions (including .tmpl)
        find "$search_path" -type f \( \
            -name "*.sh" -o \
            -name "*.bash" -o \
            -name "*.zsh" -o \
            -name "*.ksh" -o \
            -name "*.sh.tmpl" -o \
            -name "*.bash.tmpl" -o \
            -name "*.zsh.tmpl" -o \
            -name "*.ksh.tmpl" \
        \)
        
        ## Find shell dotfiles (bash/zsh configs)
        find "$search_path" -type f \( \
            -name "dot_bashrc*" -o \
            -name "dot_bash_profile*" -o \
            -name "dot_bash_login*" -o \
            -name "dot_bash_logout*" -o \
            -name "dot_bash_aliases*" -o \
            -name "dot_zshrc*" -o \
            -name "dot_zprofile*" -o \
            -name "dot_zlogin*" -o \
            -name "dot_zlogout*" -o \
            -name "dot_zshenv*" -o \
            -name "dot_profile*" \
        \)
        
        ## Find files in bash/zsh loader directories
        find "$search_path" -type f \( \
            -path "*/dot_bash_loader/*" -o \
            -path "*/dot_zsh_loader/*" \
        \) -name "*.tmpl"
        
        ## Find chezmoi executable_ files that might be shell scripts
        ## Check if they have shell shebang or .sh/.bash/.zsh before .tmpl
        find "$search_path" -type f -name "executable_*" -exec sh -c '
            for file; do
                ## Check if it has shell extension in chezmoi name
                case "$file" in
                    *.sh.tmpl|*.bash.tmpl|*.zsh.tmpl|*.ksh.tmpl)
                        echo "$file"
                        ;;
                    *)
                        ## Check shebang for non-.tmpl files
                        if [ ! "${file%.tmpl}" = "$file" ]; then
                            ## Skip .tmpl files without shell extension
                            continue
                        fi
                        if head -n1 "$file" 2>/dev/null | grep -q "^#!.*sh"; then
                            echo "$file"
                        fi
                        ;;
                esac
            done
        ' sh {} +
    } | sort -u
}

## Run shellcheck on files
run_shellcheck() {
    local exclude_codes="${1:-}"
    local severity="${2:-warning}"
    local use_rc_file="${3:-true}"
    
    echo "Repository root: ${REPO_ROOT}"
    
    ## Check for .shellcheckrc file
    local rc_file="${REPO_ROOT}/.shellcheckrc"
    if [ "$use_rc_file" = "true" ] && [ -f "$rc_file" ]; then
        echo "Using shellcheck config: $rc_file"
        exclude_codes=""  # Don't use CLI excludes if using rc file
    elif [ -n "$exclude_codes" ]; then
        echo "Using CLI exclusions: $exclude_codes"
    else
        echo "No exclusions specified"
    fi
    
    echo "Finding shell scripts..."
    
    ## Find all shell scripts
    local scripts
    mapfile -t scripts < <(find_shell_scripts "$REPO_ROOT")
    
    local script_count="${#scripts[@]}"
    echo "Found ${script_count} shell script(s)"
    
    if [ "$script_count" -eq 0 ]; then
        echo "No shell scripts found to check"
        return 0
    fi
    
    echo ""
    echo "================================"
    echo "Running Shellcheck"
    echo "================================"
    if [ -n "$exclude_codes" ]; then
        echo "Excluded codes: ${exclude_codes}"
    fi
    echo "Minimum severity: ${severity}"
    echo ""
    
    local failed_count=0
    local checked_count=0
    
    ## Run shellcheck on each file
    for script in "${scripts[@]}"; do
        checked_count=$((checked_count + 1))
        local relative_path="${script#$REPO_ROOT/}"
        
        echo "[$checked_count/$script_count] Checking: $relative_path"
        
        ## Build shellcheck command
        local shellcheck_cmd=(shellcheck)
        
        if [ -n "$exclude_codes" ]; then
            shellcheck_cmd+=(--exclude="$exclude_codes")
        fi
        
        shellcheck_cmd+=(
            --severity="$severity"
            --color=auto
            "$script"
        )
        
        if "${shellcheck_cmd[@]}"; then
            echo "  OK"
        else
            echo "  FAILED"
            failed_count=$((failed_count + 1))
        fi
        echo ""
    done
    
    echo "================================"
    echo "Shellcheck Summary"
    echo "================================"
    echo "Checked: ${checked_count} files"
    echo "Failed:  ${failed_count} files"
    echo "Passed:  $((checked_count - failed_count)) files"
    echo ""
    
    if [ "$failed_count" -gt 0 ]; then
        echo "[ERROR] Shellcheck found issues in ${failed_count} file(s)"
        return 1
    else
        echo "SUCCESS: All scripts passed shellcheck"
        return 0
    fi
}

## Main execution
main() {
    local exclude_codes=""
    local severity="warning"
    local use_rc_file="true"
    
    ## Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --exclude|-e)
                exclude_codes="$2"
                use_rc_file="false"  # CLI exclusions override rc file
                shift 2
                ;;
            --severity|-s)
                severity="$2"
                shift 2
                ;;
            --no-rc)
                use_rc_file="false"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --exclude, -e CODE   Comma-separated list of codes to exclude"
                echo "                       Overrides .shellcheckrc if specified"
                echo "  --severity, -s LEVEL Minimum severity level (error, warning, info, style)"
                echo "                       Default: warning"
                echo "  --no-rc              Ignore .shellcheckrc file"
                echo "  --help, -h           Show this help message"
                echo ""
                echo "Configuration:"
                echo "  Shellcheck will use .shellcheckrc from repository root if present"
                echo "  Use --exclude to override .shellcheckrc exclusions"
                echo ""
                echo "Common exclusions for chezmoi templates:"
                echo "  SC2154 - Referenced but not assigned variables (template variables)"
                echo "  SC2086 - Double quote to prevent globbing (template syntax)"
                echo "  SC2016 - Expressions don't expand in single quotes (template literals)"
                echo "  SC2148 - Tips depend on target shell (zsh files without shebangs)"
                exit 0
                ;;
            *)
                echo "[ERROR] Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    echo "Shellcheck Scan Script"
    echo "Script location: ${THIS_DIR}"
    echo "Repository root: ${REPO_ROOT}"
    
    echo ""
    
    ## Check and install shellcheck if needed
    if ! check_shellcheck; then
        read -p "Shellcheck is not installed. Install it now? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_shellcheck
        else
            echo "[ERROR] Shellcheck is required to run this script"
            exit 1
        fi
    fi
    
    echo ""
    
    ## Run shellcheck
    if run_shellcheck "$exclude_codes" "$severity" "$use_rc_file"; then
        exit 0
    else
        exit 1
    fi
}

## Run main function
main "$@"
