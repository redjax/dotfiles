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
