#!/bin/bash

##
# Script to initialize a local Restic backup on a new host.
##

set -euo pipefail

## Paths
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOT_RESTIC_DIR="$HOME/.restic"
RESTIC_PASSWORDS_DIR="$DOT_RESTIC_DIR/passwords"

## Defaults
RESTIC_REPO_DIR=""
RESTIC_PASSWORD=""
RESTIC_MASTER_PW_FILE=""   # will be set to a mktemp path
DRY_RUN=""

## Clean environment for restic
unset RESTIC_REPOSITORY_FILE
unset RESTIC_REPOSITORY
unset RESTIC_PASSWORD_FILE

print_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Initialize a Restic repository on the local machine.

OPTIONS:
  -r, --repo, --repository PATH            Path to restic repository directory (required)
  -p, --password           STRING          Master password for the restic repository
  -P, --password-file      PATH            Path to file containing the master password
  --dry-run                                Show what would happen without executing
  -h, --help                               Display this help and exit

EXAMPLES:
  $(basename "$0") -r /etc/restic/repo

NOTES:
  - Restic is required: https://restic.readthedocs.io/en/latest/020_installation.html
EOF
}

read_password() {
    while true; do
        read -rsp "Enter restic repository master password: " pass1
        echo
        read -rsp "Confirm password: " pass2
        echo
        if [[ "$pass1" == "$pass2" ]]; then
            printf '%s' "$pass1"
            break
        else
            echo "Passwords do not match. Please try again."
        fi
    done
}

cleanup() {
    # Securely delete temp master password file if it exists
    if [[ -n "${RESTIC_MASTER_PW_FILE:-}" && -f "$RESTIC_MASTER_PW_FILE" ]]; then
        if command -v shred &>/dev/null; then
            shred -u "$RESTIC_MASTER_PW_FILE" || true
        else
            rm -f "$RESTIC_MASTER_PW_FILE" || true
        fi
    fi
}
trap cleanup EXIT

## Require restic
if ! command -v restic &>/dev/null; then
    echo "[ERROR] Restic is not installed. Please install Restic and retry."
    exit 1
fi

## Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo|--repository)
            if [[ -z ${2:-} ]]; then
                echo "[ERROR] --repository provided but no path given."
                print_help; exit 1
            fi
            RESTIC_REPO_DIR="$2"; shift 2
            ;;
        -p|--password)
            if [[ -z ${2:-} ]]; then
                echo "[ERROR] --password provided but no password given."
                print_help; exit 1
            fi
            RESTIC_PASSWORD="$2"; shift 2
            ;;
        -P|--password-file)
            if [[ -z ${2:-} ]]; then
                echo "[ERROR] --password-file provided but no path given."
                print_help; exit 1
            fi
            # Read master password from file
            RESTIC_PASSWORD="$(<"$2")"; shift 2
            ;;
        --dry-run)
            DRY_RUN="true"; shift
            ;;
        -h|--help)
            print_help; exit 0
            ;;
        *)
            echo "[ERROR] Unknown argument: $1"
            print_help; exit 1
            ;;
    esac
done

if [[ -z "$RESTIC_REPO_DIR" ]]; then
    echo "[ERROR] --repository is required."
    echo
    print_help
    exit 1
fi

## Ensure dirs exist
mkdir -p "$RESTIC_PASSWORDS_DIR"

if [[ -z "$DRY_RUN" ]]; then
    ## Master password: prompt if not provided
    if [[ -z "$RESTIC_PASSWORD" ]]; then
        RESTIC_PASSWORD=$(read_password)
    fi

    ## Create a temp file for the master password (shredded at the end)
    RESTIC_MASTER_PW_FILE="$(mktemp "$RESTIC_PASSWORDS_DIR/master_XXXXXX")"
    # Write without trailing newline
    printf '%s' "$RESTIC_PASSWORD" > "$RESTIC_MASTER_PW_FILE"
    chmod 600 "$RESTIC_MASTER_PW_FILE"

    ## Initialize repository
    echo "Running: restic init --repo \"$RESTIC_REPO_DIR\" --password-file <temp>"
    restic init --repo "$RESTIC_REPO_DIR" --password-file "$RESTIC_MASTER_PW_FILE"

    echo
    echo "IMPORTANT: This is the last time you will see your Restic MASTER password here."
    echo "Save it securely (password managers, secure notes, etc.)."
    echo "Master password: $RESTIC_PASSWORD"
    echo

    ## Store repo path for convenience
    printf '%s\n' "$RESTIC_REPO_DIR" > "$DOT_RESTIC_DIR/repo_path"

    ## Offer to add a user access key (separate password, stored in ~/.restic/passwords/main)
    read -rp "Would you like to create a USER KEY and save its password to ~/.restic/passwords/main? (y/N): " add_key
    if [[ "$add_key" =~ ^[Yy]$ ]]; then
        user_key_pw_file="$RESTIC_PASSWORDS_DIR/main"

        # If main exists, confirm overwrite
        if [[ -f "$user_key_pw_file" ]]; then
            read -rp "$user_key_pw_file already exists. Overwrite? (y/N): " overwrite
            if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
                echo "Keeping existing $user_key_pw_file; skipping user key creation."
            else
                do_userkey="yes"
            fi
        else
            do_userkey="yes"
        fi

        if [[ "${do_userkey:-}" == "yes" ]]; then
            # Prompt for user key password (this is the one saved to 'main')
            while true; do
                read -rsp "Enter USER KEY password (will be saved to ~/.restic/passwords/main): " userkey_pass1
                echo
                read -rsp "Confirm USER KEY password: " userkey_pass2
                echo
                if [[ "$userkey_pass1" == "$userkey_pass2" ]]; then
                    break
                else
                    echo "Passwords do not match, please try again."
                fi
            done

            # Save USER KEY password permanently to ~/.restic/passwords/main
            printf '%s' "$userkey_pass1" > "$user_key_pw_file"
            chmod 600 "$user_key_pw_file"

            # Add the user key using:
            #   --password-file <temp master file>
            #   --new-password-file ~/.restic/passwords/main
            echo "Running: restic -r \"$RESTIC_REPO_DIR\" key add --password-file <temp> --new-password-file \"$user_key_pw_file\""
            restic -r "$RESTIC_REPO_DIR" \
                --password-file "$RESTIC_MASTER_PW_FILE" \
                key add \
                --new-password-file "$user_key_pw_file"

            echo "User key created. USER KEY password saved at: $user_key_pw_file"
            echo "To use this key later, you’ll supply --password-file \"$user_key_pw_file\"."
        fi
    fi

    ## Master password temp file is removed at script end by trap
else
    echo "[DRY RUN]"
    echo "Would prompt for (or use provided) MASTER password."
    echo "Would create temp master password file in: $RESTIC_PASSWORDS_DIR (mktemp)"
    echo "Would run: restic init --repo \"$RESTIC_REPO_DIR\" --password-file <temp>"
    echo "Would ask to create a USER KEY:"
    echo "  - If yes: save USER KEY password to ~/.restic/passwords/main"
    echo "  - Then run: restic -r \"$RESTIC_REPO_DIR\" key add --password-file <temp> --new-password-file ~/.restic/passwords/main"
    echo "Would securely delete the temp master password file at the end."
fi
