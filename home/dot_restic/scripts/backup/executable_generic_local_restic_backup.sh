#!/bin/bash

##
# This script is a generic Restic backup script.
# You can use it as a starting/reference point for
# customized backup scripts, or just use this to
# run/schedule backups.
#
# This script assumes you're storing your password
# locally in a file, and using a local repository.
##

## Set default vars
SRC_DIR=""
RESTIC_REPO_FILE=""
RESTIC_PW_FILE=""
DRY_RUN=""

## Create array of exclude files to pass to restic
EXCLUDE_FILES=()
## Create array of exclude patternss to pass to restic
EXCLUDE_PATTERNS=()

## Define -h/--help function
function print_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Restic backup script with support for multiple exclude files and patterns.

OPTIONS:
  -s, --backup-src DIR           Source directory to back up (required)
  -r, --repo-file PATH           Path to file with restic repository path (required)
  -p, --password-file PATH       Path to restic password file (required)
  --exclude-file PATH            Path to a file containing exclude patterns (can be used multiple times)
  --exclude-pattern PATTERN      Single exclude pattern (can be used multiple times)
  --dry-run                      Print the restic command that would be run, but do not execute
  -h, --help                     Display this help and exit

EXAMPLES:
  $(basename "$0") -s /home/username -r /etc/restic/repo -p /etc/restic/pw \
      --exclude-file ~/.restic/ignores/default --exclude-pattern "*.cache" --dry-run

NOTES:
  - You can specify --exclude-file and --exclude-pattern multiple times to pass multiple values.
  - Run with --dry-run to see command without running it.
EOF
}

## Parse CLI args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--backup-src)
      if [[ -z $2 ]]; then
        echo "[ERROR] --backup-src provided but no path given."

        print_help
        exit 1
      fi

      SRC_DIR="$2"
      shift 2
      ;;
    -r|--repo-file)
      if [[ -z $2 ]]; then
        echo "[ERROR] --repo-file provided but no path given."

        print_help
        exit 1
      fi

      RESTIC_REPO_FILE="$2"
      shift 2
      ;;
    -p|--password-file)
      if [[ -z $2 ]]; then
        echo "[ERROR] --password-file provided but no path given."

        print_help
        exit 1
      fi

      RESTIC_PW_FILE="$2"
      shift 2
      ;;
    --exclude-file)
      if [[ -n "$2" && "$2" != --* ]]; then
          EXCLUDE_FILES+=("$2")
          shift 2
      else
          echo "[ERROR] --exclude-file provided but no path given."

          print_help
          exit 1
      fi
      ;;
    --exclude-pattern)
      if [[ -n "$2" && "$2" != --* ]]; then
          EXCLUDE_PATTERNS+=("$2")
          shift 2
      else
          echo "[ERROR] --exclude-pattern provided but no path given."

          print_help
          exit 1
      fi
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
      echo "[ERROR] Unrecognized flag: $1"

      print_help
      exit 1
      ;;
  esac
done

## Export env vars for script
export RESTIC_REPOSITORY_FILE="$RESTIC_REPO_FILE"
export RESTIC_PASSWORD_FILE="$RESTIC_PW_FILE"

## Build command
cmd=(restic backup "$SRC_DIR")

## Append all exclude files
for excl_file in "${EXCLUDE_FILES[@]}"; do
  cmd+=(--exclude-file "$excl_file")
done

## Append all exclude patterns
for excl_pattern in "${EXCLUDE_PATTERNS[@]}"; do
  cmd+=(--exclude "$excl_pattern")
done

## Print or run command
if [[ -z "$DRY_RUN" ]] || [[ "$DRY_RUN" == "" ]]; then
  echo "Running restic cleanup command: ${cmd[@]}"

  ## Run the command
  "${cmd[@]}"

  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to run restic cleanup command."
    exit 1
  else
    echo "Restic cleanup performed successfully"
    exit 0
  fi
else
  echo "[DRY RUN] Would run restic cleanup command: ${cmd[@]}"
  exit 0
fi
