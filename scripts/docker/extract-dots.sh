#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT=$(realpath -m "$THIS_DIR/../..")
DIST_DIR="${REPO_ROOT}/dist"

HOST_DIR="${DIST_DIR}/chezmoi-dots"
mkdir -p "${HOST_DIR}"

echo "Extracting dotfiles to ${HOST_DIR}"

docker run --rm \
  -v "${HOST_DIR}:/chezmoi-output" \
  chezmoi-render \
  chezmoi apply --destination /chezmoi-output

echo "Dotfiles extracted to ${HOST_DIR}"
ls -la "${HOST_DIR}"
