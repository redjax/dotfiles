#!/usr/bin/env bash

set -uo pipefail

if ! command -v intelli-shell &>/dev/null; then
  echo "[ERROR] intelli-shell is not installed."

  exit 1
fi

EXPORT_DIR="$HOME/backup/intellishell"
EXPORT_FILENAME="commands.bak"

FORCE=false

function usage() {
  echo ""
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo ""
  echo "  -o|--output-dir  Directory where commands will be exported to."
  echo "  -f|--file        The name of the exported commands file (default: commands.bak)"
  echo "  -F|--force       Automatically overwrite any existing backup files."
  echo ""
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -o | --output-dir)
    if [[ -z "$2" ]]; then
      echo "[ERROR] --output-dir provided but no directory path given"

      usage
      exit 1
    fi

    EXPORT_DIR="$2"
    shift 2
    ;;
  -f | --file)
    if [[ -z "$2" ]]; then
      echo "[ERROR] --file provided but no filename given"

      usage
      exit 1
    fi

    EXPORT_FILENAME="$2"
    shift 2
    ;;
  -F | --force)
    FORCE=true
    shift
    ;;
  *)
    echo "[ERROR] Invalid argument: $1"

    usage
    exit 1
    ;;
  esac
done

EXPORT_FILE_PATH="${EXPORT_DIR}/${EXPORT_FILENAME}"
if [[ ! -d "${EXPORT_DIR}" ]]; then
  echo "[WARNING] Export directory does not exist: ${EXPORT_DIR}"
  echo "Creating export directory."

  mkdir -p "$EXPORT_DIR"
fi

if [[ "$FORCE" == false ]] && [[ -f "${EXPORT_FILE_PATH}" ]]; then
  echo "[WARNING] Output file '$EXPORT_FILE_PATH' already exists."

  while true; do
    read -n 1 -r -p "Overwrite? (y/n): " yn
    echo ""

    case "$yn" in
    [Yy])
      break
      ;;
    [Nn])
      echo "Exiting."
      exit 0
      ;;
    *)
      echo "[ERROR] Invalid choice: $yn. Please use 'y' or 'n'."
      ;;
    esac
  done
fi

echo "[ Backup Intell-Shell Commands ]"
if ! intelli-shell export "${EXPORT_FILE_PATH}"; then
  echo "[ERROR] Failed to export intell-shell commands to file '$EXPORT_FILE_PATH'"
  exit $?
else
  echo "Intell-shell commands exported to: ${EXPORT_FILE_PATH}."
  exit 0
fi
