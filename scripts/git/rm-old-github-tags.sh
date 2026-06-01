#!/usr/bin/env bash

set -euo pipefail

function usage() {
    cat <<EOF
Usage:

  ${0} [OPTIONS]

Options:
  -h, --help            Show this help menu.
  --keep-latest <INT>   Keep only the latest N releases.
  --older-than <STR>    Keep only releases newer than given date (YYYY-MM-DD).
  --dry-run             Show what would be deleted without deleting anything.

Examples:

  rm-old-github-tags.sh --keep-latest 10
  rm-old-github-tags.sh --keep-latest 10 --dry-run

  rm-old-github-tags.sh --older-than 2025-01-01
  rm-old-github-tags.sh --older-than 2025-01-01 --dry-run

Requirements:

  * gh CLI
  * jq
  * authenticated GitHub session
EOF
}

KEEP_LATEST=""
OLDER_THAN=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case "$1" in
    --keep-latest)
        KEEP_LATEST="$2"
        shift 2
        ;;
    --older-than)
        OLDER_THAN="$2"
        shift 2
        ;;
    --dry-run)
        DRY_RUN=true
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        echo "ERROR: Unknown option: $1"
        usage
        exit 1
        ;;
    esac
done

if [[ -n "$KEEP_LATEST" && -n "$OLDER_THAN" ]]; then
    echo "ERROR: --keep-latest and --older-than are mutually exclusive"
    exit 1
fi

if [[ -z "$KEEP_LATEST" && -z "$OLDER_THAN" ]]; then
    echo "ERROR: one cleanup mode must be specified"
    usage
    exit 1
fi

function delete_release() {
    local tag="$1"

    if $DRY_RUN; then
        echo "[DRY RUN] Would delete release and tag: $tag"
        return
    fi

    echo "Deleting release: $tag"
    gh release delete "$tag" --yes

    echo "Deleting tag: $tag"
    git push origin ":refs/tags/$tag"
}

if [[ -n "$KEEP_LATEST" ]]; then
    mapfile -t TAGS < <(
        gh release list \
            --limit 1000 \
            --json tagName \
            --jq '.[].tagName'
    )

    COUNT="${#TAGS[@]}"

    if ((COUNT <= KEEP_LATEST)); then
        echo "Nothing to delete."
        exit 0
    fi

    for ((i = KEEP_LATEST; i < COUNT; i++)); do
        delete_release "${TAGS[$i]}"
    done
fi

if [[ -n "$OLDER_THAN" ]]; then
    CUTOFF=$(date -u -d "$OLDER_THAN" +%s)

    gh release list \
        --limit 1000 \
        --json tagName,createdAt |
        jq -r '.[] | "\(.tagName)|\(.createdAt)"' |
        while IFS="|" read -r TAG CREATED; do
            CREATED_TS=$(date -d "$CREATED" +%s)

            if ((CREATED_TS < CUTOFF)); then
                delete_release "$TAG"
            fi
        done
fi
