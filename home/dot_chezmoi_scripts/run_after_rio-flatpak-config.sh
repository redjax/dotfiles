#!/bin/bash

## Detect if flatpak is installed
if command -v flatpak &>/dev/null; then

  ## Detect if Rio is installed as a flatpak
  if flatpak info com.rioterm.Rio &>/dev/null; then
    echo "Running Rio Flatpak config copy script..."
    
    SRC="$HOME/.config/rio"
    DEST="$HOME/.var/app/com.rioterm.Rio/config/rio"

    if [ -d "$SRC" ]; then
      mkdir -p "$DEST"

      if [[ -d "$DEST/" ]]; then
        rm -r "$DEST/"
      fi

      cp -a "$SRC/." "$DEST/"
      echo "Copied Rio config from '$SRC' to '$DEST'"
    else
      echo "No config found at '$SRC'."
    fi

  else
    echo "Rio Flatpak is not installed."
  fi

else
  echo "Flatpak is not installed."
fi

