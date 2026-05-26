#!/usr/bin/env bash
set -euo pipefail

function install_ghostty_themes() {
  echo "Installing Ghostty themes (iTerm2 Color Schemes)..."

  THEME_DIR="$HOME/.config/ghostty/themes"
  mkdir -p "$THEME_DIR"

  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' RETURN

  git clone --depth 1 \
    https://github.com/mbadolato/iTerm2-Color-Schemes.git \
    "$TMP_DIR/schemes"

  if [ ! -d "$TMP_DIR/schemes/ghostty" ]; then
    echo "[ERROR] Ghostty theme export folder not found in repository."
    exit 1
  fi

  cp -f "$TMP_DIR/schemes/ghostty/"* "$THEME_DIR/"

  echo "Themes installed to: $THEME_DIR"
}

install_ghostty_themes
