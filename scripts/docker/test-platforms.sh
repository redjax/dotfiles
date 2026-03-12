#!/usr/bin/env bash
set -euo pipefail

## Array of Docker container image tags
#  to test chezmoi rendering
declare -a IMAGES=(
  ubuntu:24.04
  debian:bookworm
  debian:trixie
  alpine:3.23
  fedora:43
  archlinux:latest
)

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT=$(realpath -m "$THIS_DIR/../..")
CONTAINER_DIR="${REPO_ROOT}/.containers/render"
ORIGINAL_PATH="$(pwd)"

GITHUB_USERNAME="${GITHUB_USERNAME:-}"
HOST_USER="${HOST_USER:-}"

## Arrays to store pass/fail jobs
declare -a ARR_PASSED=()
declare -a ARR_FAILED=()

## Function to call on script exit
function cleanup() {
  cd "${ORIGINAL_PATH}"
  rm -rf /tmp/chezmoi-test-*
}
## Call cleanup function on any exit (0, 1, etc)
trap cleanup EXIT

## Prompt user for GITHUB_USERNAME value
if [[ -z "${GITHUB_USERNAME}" ]]; then
  echo "[ERROR] Missing GITHUB_USERNAME" >&2

  while true; do
    read -r -p "Github username: " gh_user

    if [[ -z "${gh_user}" ]]; then
      echo "[!] Please enter a Github username"
      echo
    else
      GITHUB_USERNAME="${gh_user}"
      break
    fi
  done

fi

## Prompt user for missing HOST_USER value
if [[ -z "${HOST_USER}" ]]; then
  echo "[ERROR] Missing HOST_USER" >&2

  while true; do
    read -r -p "Linux user (for Chezmoi dotfile render): " hst_user

    if [[ -z "${hst_user}" ]]; then
      echo "[!] Please enter a Linux user"
      echo
    else
      HOST_USER="${hst_user}"
      break
    fi
  done

fi

echo
echo "[ Chezmoi container render ]"
echo "| Test dotfile rendering in differet Docker containers."
echo "|"
echo "| Values:"
echo "|   - GITHUB_USERNAME: ${GITHUB_USERNAME:-<unset>}"
echo "|   - HOST_USER      : ${HOST_USER:-<unset>}"
echo "|"
echo "| Chezmoi will search for dotfiles at:"
echo "|   https://github.com/$GITHUB_USERNAME/dotfiles"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

sleep 1

for img in "${IMAGES[@]}"; do
  echo
  echo "[*] Testing image: $img"
  echo

  TEST_DIR=$(mktemp -d -p /tmp chezmoi-test-XXXXXXXX)

  ## Create Dockerfile on the fly based on image
  cat > "$TEST_DIR/Dockerfile" << EOF
  FROM $img

  ## Install curl & getent equivalents
  RUN if command -v apt-get >/dev/null 2>&1; then \
        apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*; \
      elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache curl shadow busybox-extras; \
      elif command -v dnf >/dev/null 2>&1; then \
        dnf install -y curl shadow-utils && dnf clean all; \
      elif command -v yum >/dev/null 2>&1; then \
        yum install -y curl shadow-utils && yum clean all; \
      elif command -v pacman >/dev/null 2>&1; then \
        pacman -Sy --noconfirm curl && pacman -Scc --noconfirm; \
      else \
        echo "Unsupported package manager" && exit 1; \
      fi

  ## Create dummy user for getent
  RUN useradd -m -u 1000 $HOST_USER || true

  ## Install chezmoi
  RUN sh -c "\$(curl -fsLS get.chezmoi.io)" -- init $GITHUB_USERNAME

  ENV HOME=/root \
      USER=$HOST_USER \
      CHEZMOI_USERNAME=$HOST_USER

  CMD ["chezmoi", "apply", "--dry-run"]
EOF

  if docker build -t "chezmoi-test-$img" "$TEST_DIR" && \
     docker run --rm "chezmoi-test-$img"; then
    echo
    echo "[SUCCESS] $img : PASS"
  else
    echo
    echo "[FAILURE] $img : FAILED"
  fi

  echo
  
  docker rmi "chezmoi-test-$img" &>/dev/null || true
  rm -rf "$TEST_DIR" &>/dev/null

  echo "----------------------------------------------------------------------------------"
  echo
done

echo "All platform tests complete"
