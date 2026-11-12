#!/usr/bin/env bash
set -euo pipefail

## Resolve repository root.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"

## Configuration files.
CHEZMOI_CONFIG="$REPO_ROOT/.ci/chezmoi.toml"
CHEZMOI_DATA="$REPO_ROOT/.ci/data.json"
SHELLCHECK_CONFIG="$REPO_ROOT/.shellcheckrc"

## Shell formatting configuration.
SHFMT_ARGS=(-i 2 -ci -sr)

## Files excluded from shfmt formatting checks.
## Paths are relative to the repository root.
FORMAT_IGNORE=(
  "home/dot_config/tmux-powerline/executable_config.sh"
)

## Temporary directory for rendered templates.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

## Verify prerequisites.
for cmd in chezmoi shfmt shellcheck; do
  if ! command -v "$cmd" > /dev/null 2>&1; then
    echo "ERROR: Required command not found: $cmd" >&2
    exit 1
  fi
done

## Verify configuration files.
for file in \
  "$CHEZMOI_CONFIG" \
  "$CHEZMOI_DATA" \
  "$SHELLCHECK_CONFIG"; do

  if [[ ! -f "$file" ]]; then
    echo "ERROR: Required file not found: $file" >&2
    exit 1
  fi
done

## Validation counters.
FORMAT_FAILURES=0
SHELLCHECK_FAILURES=0
RENDER_FAILURES=0
FILES_CHECKED=0

echo "Validating shell scripts"
echo

## Determine whether a file should skip formatting.
should_skip_formatting() {
  local filename="$1"
  local relative_path="${filename#"$REPO_ROOT"/}"
  local ignored

  for ignored in "${FORMAT_IGNORE[@]}"; do
    if [[ "$relative_path" == "$ignored" ]]; then
      return 0
    fi
  done

  return 1
}

## Validate an ordinary or rendered shell script.
validate_script() {
  local script="$1"
  local filename="$2"
  local relative_path="${filename#"$REPO_ROOT"/}"
  local failed=0

  echo "Checking: $relative_path"

  ## Formatting check.
  if should_skip_formatting "$filename"; then
    echo "SKIPPED: Formatting: $relative_path"
  else
    if ! shfmt "${SHFMT_ARGS[@]}" -d "$script"; then
      echo "FAILED: Formatting: $relative_path"
      FORMAT_FAILURES=$((FORMAT_FAILURES + 1))
      failed=1
    fi
  fi

  ## ShellCheck.
  if ! shellcheck --rcfile="$SHELLCHECK_CONFIG" "$script"; then
    echo "FAILED: ShellCheck: $relative_path"
    SHELLCHECK_FAILURES=$((SHELLCHECK_FAILURES + 1))
    failed=1
  fi

  FILES_CHECKED=$((FILES_CHECKED + 1))

  if [[ "$failed" -eq 0 ]]; then
    echo "OK: $relative_path"
  fi

  echo
}

## Validate ordinary shell scripts.
while IFS= read -r -d '' script; do
  validate_script "$script" "$script"

done < <(
  find "$REPO_ROOT" \
    -type d \( -name .git -o -name dist \) -prune -o \
    -type f -name '*.sh' -print0
)

## Render and validate shell script templates.
while IFS= read -r -d '' template; do
  relative_path="${template#"$REPO_ROOT"/}"

  ## Preserve original directory structure and .sh extension.
  rendered="$TMP_DIR/${relative_path%.tmpl}"

  mkdir -p "$(dirname "$rendered")"

  echo "Rendering: $relative_path"

  if ! chezmoi \
    --source "$REPO_ROOT" \
    --config "$CHEZMOI_CONFIG" \
    execute-template \
    --override-data-file "$CHEZMOI_DATA" \
    --file "$template" \
    > "$rendered"; then

    echo "FAILED: Template rendering: $relative_path"
    RENDER_FAILURES=$((RENDER_FAILURES + 1))
    echo
    continue
  fi

  validate_script "$rendered" "$template"

done < <(
  find "$REPO_ROOT" \
    -type d \( -name .git -o -name dist \) -prune -o \
    -type f -name '*.sh.tmpl' -print0
)

## Print validation summary.
echo "========================================"
echo "Shell validation summary"
echo "========================================"
echo "Files checked:        $FILES_CHECKED"
echo "Formatting failures:  $FORMAT_FAILURES"
echo "ShellCheck failures:  $SHELLCHECK_FAILURES"
echo "Rendering failures:   $RENDER_FAILURES"
echo "========================================"

if [[ "$FORMAT_FAILURES" -gt 0 ||
  "$SHELLCHECK_FAILURES" -gt 0 ||
  "$RENDER_FAILURES" -gt 0 ]]; then
  echo "Shell validation FAILED."
  exit 1
fi

echo "All shell scripts validated successfully."
