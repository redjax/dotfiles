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
  - Restic is required. See https://restic.readthedocs.io/en/latest/020_installation.html
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
            exit
            ;;
        *)
            echo "[ERROR] Unknown argument: $1"
            print_help
            ;;
    esac
done

if [[ -z "$RESTIC_REPO_DIR" ]]; then
    echo "[ERROR] --repo-dir is required."
    echo ""

    print_help
    exit 1
fi

## Build Restic command
cmd=(restic init --repo "$RESTIC_REPO_DIR")

if [[ -z "$DRY_RUN" ]] || [[ "$DRY_RUN" == "" ]]; then

    if [[ -n "$RESTIC_PASSWORD" ]]; then
        ## Ask user for password and confirm
        password=$(read_password)
    fi

    ## Save password securely to a file
    chmod 600 "$RESTIC_PASSWORD_FILE"
    echo "$password" > "$RESTIC_PASSWORD_FILE"
    unset password

    ## Add --password-file to command
    cmd+=(--password-file "$RESTIC_PASSWORD_FILE")
    
    echo "Running restic init command: ${cmd[@]}"

    ## Run the command
    "${cmd[@]}"
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
