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
    export CHEZMOI_DATA_custom_hostname="shellcheck-scan"
    
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
    local file_count
    file_count=$(find "$temp_dir" -type f | wc -l)
    echo "  Total files: ${file_count}" >&2
    
    ## Return the path via stdout
    echo "$temp_dir"
    return 0
}

## Find all shell scripts in a directory
find_shell_scripts() {
    local search_path="${1:-$REPO_ROOT}"
    
    ## Find shell scripts by extension and shebang
    {
        ## Find files with shell script extensions
        find "$search_path" -type f \( \
            -name "*.sh" -o \
            -name "*.bash" -o \
            -name "*.zsh" -o \
            -name "*.ksh" \
        \)
        
        ## Find executable files with shell shebang
        find "$search_path" -type f -executable -exec sh -c '
            for file; do
                if head -n1 "$file" 2>/dev/null | grep -q "^#!.*sh"; then
                    echo "$file"
                fi
            done
        ' sh {} +
    } | sort -u
}

## Run shellcheck on rendered files
run_shellcheck() {
    local rendered_dir="$1"
    local severity="${2:-warning}"
    local use_rc_file="${3:-false}"
    
    echo "Scanning directory: ${rendered_dir}"
    
    ## Check for .shellcheckrc file (from source repo, not rendered)
    local rc_file="${REPO_ROOT}/.shellcheckrc"
    local exclude_codes=""
    
    if [ "$use_rc_file" = "true" ] && [ -f "$rc_file" ]; then
        echo "Using shellcheck config: $rc_file"
        ## Copy rc file to rendered directory so shellcheck can find it
        cp "$rc_file" "${rendered_dir}/.shellcheckrc"
    else
        echo "Not using .shellcheckrc file"
        ## Add basic exclusions for rendered files
        exclude_codes="SC2154"  # Variables from templates are now assigned
    fi
    
    echo "Finding shell scripts in rendered output..."
    
    ## Find all shell scripts in rendered directory
    local scripts
    mapfile -t scripts < <(find_shell_scripts "$rendered_dir")
    
    local script_count="${#scripts[@]}"
    echo "Found ${script_count} shell script(s)"
    
    if [ "$script_count" -eq 0 ]; then
        echo "No shell scripts found to check"
        return 0
    fi
    
    echo ""
    echo "================================"
    echo "Running Shellcheck on Rendered Files"
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
        local relative_path="${script#$rendered_dir/}"
        
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
    echo "Shellcheck Summary (Rendered)"
    echo "================================"
    echo "Checked: ${checked_count} files"
    echo "Failed:  ${failed_count} files"
    echo "Passed:  $((checked_count - failed_count)) files"
    echo ""
    
    if [ "$failed_count" -gt 0 ]; then
        echo "[ERROR] Shellcheck found issues in ${failed_count} rendered file(s)"
        return 1
    else
        echo "SUCCESS: All rendered scripts passed shellcheck"
        return 0
    fi
}

## Main execution
main() {
    local severity="warning"
    local use_rc_file="false"
    local keep_rendered="false"
    
    ## Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --severity|-s)
                severity="$2"
                shift 2
                ;;
            --use-rc)
                use_rc_file="true"
                shift
                ;;
            --keep)
                keep_rendered="true"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Render chezmoi templates and run shellcheck on the rendered output"
                echo ""
                echo "Options:"
                echo "  --severity, -s LEVEL Minimum severity level (error, warning, info, style)"
                echo "                       Default: warning"
                echo "  --use-rc             Use .shellcheckrc from repository root"
                echo "                       Default: false (rendered files should be valid shell)"
                echo "  --keep               Keep rendered files in /tmp after scan"
                echo "  --help, -h           Show this help message"
                echo ""
                echo "Note: This scans RENDERED templates, so template variables should be resolved"
                exit 0
                ;;
            *)
                echo "[ERROR] Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    echo "Shellcheck Rendered Scan Script"
    echo "Script location: ${THIS_DIR}"
    echo "Repository root: ${REPO_ROOT}"
    
    echo ""
    
    ## Check for required tools
    if ! check_shellcheck; then
        echo "[ERROR] Shellcheck is required but not installed"
        echo "Please install shellcheck first"
        exit 1
    fi
    
    if ! check_chezmoi; then
        echo "[ERROR] Chezmoi is required but not installed"
        echo "Please install chezmoi first"
        exit 1
    fi
    
    echo ""
    
    ## Render chezmoi templates
    local rendered_dir
    rendered_dir=$(render_chezmoi "/tmp/chezmoi-shellcheck-$$")
    
    if [ -z "$rendered_dir" ] || [ ! -d "$rendered_dir" ]; then
        echo "[ERROR] Failed to render templates"
        exit 1
    fi
    
    echo ""
    
    ## Run shellcheck on rendered files
    local result=0
    if run_shellcheck "$rendered_dir" "$severity" "$use_rc_file"; then
        result=0
    else
        result=1
    fi
    
    ## Cleanup
    if [ "$keep_rendered" = "true" ]; then
        echo ""
        echo "Rendered files kept at: ${rendered_dir}"
    else
        echo ""
        echo "Cleaning up: ${rendered_dir}"
        rm -rf "$rendered_dir"
    fi
    
    exit $result
}

## Run main function
main "$@"
