#!/usr/bin/env bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${THIS_DIR}/../.." && pwd)"

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Run ShellCheck against shell scripts in the repository.

Options:
  --exclude, -e CODES    Comma-separated ShellCheck codes to exclude
  --severity, -s LEVEL   Minimum severity: error, warning, info, style. Default: warning
  --no-rc                Ignore .shellcheckrc
  --help, -h             Show this help
EOF
}

require_shellcheck() {
  if ! command -v shellcheck >/dev/null 2>&1; then
    echo "ShellCheck is not installed."
    echo "Install ShellCheck and run this script again."
    return 1
  fi

  shellcheck --version | sed -n '2p'
}

find_shell_scripts() {
  local search_path="${1:-$REPO_ROOT}"

  {
    find "$search_path" -type f \( \
      -name '*.sh' -o \
      -name '*.bash' -o \
      -name '*.zsh' -o \
      -name '*.ksh' -o \
      -name '*.sh.tmpl' -o \
      -name '*.bash.tmpl' -o \
      -name '*.zsh.tmpl' -o \
      -name '*.ksh.tmpl' \
      \)

    find "$search_path" -type f \( \
      -name 'dot_bashrc*' -o \
      -name 'dot_bash_profile*' -o \
      -name 'dot_bash_login*' -o \
      -name 'dot_bash_logout*' -o \
      -name 'dot_bash_aliases*' -o \
      -name 'dot_zshrc*' -o \
      -name 'dot_zprofile*' -o \
      -name 'dot_zlogin*' -o \
      -name 'dot_zlogout*' -o \
      -name 'dot_zshenv*' -o \
      -name 'dot_profile*' \
      \)

    find "$search_path" -type f \
      \( -path '*/dot_bash_loader/*' -o -path '*/dot_zsh_loader/*' \) \
      -name '*.tmpl'

    find "$search_path" -type f -name 'executable_*' -exec sh -c '
            for file do
                case "$file" in
                    *.sh.tmpl|*.bash.tmpl|*.zsh.tmpl|*.ksh.tmpl)
                        echo "$file"
                        ;;
                    *.tmpl)
                        ;;
                    *)
                        if head -n1 "$file" 2>/dev/null | grep -q "^#!.*sh"; then
                            echo "$file"
                        fi
                        ;;
                esac
            done
        ' sh {} +
  } | sort -u
}

run_shellcheck() {
  local exclude_codes="${1:-}"
  local severity="${2:-warning}"
  local use_rc_file="${3:-true}"

  local rc_file="${REPO_ROOT}/.shellcheckrc"
  local scripts

  if [[ "$use_rc_file" == "true" && -f "$rc_file" ]]; then
    echo "Using ShellCheck configuration: ${rc_file}"
  elif [[ -n "$exclude_codes" ]]; then
    echo "Using ShellCheck exclusions: ${exclude_codes}"
  else
    echo "No ShellCheck configuration specified."
  fi

  mapfile -t scripts < <(find_shell_scripts "$REPO_ROOT")

  if [[ ${#scripts[@]} -eq 0 ]]; then
    echo "No shell scripts found."
    return 0
  fi

  echo "Found ${#scripts[@]} shell script(s)."
  echo "Minimum severity: ${severity}"

  local shellcheck_args=(
    "--severity=${severity}"
    "--color=auto"
  )

  if [[ "$use_rc_file" != "true" ]]; then
    shellcheck_args+=("--norc")
  fi

  if [[ -n "$exclude_codes" ]]; then
    shellcheck_args+=("--exclude=${exclude_codes}")
  fi

  shellcheck "${shellcheck_args[@]}" "${scripts[@]}"
}

main() {
  local exclude_codes=""
  local severity="warning"
  local use_rc_file="true"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --exclude | -e)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1."
        usage
        return 1
      fi
      exclude_codes="$2"
      use_rc_file="false"
      shift 2
      ;;
    --severity | -s)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1."
        usage
        return 1
      fi
      severity="$2"
      shift 2
      ;;
    --no-rc)
      use_rc_file="false"
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

  echo "ShellCheck scan"
  echo "Repository: ${REPO_ROOT}"

  require_shellcheck

  if run_shellcheck "$exclude_codes" "$severity" "$use_rc_file"; then
    echo "ShellCheck passed."
  else
    echo "ShellCheck failed."
    return 1
  fi
}

main "$@"
