#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker &>/dev/null; then
  echo "[ERROR] Docker is not installed." >&2
  exit 1
fi

if ! docker run --rm -v $HOME:/live chezmoi-render chezmoi diff --destination /live 2>&1; then
  echo "[ERROR] Failed to diff live dotfiles with chezmoi rendered files." >&2
  exit 1
fi
