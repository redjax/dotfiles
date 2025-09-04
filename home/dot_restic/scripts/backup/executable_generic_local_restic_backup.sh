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
SKIP_UNCHANGED=""
RESTIC_FORCE=""

## Create array of exclude files to pass to restic
EXCLUDE_FILES=()
## Create array of exclude patternss to pass to restic
EXCLUDE_PATTERNS=()

## Define cleanup parameters
DO_CLEANUP=""
KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=12

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
  --keep-daily N                 Retain last N daily snapshots when running with --cleanup (default: $KEEP_DAILY)
  --keep-weekly N                Retain last N weekly snapshots when running with --cleanup (default: $KEEP_WEEKLY)
  --keep-monthly N               Retain last N monthly snapshots when running with --cleanup (default: $KEEP_MONTHLY)
  -c, --cleanup                  Run restic cleanup after backup (default: false)
  -S, --skip-if-unchanged        Skip backup if there are no changes (default: false).
  --force                        Add the --force flag to Restic commands.
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
    -c|--cleanup)
      DO_CLEANUP="true"
      shift
      ;;
    -S|--skip-if-unchanged)
      SKIP_UNCHANGED="true"
      shift
      ;;
    -F|--force)
      RESTIC_FORCE="true"
      shift
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

if [[ "$SRC_DIR" == "" ]]; then
  echo "[ERROR] --source-dir should not be empty"
  exit
fi

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

## Append --skip-if-unchanged if SKIP_UNCHANGED is true
if [[ "$SKIP_UNCHANGED" == "true" ]]; then
  cmd+=(--skip-if-unchanged)
fi

## Append --force if RESTIC_FORCE is true
if [[ "$RESTIC_FORCE" != "" ]]; then
  cmd+=(--force)
fi

## Print or run command
if [[ -z "$DRY_RUN" ]] || [[ "$DRY_RUN" == "" ]]; then
  echo "Running restic backup command: "
  echo "  $> ${cmd[@]}"

  ## Run the command
  "${cmd[@]}"

  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to run restic backup command."

    if [[ "$DO_CLEANUP" == "true" ]]; then
      echo "[WARNING] --cleanup detected, but restic backup failed. Cleanup operation will not run."
    fi

    exit 1
  else
    echo "Restic backup performed successfully"

    if [[ "$DO_CLEANUP" == "true" ]]; then
      cleanup_cmd=(restic forget
        --keep-daily "$KEEP_DAILY"
        --keep-weekly "$KEEP_WEEKLY"
        --keep-monthly "$KEEP_MONTHLY"
        --prune
      )

      echo "Running restic cleanup command: "
      echo "  $> ${cleanup_cmd[@]}"

      "${cleanup_cmd[@]}"
      if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to run restic cleanup command."
      fi

    fi

    exit 0
  fi
else
  echo "[DRY RUN] Would run restic backup command: "
  echo "  $> ${cmd[@]}"

  exit 0
fi
