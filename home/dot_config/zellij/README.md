# Zellij <!-- omit in toc -->

Config & install scripts for the [Zellij multiplexer](https://zellij.dev).

## Table of Contents <!-- omit in toc -->

- [Usage](#usage)
  - [Layouts](#layouts)
  - [Launch Script](#launch-script)
    - [Launch with args](#launch-with-args)
    - [Launch with hardcoded session \& layout](#launch-with-hardcoded-session--layout)
- [Themes](#themes)
- [Links](#links)

## Usage

Run the [Zellij install script](./scripts/executable_install_zellij.sh) on Linux or Mac to install Zellij.

### Layouts

[Layouts](https://zellij.dev/documentation/layouts.html) are files that define a Zellij layout of panes and tabs. You can do a lot with layouts, like execute scripts or commands in a window at startup, create customized splits, & more.

For example, this layout creates 4 panes and runs commands in each of them. Some will drop the user back into a Bash prompt when they exit, and some will require the user to hit Enter to run them:

```kdl
//
// This is an example of a local Zellij layout.
//
// Local layouts are not synchronized with the git repository, so they can be specific to the local machine.
// For example, if you frequently open a set of panes for development in a specific directory, make it a layout!

layout {
    // The top bar with session name
    pane size=1 borderless=true {
        plugin location="tab-bar"
    }

    // The content panes.
    // This example shows a 4-pane split, with 2 horizontal & 2 vertical

    // v-split 1
    pane split_direction="vertical" {
        pane {
            name "top-left"
            // Cursor will start in this pane
            focus true
            // Run 'ls' when this layout is loaded
            command "ls"
            // Pass args to the command
            args "-l" "-a"
            // Set the working directory for this pane
            cwd "~/.config/zellij"
        }

        pane {
            name "top-right"
            command "ping"
            args "www.google.com"
            // Start the pane suspended, prompting user to start the command
            start_suspended true
        }
    }

    // v-split2
    pane split_direction="vertical" {
        pane {
            name "bottom-left"
        }

        pane {
            name "bottom-right"
            // Open a file in the default editor
            edit "~/.config/zellij/config.kdl"
        }
    }

    // The bottom bar with commands
    pane size=1 borderless=true {
        plugin location="status-bar"
    }
}

```

### Launch Script

You can create launch scripts that call Zellij [layouts](#layouts). There are 2 scripts in this Zellij configuration, an example/generic one where you have to pass a `-s/--session-name` and `-l/--layout-file`, and one where you define the session name and layout file in the script.

#### Launch with args

```bash
#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 -s <session_name> -l <layout_file>

Options:
  -s, --session-name  Name of the zellij session
  -l, --layout-file   Path to zellij layout file (.kdl)
  -h, --help          Show this help message
EOF
  exit 1
}

SESSION_NAME=""
LAYOUT_FILE=""

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--session-name)
      SESSION_NAME="$2"
      shift 2
      ;;
    -l|--layout-file)
      LAYOUT_FILE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      usage
      ;;
  esac
done

# Validate args
if [[ -z "$SESSION_NAME" ]] || [[ -z "$LAYOUT_FILE" ]]; then
  echo "[ERROR] Both --session-name and --layout-file are required."
  usage
fi

if ! command -v zellij &>/dev/null; then
  echo "[ERROR] Zellij is not installed."
  exit 1
fi

if [[ ! -f "$LAYOUT_FILE" ]]; then
  echo "[ERROR] Could not find Zellij layout file at path: $LAYOUT_FILE"
  exit 1
fi

# Return clean list of session names
get_sessions() {
  if zellij list-sessions --no-formatting --short 2>/dev/null; then
    return 0
  fi
  zellij list-sessions \
    | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' \
    | sed -E 's/[[:space:]]*\[.*$//' \
    | sed -E 's/[[:space:]]*\(EXITED.*$//' \
    | sed -E '/^No active zellij sessions found\.$/d'
}

SESSIONS="$(get_sessions || true)"

echo "Existing zellij sessions:"
printf '%s\n' "$SESSIONS"

if printf '%s\n' "$SESSIONS" | grep -Fxq "$SESSION_NAME"; then
  echo "Session $SESSION_NAME exists. Attaching..."
  exec zellij attach "$SESSION_NAME"
else
  echo "Session $SESSION_NAME does not exist. Creating new with layout..."
  exec zellij --new-session-with-layout "$LAYOUT_FILE" -s "$SESSION_NAME"
fi

```

#### Launch with hardcoded session & layout

```bash
#!/usr/bin/env bash

##############################################
# This is an example script. You can copy it #
# to a location on your machine, set the     #
# LAYOUT_FILE and SESSION_NAME,              #
# and call it with . path/to/launch.sh       #
##############################################

set -euo pipefail

if ! command -v zellij &>/dev/null; then
  echo "[ERROR] Zellij is not installed."
  exit 1
fi

LAYOUT_FILE="$HOME/.config/zellij/layouts/local/YOUR_TEMPLATE.kdl"
SESSION_NAME="YOURSESSION"

if [[ ! -f "$LAYOUT_FILE" ]]; then
  echo "[ERROR] Could not find Zellij layout file at path: $LAYOUT_FILE"
  exit 1
fi

# Return a machine-parseable list of session names (one per line, no colors/extra text)
get_sessions() {
  # Preferred: plain names without formatting (supported in recent Zellij)
  if zellij list-sessions --no-formatting --short 2>/dev/null; then
    return 0
  fi
  # Fallback: strip ANSI escape sequences and trailing decorations like [Created ...] or (EXITED ...)
  zellij list-sessions \
    | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' \
    | sed -E 's/[[:space:]]*\[.*$//' \
    | sed -E 's/[[:space:]]*\(EXITED.*$//' \
    | sed -E '/^No active zellij sessions found\.$/d'
}

SESSIONS="$(get_sessions || true)"

echo "Existing zellij sessions:"
printf '%s\n' "$SESSIONS"

if printf '%s\n' "$SESSIONS" | grep -Fxq "$SESSION_NAME"; then
  echo "Session $SESSION_NAME exists. Attaching..."
  exec zellij attach "$SESSION_NAME"
else
  echo "Session $SESSION_NAME does not exist. Creating new with layout..."
  exec zellij --new-session-with-layout "$LAYOUT_FILE" -s "$SESSION_NAME"
fi

```

## Themes

Download & install theme `.kdl` files into the [`themes/` directory](./themes/) to make them available to Zellij.

Zellij also has the following themes included by default:

- `ansi`
- `ao`
- `atelier-sulphurpool`
- `ayu_mirage`
- `ayu_dark`
- `catppuccin-frappe`
- `catppuccin-macchiato`
- `cyber-noir`
- `blade-runner`
- `retro-wave`
- `dracula`
- `everforest-dark`
- `gruvbox-dark`
- `iceberg-dark`
- `kanagawa`
- `lucario`
- `menace`
- `molokai-dark`
- `night-owl`
- `nightfox`
- `nord`
- `one-half-dark`
- `onedark`
- `solarized-dark`
- `tokyo-night-dark`
- `tokyo-night-storm`
- `tokyo-night`
- `vesper`
- `ayu_light`
- `catppuccin-latte`
- `everforest-light`
- `gruvbox-light`
- `iceberg-light`
- `dayfox`
- `pencil-light`
- `solarized-light`
- `tokyo-night-light`

## Links

- [Zellij home](https://zellij.dev)
- [Zellij Github](https://github.com/zellij-org/zellij)
- [Zellij docs](https://zellij.dev/documentation)
  - [Zellij install docs](https://zellij.dev/documentation/installation.html)
  - [Zellij config docs](https://zellij.dev/documentation/configuration.html)
  - [Zellij commands docs](https://zellij.dev/documentation/commands.html)
  - [Zellij layouts docs](https://zellij.dev/documentation/layouts.html)
    - [Creating a layout](https://zellij.dev/documentation/creating-a-layout.html)
    - [Swap layouts](https://zellij.dev/documentation/swap-layouts.html)
    - [Including configuration in layouts](https://zellij.dev/documentation/layouts-with-config.html)
- [Awesome Zellij (awesomelist)](https://github.com/zellij-org/awesome-zellij)
  - [Plugins](https://github.com/zellij-org/awesome-zellij#plugins)
  - [Integrations](https://github.com/zellij-org/awesome-zellij#integrations)
