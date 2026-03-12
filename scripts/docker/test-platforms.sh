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
