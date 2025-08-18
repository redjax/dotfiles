#!/usr/bin/env bash

##############################################
# This is an example script. You can copy it #
# to a location on your machine, set the     #
# LAYOUT_FILE and SESSION_NAME,              #
# and call it with . path/to/launch.sh       #
##############################################

set -euo pipefail

if ! command -v zellij &>/dev/null; then
  echo "[ERROR] Zellij is not installed."
  exit 1
fi

LAYOUT_FILE="$HOME/.config/zellij/layouts/local/YOUR_TEMPLATE.kdl"
SESSION_NAME="YOURSESSION"

if [[ ! -f "$LAYOUT_FILE" ]]; then
  echo "[ERROR] Could not find Zellij layout file at path: $LAYOUT_FILE"
  exit 1
fi

# Return a machine-parseable list of session names (one per line, no colors/extra text)
get_sessions() {
  # Preferred: plain names without formatting (supported in recent Zellij)
  if zellij list-sessions --no-formatting --short 2>/dev/null; then
    return 0
  fi
  # Fallback: strip ANSI escape sequences and trailing decorations like [Created ...] or (EXITED ...)
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

