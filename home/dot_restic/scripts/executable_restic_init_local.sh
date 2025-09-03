#!/bin/bash

##
# Script to initialize a local Restic backup on a new host.
##

set -euo pipefail

## Path to this script's parent dir
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## Path to ~/.restic dir
DOT_RESTIC_DIR="$HOME/.restic"
RESTIC_PASSWORDS_DIR="$DOT_RESTIC_DIR/passwords"
RESTIC_PASSWORD_FILE="$RESTIC_PASSWORDS_DIR/main"
RESTIC_PASSWORD=""

## Default values
RESTIC_REPO_DIR=""
DRY_RUN=""

## Functions

function print_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Initialize a Restic repository on the local machine.

OPTIONS:
  -r, --repo, --repository PATH            Path to restic repository directory (required)
  -p, --password           STRING          Password for restic repository
  -P, --password-file      PATH            Path to restic password file
  --dry-run                                Print the restic command that would be run, but do not execute
  -h, --help                               Display this help and exit

EXAMPLES:
  $(basename "$0") -r /etc/restic/repo

NOTES:
  - Restic is required. See [https://restic.readthedocs.io/en/latest/020_installation.html](https://restic.readthedocs.io/en/latest/020_installation.html)
  - Run with --dry-run to see command without running it.
EOF
}

read_password() {
    while true; do
        # Prompt for password silently
        read -rsp "Enter restic repository password: " pass1
        echo
        read -rsp "Confirm password: " pass2
        echo

        if [[ "$pass1" == "$pass2" ]]; then
            echo "$pass1"
            break
        else
            echo "Passwords do not match. Please try again."
        fi
    done
}

if [[ ! $(command -v restic) ]]; then
    echo "[ERROR] Restic is not installed. Please install Restic and retry."
    exit 1
fi

## Parse CLI args
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo|--repository)
            if [[ -z $2 ]]; then
                echo "[ERROR] --repo-dir provided but no path given."

                print_help
                exit 1
            fi

            RESTIC_REPO_DIR="$2"
            shift 2
            ;;
        -p|--password)
            if [[ -z $2 ]]; then
                echo "[ERROR] --password provided but no password given."

                print_help
                exit 1
            fi

            RESTIC_PASSWORD="$2"
            shift 2
            ;;
        -P|--password-file)
            if [[ -z $2 ]]; then
                echo "[ERROR] --password-file provided but no path given."

                print_help
                exit 1
            fi

            RESTIC_PASSWORD_FILE="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN="true"
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo "[ERROR] Unknown argument: $1"
            print_help
            exit 1
            ;;
    esac
done

if [[ -z "$RESTIC_REPO_DIR" ]]; then
    echo "[ERROR] --repo-dir is required."
    echo ""

    print_help
    exit 1
fi


## Ensure the password directory exists
mkdir -p "$RESTIC_PASSWORDS_DIR"


if [[ -z "$DRY_RUN" ]]; then


    ## If password not provided, prompt the user for it and confirm
    if [[ -z "$RESTIC_PASSWORD" ]]; then
        RESTIC_PASSWORD=$(read_password)
    fi

    ## Temporarily save password to file with safe permissions
    echo "$RESTIC_PASSWORD" > "$RESTIC_PASSWORD_FILE"
    chmod 600 "$RESTIC_PASSWORD_FILE"


    ## Build Restic init command with password-file
    cmd=(restic init --repo "$RESTIC_REPO_DIR" --password-file "$RESTIC_PASSWORD_FILE")
    
    echo "Running restic init command: ${cmd[@]}"


    ## Run the restic init command
    "${cmd[@]}"

    ## Show the password once to the user with warning
    echo
    echo "IMPORTANT: This is the last time you will see your Restic master password."
    echo "Please save it somewhere secure."
    echo "Restic repository password: $RESTIC_PASSWORD"
    echo

    ## Securely delete the password file
    if command -v shred &>/dev/null; then
        shred -u "$RESTIC_PASSWORD_FILE"
    else
        rm -f "$RESTIC_PASSWORD_FILE"
    fi

    ## Save the repository path into ~/.restic/repo_path
    mkdir -p "$DOT_RESTIC_DIR"
    echo "$RESTIC_REPO_DIR" > "$DOT_RESTIC_DIR/repo_path"

    ## Offer to add a user access key
    read -rp "Would you like to add a user access key? (y/N): " add_key
    if [[ "$add_key" =~ ^[Yy]$ ]]; then
        ## Determine the path to save the user access key
        if [[ -z "${RESTIC_PASSWORD_FILE:-}" ]]; then
            read -rp "Enter path to save the user access key: " user_key_path
        else
            user_key_path="$RESTIC_PASSWORD_FILE"
        fi

        echo "Adding user access key and saving to $user_key_path ..."

        ## Use restic key add with --password-command to pass the master password
        restic -r "$RESTIC_REPO_DIR" --password-command "echo $RESTIC_PASSWORD" key add > "$user_key_path"

        chmod 600 "$user_key_path"
        echo "User access key saved to $user_key_path"
    else
        echo "User access key was not added."
    fi

else
    if [[ -z "$RESTIC_PASSWORD" && -z "$RESTIC_PASSWORD_FILE" ]]; then
        echo "  Would prompt for a password (none was given)"
    else
        if [[ -n "$RESTIC_PASSWORD_FILE" ]]; then
            cmd+=(--password-file "$RESTIC_PASSWORD_FILE")
        fi
    fi

    echo "Would run restic init command: ${cmd[@]}"
    exit 0
fi
