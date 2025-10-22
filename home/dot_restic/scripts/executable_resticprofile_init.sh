#!/usr/bin/env bash

set -uo pipefail

#########
# SETUP #
#########

ORIGINAL_PATH="$(pwd)"
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTRESTIC_ROOT="$(cd "${THIS_DIR}/../" && pwd)"

IGNORES_DIR="${DOTRESTIC_ROOT}/ignores"
PASSWORDS_DIR="${DOTRESTIC_ROOT}/passwords"
PROFILES_DIR="${DOTRESTIC_ROOT}/profiles"

DEFAULT_PROFILE_YML="${PROFILES_DIR}/default.yaml"

## Script option defaults
DRY_RUN=false
DEBUG=false
KEY_OUTPUT_DIR="${PASSWORDS_DIR}"

function check_installed() {
    local app_cmd

    if [[ -z $1 ]] || [[ "$1" == "" ]]; then
        echo "[WARNING] You must pass a command to check, example: check_installed restic"
        return 2
    fi

    app_cmd=$1

    if ! command -v $app_cmd &>/dev/null; then
        echo "Command '$app_cmd' is not available"
        return 1
    else
        return 0
    fi

}

## EXIT trap
function cleanup() {
    cd "$ORIGINAL_PATH"
}
trap cleanup EXIT

## Ensure dependencies installed
for depend in restic resticprofile; do
    check_installed $depend
done

function debug() {
    local _debug

    _debug=$DEBUG

    if [[ $DEBUG == true ]]; then
        echo "[DEBUG] ${@}"
    fi
}

function greeting() {
    local dry_run_enabled

    dry_run_enabled=$DRY_RUN

    echo ""
    echo "[ resticprofile setup ]"
    echo ""
    if [[ "$dry_run_enabled" == true ]]; then
        echo "+ Dry run enabled. No real actions will be taken."
        echo "  Instead, the action will be described and passed."
        echo ""
    fi
    echo "This script walks through my standard setup steps for resticprofile."
    echo "You will need to finish the setup at the end, this just puts files in"
    echo "place and generates passwords."
    echo ""
    echo "----------------------------------------------------------------------"
    echo ""
}

function print_help() {
    echo ""
    echo "Usage: ${0} [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run            Enable DRY_RUN mode. Skip all actions and describe instead."
    echo "  --debug              Enable DEBUG logging."
    echo "  -o|--key-output-dir  Directory to export generatedd resticprofile keys to."
    echo "  -h|--help            Print help menu and exit."
    echo ""
}

## Function to print manual steps required after this script
function print_next_steps() {
    echo ""
    echo "[ Next Steps ]"
    echo ""

    echo "This script does *not* fully automate the resticprofile setup process."
    echo "You will need to do the following to finish the setup process:"

    echo ""
}

## Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --debug)
            DEBUG=true

            echo "DEBUG logging enabled"
            shift
            ;;
        -o|--key-output-dir)
            if [[ -z $2 ]]; then
                echo "[ERROR] --key-output-dir provided, but no directory path given"
                
                print_help
                exit 1
            fi

            KEY_OUTPUT_DIR="$2"
            shift 2
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo "[ERROR] Invalid option: $1"
            print_help
            exit 1
            ;;
    esac
done

debug "Original path: $ORIGINAL_PATH"
debug "Script path: $THIS_DIR"
debug ".restic root path: $DOTRESTIC_ROOT"

## Print script greeting
greeting

## -----------------------------------------------------------------------------------------

function gen_profile_key() {
    local key_name
    local output_dir
    local script_path

    script_path="${DOTRESTIC_ROOT}/scripts/apps/resticprofile/generate-key.sh"
    key_name="main"
    output_dir=$KEY_OUTPUT_DIR

    output_path="${output_dir}/${key_name}"

    ## Parse inputs
    while [[ $# -gt 0 ]]; do
        case $1 in
            -k|--key-name)
                if [[ -z $2 ]]; then
                    echo "[ERROR] --key-name provided, but no key name string given."
                    return 1
                fi

                key_name="$2"
                shift 2
                ;;
            -o|--output-dir)
                if [[ -z $2 ]]; then
                    echo "[ERROR] --output-dir provided, but no directory path given."
                    return 1
                fi

                output_dir="$2"
                shift 2
                ;;
            *)
                echo "[ERROR] Invalid argument for gen_profile_key(): $1"
                return 2
                ;;
        esac
    done

    debug "(gen_profile_key) script_path: $script_path"
    debug "(gen_profile_key) key_name: $key_name"
    debug "(gen_profile_key) ouput_dir: $output_dir"
    debug "(gen_profile_key) output_path: ${output_path}"

    if [[ ! -f $script_path ]]; then
        echo "[ERROR] Could not find resticprofile key generation script at path: $script_path"
        return 1
    fi

    echo "Generating resticprofile vault key '${key_name}' at path: ${output_path}"
    echo ""

    if [[ ! -d "$output_dir" ]]; then
        echo "[WARNING] resticprofile key output directory does not exist"
        
        if [[ $DRY_RUN == true ]]; then
            echo "[DRY RUN] Would create directory: $output_dir"
        else
            echo "Creating path: $output_dir"

            mkdir -p "${output_dir}"
            if [[ $? -ne 0 ]]; then
                echo "[ERROR] Failed to create resticprofile key output directory."
                return $?
            fi
        fi
    fi

    cmd=(. $script_path -o "$output_path")

    if [[ $DRY_RUN == true ]]; then
        echo "[DRY RUN] Would call resticprofile key generate script with command:"
        echo "  ${cmd[*]}"
    else
        echo "Generating resticprofile key"
        echo "  Command: ${cmd[*]}"

        "${cmd[@]}"
    fi
}

