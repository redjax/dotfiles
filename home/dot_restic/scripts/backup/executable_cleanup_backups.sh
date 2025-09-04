#!/bin/bash

##
# Run a cleanup/purge of Restic snapshots,
# with configurable retention
#
# This script can be scheduled as a cron job,
# i.e. once a week on Sunday at 4:30am:
#   30 04 * * 0 /path/to/cleanup_backups.sh -r /etc/restic/repo -p /etc/restic/pw > /var/log/restic/cleanup/weekly_cleanup.log 2>&1
#
# If you output to a log with > /path/to/cleanup.log 2>&1,
# the '/path/to' path must exist. Create with sudo mkdir -p /path/to (or wherever you output the log).
##

set -euo pipefail

## Paths
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOT_RESTIC_DIR="$HOME/.restic"
RESTIC_PASSWORDS_DIR="$DOT_RESTIC_DIR/passwords"

## Defaults
RESTIC_REPO_FILE=""
RESTIC_PW_FILE=""
DRY_RUN=""

KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=12

## Clean environment for restic
unset RESTIC_REPOSITORY_FILE
unset RESTIC_REPOSITORY
unset RESTIC_PASSWORD_FILE

print_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Restic cleanup script.

OPTIONS:
  -r, --repo-file PATH           Path to file with restic repository path (required)
  -p, --password-file PATH       Path to restic password file (required)
  --keep-daily N                 Retain last N daily snapshots (default: $KEEP_DAILY)
  --keep-weekly N                Retain last N weekly snapshots (default: $KEEP_WEEKLY)
  --keep-monthly N               Retain last N monthly snapshots (default: $KEEP_MONTHLY)
  --dry-run                      Print the restic command that would be run, but do not execute
  -h, --help                     Display this help and exit

EXAMPLES:
  $(basename "$0") -r /etc/restic/repo -p /etc/restic/pw

NOTES:
  - Run with --dry-run to see command without running it.
EOF
}

## Require restic
if ! command -v restic &>/dev/null; then
    echo "[ERROR] Restic is not installed. Please install Restic and retry."
    exit 1
fi

## Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo-file|--repository-file)
            if [[ -z ${2:-} ]]; then
                echo "[ERROR] --repository-file provided but no path given."
                print_help; exit 1
            fi
            
            RESTIC_REPO_FILE="$2"; shift 2
            ;;
        -p|--password-file)
            if [[ -z ${2:-} ]]; then
                echo "[ERROR] --password-file provided but no path given."
                print_help; exit 1
            fi

            RESTIC_PW_FILE="$2"; shift 2
            ;;
        --keep-daily)
            if [[ -n "$2" && "$2" != --* ]]; then
                KEEP_DAILY="$2"
                shift 2
            else
                echo "[ERROR] --keep-daily provided but no number given."

                print_help
                exit 1
            fi
            ;;
            --keep-weekly)
            if [[ -n "$2" && "$2" != --* ]]; then
                KEEP_WEEKLY="$2"
                shift 2
            else
                echo "[ERROR] --keep-weekly provided but no number given."

                print_help
                exit 1
            fi
            ;;
            --keep-monthly)
            if [[ -n "$2" && "$2" != --* ]]; then
                KEEP_MONTHLY="$2"
                shift 2
            else
                echo "[ERROR] --keep-monthly provided but no number given."

                print_help
                exit 1
            fi
            ;;
        --dry-run)
            DRY_RUN="true"; shift 1
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

if [[ -z "$RESTIC_REPO_FILE" ]]; then
    echo "[ERROR] --repository-file is required."
    echo
    print_help
    exit 1
fi

if [[ -z "$RESTIC_PW_FILE" ]]; then
    echo "[ERROR] --password-file is required."
    echo
    print_help
    exit 1
fi

if [[ -z "$KEEP_DAILY" ]] || [[ -z "$KEEP_WEEKLY" ]] || [[ -z "$KEEP_MONTHLY" ]]; then
    echo "[ERROR] --keep-daily, --keep-weekly, and --keep-monthly are required."
    echo

    print_help
    exit 1
fi

## Export env vars for script
export RESTIC_REPOSITORY_FILE="$RESTIC_REPO_FILE"
export RESTIC_PASSWORD_FILE="$RESTIC_PW_FILE"

## Build command
cmd=(
    restic
    forget
    --keep-daily $KEEP_DAILY
    --keep-weekly $KEEP_WEEKLY
    --keep-monthly $KEEP_MONTHLY
    --prune
    --repository-file $RESTIC_REPO_FILE
    --password-file $RESTIC_PW_FILE
)

if [[ -n "$DRY_RUN" ]]; then
    echo "DRY RUN: Would run command:"
    echo "  $> ${cmd[@]}"
    
    exit 0
else
    echo "Running restic cleanup command: "
    echo "  $> ${cmd[@]}"
    echo ""

    ## Run the command
    "${cmd[@]}"

    exit $?    
fi
