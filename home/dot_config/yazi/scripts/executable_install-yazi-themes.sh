#!/usr/bin/env bash

set -euo pipefail

declare -a THEMES=(
    ## Dark
    dangooddd/kanagawa                   # dark = "kanagawa"
    yazi-rs/flavors:catppuccin-macchiato # dark = "catppuccin-macchiato"
    yazi-rs/flavors:catppuccin-frappe    # dark = "catppuccin-frappe"
    yazi-rs/flavors:dracula              # dark = "dracula"
    bennyyip/gruvbox-dark                # dark = "gruvbox-dark"
    kmlupreti/ayu-dark

    ## Light
    yazi-rs/flavors:catppuccin-latte # light = "catppuccin-latte"
    muratoffalex/kanagawa-lotus      # light = "kanagawa-lotus"
)

if ! command -v ya; then
    if command -v yazi; then
        echo "[ERROR] yazi is installed, but 'ya' command not found."
    fi
fi

declare -a _errs=()

echo "Installing Yazi themes"
for theme in "${THEMES[@]}"; do
    echo ""
    echo "Installing theme: ${theme}"

    ya pkg add $theme
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to install theme '${theme}'."
        _errs+=$theme
        continue
    else
        echo "Theme '${theme}' installed"
    fi
done

echo ""
echo "Finished installing Yazi themes."
echo ""

if [[ "${#_errs[@]}" -gt 0 ]]; then
    echo "Failed on ${#_errs[@]} theme install(s):"

    for e in "${_errs[@]}"; do
        echo "  [FAILURE] $e"
    done
fi

exit 0
