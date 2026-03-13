#!/usr/bin/env bash
set -euo pipefail

echo "Starting interactive shell (user: ${HOST_USER:-jack})"
docker run -it chezmoi-render /bin/bash
