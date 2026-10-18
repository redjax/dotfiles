#!/usr/bin/env bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${THIS_DIR}/../.." && pwd)"

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Render the chezmoi source and run ShellCheck against the rendered files.

Options:
  --severity, -s LEVEL   Minimum severity: error, warning, info, style
                         Default: warning
  --use-rc               Use .shellcheckrc from the repository
  --keep                 Keep the rendered files after the scan
  --help, -h             Show this help
EOF
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "${command_name} is not installed."
    return 1
  fi
}

find_shell_scripts() {
  local search_path="${1:-$REPO_ROOT}"

  {
    find "$search_path" -type f \( \
      -name '*.sh' -o \
      -name '*.bash' -o \
      -name '*.zsh' -o \
      -name '*.ksh' \
      -o -name '*.sh.tmpl' \
      -o -name '*.bash.tmpl' \
      -o -name '*.zsh.tmpl' \
      -o -name '*.ksh.tmpl' \
      \)

    find "$search_path" -type f \( \
      -name '.bashrc' -o \
      -name '.bash_profile' -o \
      -name '.bash_login' -o \
      -name '.bash_logout' -o \
      -name '.bash_aliases' \
      -o -name '.zshrc' \
      -o -name '.zprofile' \
      -o -name '.zlogin' \
      -o -name '.zlogout' \
      -o -name '.zshenv' \
      -o -name '.profile' \
      \)

    find "$search_path" -type f -executable -exec sh -c '
            for file do
                if head -n1 "$file" 2>/dev/null | grep -q "^#!.*sh"; then
                    echo "$file"
                fi
            done
        ' sh {} +
  } | sort -u
}

render_chezmoi() {
  local output_dir="$1"
  local archive="${output_dir}.tar"

  mkdir -p "$output_dir"

  export CHEZMOI_DATA_custom_hostname="shellcheck-scan"

  echo "Rendering chezmoi source..."
  chezmoi archive \
    --output="$archive" \
    --source="$REPO_ROOT"

  tar -xf "$archive" -C "$output_dir"
  rm -f "$archive"

  if ! find "$output_dir" -type f -print -quit | grep -q .; then
    echo "Rendered archive is empty."
    return 1
  fi

  echo "Rendered files: $(find "$output_dir" -type f | wc -l)"
}

run_shellcheck() {
  local rendered_dir="$1"
  local severity="$2"
  local use_rc_file="$3"

  local rc_file="${REPO_ROOT}/.shellcheckrc"
  local scripts
  local shellcheck_args=(
    "--severity=${severity}"
    "--color=auto"
  )

  if [[ "$use_rc_file" == "true" && -f "$rc_file" ]]; then
    cp "$rc_file" "${rendered_dir}/.shellcheckrc"
    echo "Using ShellCheck configuration: ${rc_file}"
  else
    shellcheck_args+=("--norc")
    echo "Not using .shellcheckrc."
  fi

  mapfile -t scripts < <(find_shell_scripts "$rendered_dir")

  if [[ ${#scripts[@]} -eq 0 ]]; then
    echo "No shell scripts found in rendered output."
    return 0
  fi

  echo "Found ${#scripts[@]} shell script(s) in rendered output."
  echo "Minimum severity: ${severity}"

  shellcheck "${shellcheck_args[@]}" "${scripts[@]}"
}

main() {
  local severity="warning"
  local use_rc_file="false"
  local keep_rendered="false"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --severity | -s)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1."
        usage
        return 1
      fi
      severity="$2"
      shift 2
      ;;
    --use-rc)
      use_rc_file="true"
      shift
      ;;
    --keep)
      keep_rendered="true"
      shift
      ;;
    --help | -h)
      usage
      return 0
      ;;
    *)
      echo "Unknown option: $1."
      usage
      return 1
      ;;
    esac
  done

  echo "ShellCheck rendered scan"
  echo "Repository: ${REPO_ROOT}"

  require_command shellcheck
  require_command chezmoi

  local rendered_dir
  rendered_dir="$(mktemp -d "${TMPDIR:-/tmp}/chezmoi-shellcheck.XXXXXX")"

  if [[ "$keep_rendered" != "true" ]]; then
    trap 'rm -rf "$rendered_dir"' EXIT
  fi

  echo "Rendered output: ${rendered_dir}"

  render_chezmoi "$rendered_dir"
  run_shellcheck "$rendered_dir" "$severity" "$use_rc_file"

  echo "ShellCheck passed."
}

main "$@"
