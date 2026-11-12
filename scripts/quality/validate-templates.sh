#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"

CHEZMOI_CONFIG="$REPO_ROOT/.ci/chezmoi.toml"
CHEZMOI_DATA="$REPO_ROOT/.ci/data.json"
SOURCE_DIR="$REPO_ROOT/home"

for file in "$CHEZMOI_CONFIG" "$CHEZMOI_DATA" "$SOURCE_DIR/.chezmoi.toml.tmpl"; do
  if [[ ! -f "$file" ]]; then
    echo "ERROR: Required file not found: $file" >&2
    exit 1
  fi
done

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "ERROR: chezmoi is not installed." >&2
  exit 1
fi

echo "Validating chezmoi templates"
echo

# Validate ordinary templates.
while IFS= read -r -d '' template; do
  relative_path="${template#"$REPO_ROOT"/}"

  ## The chezmoi initialization template is handled separately.
  [[ "$template" == "$SOURCE_DIR/.chezmoi.toml.tmpl" ]] && continue

  printf 'Checking: %s ' "$relative_path"

  if chezmoi \
    --source "$REPO_ROOT" \
    --config "$CHEZMOI_CONFIG" \
    execute-template \
    --override-data-file "$CHEZMOI_DATA" \
    --file "$template" \
    >/dev/null; then
    echo "OK"
  else
    echo "FAILED"
    exit 1
  fi

done < <(find "$SOURCE_DIR" -type f -name '*.tmpl' -print0)

echo
echo "All ordinary templates validated successfully."
