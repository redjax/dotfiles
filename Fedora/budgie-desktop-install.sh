#!/bin/bash

# Mode: uninstall
dnf copr disable alunux/budgie-desktop-git
dnf remove -y budgie-desktop

# Reset previous configuration. Only if Budgie already previously installed/uninstalled
# budgie-panel --reset --replace &
