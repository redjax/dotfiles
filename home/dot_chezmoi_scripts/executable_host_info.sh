#!/bin/bash

## Path to this script's parent dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## Arg default values
DEBUG=0

## Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug|-D)
            DEBUG=1
            ;;

        ## catch-all for unknown options
        --*)
            echo "Warning: Unknown option $1"
            ;;
        ## Unmatched/unhandled
        *)
            ## Handle positional args
            #  You have to implement this based on the needs of the current script
            ;;
    esac
    shift
done

function Debug() {
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] $1"
    fi
}

Debug "Script dir: $SCRIPT_DIR"

## Path to script utils
UTILS_DIR="${SCRIPT_DIR}/utils"
Debug "Utils dir: $UTILS_DIR"

## Import utils
source "${UTILS_DIR}/init.sh"

## Get OS
OS=$(get_os)
## Get CPU architecture
ARCH=$(get_cpu_arch)
## Get distro
DISTRO=$(detect_distro)
## Package manager based on distro
PKG_MANAGER=$(detect_pkg_manager)

Debug "

  [ Host Info ]
Hostname: $HOSTNAME
OS: $OS
Arch: $ARCH
Distro: $DISTRO
Package Manager: $PKG_MANAGER
"