function main() {
    local run_all
    run_all=false

    local do_key_gen
    do_key_gen=false

    local copy_configs
    copy_configs=false

    ## Prompt user to determine which parts of script to run
    function get_run_config() {
        echo "Choose which parts of the script to run."
        echo "If you answer 'y' to the 'run all' prompt, the following will occur:"
        echo "  - Encryption keys 'main' and 'user' created for initializing & accessing the repository."
        echo ""
        
        ## Ask 'run all' first
        while true; do
            read -n 1 -r -p "Run all setup operations? (y/n): " _run_all_choice
            echo ""

            case $_run_all_choice in
                [Yy])
                    run_all=true
                    break
                    ;;
                [Nn])
                    break
                    ;;
                *)
                    echo "Invalid choice: $1. Please answer 'y' or 'n'"
                    ;;
            esac
        done

        ## Set all to true if run_all=true
        if [[ $run_all == true ]]; then
            echo ""
            echo "! Running all script operations"
            echo ""

            do_key_gen=true
            copy_configs=true

            ## Skip the rest of the parsing
            return
        fi

        ## Prompt for generating resticprofile keys
        while true; do
            read -n 1 -r -p "Do you want this script to generate a 'main' and 'user' key for the restic repository? (y/n): " _key_gen_choice
            echo ""

            case $_key_gen_choice in
                [Yy])
                    do_key_gen=true
                    break
                    ;;
                [Nn])
                    break
                    ;;
            esac
        done
        
        while true; do
            read -n 1 -r -p "Do you want this script to copy the default profiles.yaml file to ~/profiles.yaml? (y/n): " _copy_configs_choice
            echo ""
            
            case $_copy_configs_choice in
                [Yy])
                    copy_configs=true
                    break
                    ;;
                [Nn])
                    break
                    ;;
                *)
                    echo "Invalid choice: $1. Please use 'y' or 'n'."
                    echo ""
                    ;;
            esac
        done

    }

    ## Parse uses's choices
    get_run_config

    if [[ $do_key_gen == true ]]; then
        echo "--[ Generate keys"
        echo ""

        echo "+ Generating 'main' key"
        gen_profile_key --key-name "main" --output-dir "$KEY_OUTPUT_DIR"

        echo ""
        echo "+ Generating 'user' key"
        gen_profile_key --key-name "user" --output-dir "$KEY_OUTPUT_DIR"

        echo ""
        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to generate resticprofile key. Error code: $?"
            return $?
        fi
    fi

    if [[ $copy_configs == true ]]; then
        echo ""
        echo "--[ Copy configuration files"
        echo ""

        echo "+ Copying default profile to ~/.profiles.yaml"
        if [[ $DRY_RUN == true ]]; then
            echo "[DRY RUN] Would copy resticprofile '$DEFAULT_PROFILE_YML' to path '$HOME/profiles.yaml'"
        else
            /usr/bin/cp "$DEFAULT_PROFILE_YML" "$HOME/profiles.yaml"
            if [[ $? -ne 0 ]]; then
                echo "[ERROR] Failed to copy default profiles.yaml file to '$HOME/profiles.yaml'."
                return $?
            fi
        fi
    fi

    return $?
}

echo "----------------------------------------------------------------------"

## If script is called directly, execute
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"

    if [[ $? -ne 0 ]]; then
        echo ""
        echo "[ERROR] Failed doing resticprofile initial setup."
        echo ""

        exit $?
    else
        echo ""
        echo "Finished resticprofile initialization."
        echo ""

        print_next_steps

        exit 0
    fi
fi
