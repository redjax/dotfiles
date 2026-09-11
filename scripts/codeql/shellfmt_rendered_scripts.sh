#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

RENDERED_DIR="${1:-${REPO_ROOT}/release/dotfiles}"
SHELLFMT_OPTIONS="${SHELLFMT_OPTIONS:-${REPO_ROOT}/.config/shellfmt/options}"

if [[ ! -d "${RENDERED_DIR}" ]]; then
  echo "[ERROR] rendered directory does not exist: ${RENDERED_DIR}" >&2
  exit 1
fi

if [[ ! -f "${SHELLFMT_OPTIONS}" ]]; then
  echo "[ERROR] shellfmt options file does not exist: ${SHELLFMT_OPTIONS}" >&2
  exit 1
fi

if ! command -v shellfmt >/dev/null 2>&1; then
  echo "[ERROR] shellfmt is not installed" >&2
  exit 1
fi

mapfile -d '' shell_files < <(
  find "${RENDERED_DIR}" \
    -type f \
    \( \
    -name '*.sh' \
    -o -name '*.bash' \
    -o -name '*.zsh' \
    -o -name '*.ksh' \
    -o -name '*.bats' \
    \) \
    -print0
)

if ((${#shell_files[@]} == 0)); then
  echo "[WARNING] No shell files found in ${RENDERED_DIR}."
  exit 0
fi

echo "Formatting ${#shell_files[@]} rendered shell file(s)..."

shellfmt \
  --options "${SHELLFMT_OPTIONS}" \
  --write \
  "${shell_files[@]}"

echo "shellfmt completed successfully."
