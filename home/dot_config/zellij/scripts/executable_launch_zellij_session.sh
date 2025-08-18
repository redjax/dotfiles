#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 -s <session_name> -l <layout_file>

Options:
  -s, --session-name  Name of the zellij session
  -l, --layout-file   Path to zellij layout file (.kdl)
  -h, --help          Show this help message
EOF
  exit 1
}

SESSION_NAME=""
LAYOUT_FILE=""

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--session-name)
      SESSION_NAME="$2"
      shift 2
      ;;
    -l|--layout-file)
      LAYOUT_FILE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      usage
      ;;
  esac
done

# Validate args
if [[ -z "$SESSION_NAME" ]] || [[ -z "$LAYOUT_FILE" ]]; then
  echo "[ERROR] Both --session-name and --layout-file are required."
  usage
fi

if ! command -v zellij &>/dev/null; then
  echo "[ERROR] Zellij is not installed."
  exit 1
fi

if [[ ! -f "$LAYOUT_FILE" ]]; then
  echo "[ERROR] Could not find Zellij layout file at path: $LAYOUT_FILE"
  exit 1
fi

# Return clean list of session names
get_sessions() {
  if zellij list-sessions --no-formatting --short 2>/dev/null; then
    return 0
  fi
  zellij list-sessions \
    | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' \
    | sed -E 's/[[:space:]]*\[.*$//' \
    | sed -E 's/[[:space:]]*\(EXITED.*$//' \
    | sed -E '/^No active zellij sessions found\.$/d'
}

SESSIONS="$(get_sessions || true)"

echo "Existing zellij sessions:"
printf '%s\n' "$SESSIONS"

if printf '%s\n' "$SESSIONS" | grep -Fxq "$SESSION_NAME"; then
  echo "Session $SESSION_NAME exists. Attaching..."
  exec zellij attach "$SESSION_NAME"
else
  echo "Session $SESSION_NAME does not exist. Creating new with layout..."
  exec zellij --new-session-with-layout "$LAYOUT_FILE" -s "$SESSION_NAME"
fi

