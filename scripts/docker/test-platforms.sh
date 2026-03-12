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
