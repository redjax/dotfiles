#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT=$(realpath -m "$THIS_DIR/../..")
CONTAINERS_DIR="${REPO_ROOT}/.containers"

ORIGINAL_PATH="${PWD}"

GITHUB_USERNAME="${GITHUB_USERNAME:-}"
HOST_USER="${HOST_USER:-}"
IMG_VER_TAG="${IMG_VER_TAG:-24.04}"

function cleanup() {
  cd "${ORIGINAL_PATH}"
}

if [[ -z "${GITHUB_USERNAME}" ]]; then
  echo "[ERROR] Missing GITHUB_USERNAME" >&2
  exit 1
fi

if [[ -z "${HOST_USER}" ]]; then
  echo "[ERROR] Missing HOST_USER" >&2
  exit 1
fi

if ! command -v docker &>/dev/null; then
  echo "[ERROR] Docker is not installed" >&2
  exit 1
fi

cd "${CONTAINERS_DIR}/render"
trap cleanup EXIT

docker build \
  --build-arg GITHUB_USERNAME="$GITHUB_USERNAME" \
  --build-arg HOST_USER="$HOST_USER" \
  --build-arg HOST_UID="$(id -u)" \
  --build-arg HOST_GID="$(id -g)" \
  --build-arg IMG_VER_TAG="$IMG_VER_TAG" \
  -t chezmoi-render .

echo "Built chezmoi-render image"
