# Wezterm Configuration <!-- omit in toc -->

<!-- Repo image -->
<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./.static/img/wezterm-icon-square.png">
    <img src="./.static/img/wezterm-icon-square.png" height="200">
  </picture>
</p>

My configuration for [Wezterm terminal emulator](https://wezterm.org).

## Table of Contents <!-- omit in toc -->

- [Install](#install)
  - [Windows](#windows)
  - [Linux](#linux)
- [Links](#links)

## Install

### Windows

- Install `wezterm` with `winget`, `scoop`, `choco`, etc.
  - Optionally, use the [Windows `wezterm` install script](../../dot_chezmoi_scripts/installers/wezterm/windows/install-wezterm.ps1)
- Copy or symlink the wezterm config file to `%USERPROFILE%\.config\wezterm`

### Linux

- Install `wezterm`
  - Your package repositories might have a wezterm package, or you can use the [Linux `install_wezterm.sh` script](../../dot_chezmoi_scripts/installers/wezterm/install_wezterm.sh).
- After installing `wezterm`, run the [`install_nerdfont.sh` script](../../dot_chezmoi_scripts/installers/wezterm/install_nerdfont.sh) to install the NerdFonts I use (Hack, FiraCode, FiraMono).

## Links

- [Wezterm home](https://wezterm.org)
- [Wezterm configuration docs](https://wezterm.org/config/files.html)
  - [Wezterm config Lua modules](https://wezterm.org/config/files.html#making-your-own-lua-modules)
  - [Wezterm list of config options](https://wezterm.org/config/lua/config/index.html)
- [Wezterm CLI reference](https://wezterm.org/cli/general.html)
