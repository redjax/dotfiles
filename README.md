# Dotfiles <!-- omit in toc -->

<!-- Repo image -->
<!-- <p align="center">
  <a href="https://github.com/redjax/dotfiles">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="#">
      <img src="#" height="100">
    </picture>
  </a>
</p> -->

<!-- Git badges -->
<p align="center">
  <a href="https://github.com/redjax/dotfiles/tree/ade1c5939e8b8507e34a7c14a5b1aaa1f726e3cb">
    <img alt="Created At" src="https://img.shields.io/github/created-at/redjax/dotfiles">
  </a>
  <a href="https://github.com/redjax/dotfiles/commit">
    <img alt="Last Commit" src="https://img.shields.io/github/last-commit/redjax/dotfiles">
  </a>
  <a href="https://github.com/redjax/dotfiles/commit">
    <img alt="Commits this year" src="https://img.shields.io/github/commit-activity/y/redjax/dotfiles">
  </a>
  <a href="https://github.com/redjax/dotfiles">
    <img alt="Repo size" src="https://img.shields.io/github/repo-size/redjax/dotfiles">
  </a>
  <!-- ![GitHub Latest Release](https://img.shields.io/github/release-date/redjax/dotfiles) -->
  <!-- ![GitHub commits since latest release](https://img.shields.io/github/commits-since/redjax/dotfiles/latest) -->
  <!-- ![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/redjax/dotfiles/tests.yml) -->
</p>

My dotfiles, currently managed by [chezmoi](https://www.chezmoi.io), which simplifies managing Linux/Mac dotfiles across multiple machines.

> [!TIP]
> This is a continuation of a dotfiles repository I originally hosted on Gitlab, [starting in 2016](https://github.com/redjax/dotfiles/commit/ade1c5939e8b8507e34a7c14a5b1aaa1f726e3cb). The original code is retained in [an archive branch](https://github.com/redjax/dotfiles/tree/archive/2025-06-24).

Files in the [`home/` directory](./home/) will be rendered with `chezmoi apply`. Chezmoi uses conventions like `dot_config`, which becomes `.config/`, and `executable_some-script-name.sh` to create a script named `some-script-name.sh` with `chmod +x` permissions.

## Table of Contents <!-- omit in toc -->

- [Quick Start](#quick-start)
  - [init-dotfiles.sh Quickstart script](#init-dotfilessh-quickstart-script)
  - [Quick Start Instructions](#quick-start-instructions)
- [Usage](#usage)
  - [Synchronizing Changes](#synchronizing-changes)
  - [Cheat-Sheet](#cheat-sheet)
- [Links](#links)

## Quick Start

> [!NOTE]
> Once your dotfiles are managed by `chezmoi`, you do not (read: *should* not) manually edit these files. If you want to make a change, use `chezmoi edit $FILE` if the file is managed by `chezmoi`. For example, to make a change to your `~/.bashrc`, run `chezmoi edit ~/.bashrc`.
>
> If you do make manual changes (either out of habit, or installing a program/running an Ansible script that edits a file managed by `chezmoi`), you can run `chezmoi merge $FILE` and manually merge those changes into the `chezmoi` template/file.
>
> Any time you make changes to your `chezmoi` repository, you should also [synchronize the changes](#synchronizing-changes).

### init-dotfiles.sh Quickstart script

If you are comfortable cURLing this script and executing it, you can run:

```shell
curl -LsSf https://raw.githubusercontent.com/redjax/dotfiles/refs/heads/feat/main/scripts/init-dotfiles.sh | bash -s -- --auto
```

Otherwise, copy and paste this script into `init-dotfiles.sh` and run `chmod +x init-dotfiles.sh && ./init-dotfiles.sh`. 

```shell
#!/usr/bin/env bash

set -uo pipefail

USE_HTTP=false
VERBOSE=false

if ! command -v curl &>/dev/null; then
    echo "[ERROR] curl is not installed"
    exit 1
fi

## Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
    -v | --verbose)
        VERBOSE=true
        shift
        ;;
    esac
done

echo "[ Setup Dotfiles ]"
echo ""

if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi"

    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to install chezmoi"
        exit 1
    fi

    export PATH="$PATH:$HOME/.local/bin"
fi

if [[ "$USE_HTTP" == "true" ]]; then
    dotfiles_url="https://github.com/redjax/dotfiles.git"
else
    dotfiles_url="git@github.com:redjax/dotfiles.git"
fi

echo "Using dotfiles URL: $dotfiles_url"
echo ""

chezmoi init redjax
if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed applying chezmoi dotfiles."
    exit 1
fi

echo ""
echo "Dotfiles initialized"
echo ""

echo "Running 'chezmoi apply' would do the following:"
echo ""
if [[ "$VERBOSE" == true ]]; then
    chezmoi apply --dry-run --verbose
else
    chezmoi apply --dry-run
fi

echo ""
echo "When you are ready to apply the dotfiles, just run 'chezmoi apply'. You can do a dry run by adding --dry-run to the command."
exit 0

```

### Quick Start Instructions

- Install `chezmoi`: `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin`
  - Run `exec $SHELL` after installing for the first time
- Initialize with this repository
  - `chezmoi init redjax`
    - `chezmoi` will automatically find `github.com/redjax/dotfiles`
    - If you used a name other than `dotfiles` for your repository, you can tell `chezmoi` the URL to the repository with:
      - (HTTP) `chezmoi init https://github.com/redjax/dotfiles.git`
      - (SSH) `chezmoi init git@github.com:redjax/dotfiles.git`
- Run `chezmoi diff` to see what `chezmoi apply` will change
- Do a dry run with: `chezmoi apply --dry-run --verbose`
- Let `chezmoi` take over by running: `chezmoi apply -v`
- Run `exec $SHELL` one last time to reload your shell with the current changes

## Usage

After installing `chezmoi` and initializing your home directory with `chezmoi apply -v`, you should no longer directly edit `chezmoi`-managed dotfiles. Instead, use the `chezmoi edit $FILE` command. For example, to edit your `~/.bashrc`, run `chezmoi edit ~/.bashrc`.

You can do a "dry run" of the `chezmoi apply` command to see everything that would change before actually applying those changes. Use the command: `chezmoi apply --dry-run --verbose` to do a dry run.

Sometimes a program will either automatically append lines to your `~/.bashrc`, or will suggest you do so and provide commands you can copy/paste to automatically add the required init lines. This will cause conflicts with your `chezmoi`-managed version of the file. To fix this, use the `chezmoi merge $FILE` command, i.e. `chezmoi merge ~/.bashrc`. This will open a merge tool (`vimdiff` by default), where you can compare the changes and automatically add them to your `chezmoi` template file (`dot_filename.tmpl`).

### Synchronizing Changes

After making a change to the `chezmoi` repository, follow these steps to commit them (note: you can add individual files with `git add $filename` instead of adding all changes with `git add *`):

```bash
chezmoi cd
git add *
git commit -m "Update bashrc template with merged changes"
git push origin main
```

### Cheat-Sheet

| Command                                                                 | Description                                                                                                                                           | Notes                                                                                                                                                                                                                                                              |
| ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin`           | Install `chezmoi` to `~/.local/bin`                                                                                                                   |                                                                                                                                                                                                                                                                    |
| `chezmoi update`                                                        | Pull latest changes from your repository and apply them.                                                                                              |                                                                                                                                                                                                                                                                    |
| `chezmoi cd`                                                            | Change directory to your `chezmoi` repository                                                                                                         |                                                                                                                                                                                                                                                                    |
| `chezmoi edit $FILE`                                                    | Edit a `chezmoi`-managed file                                                                                                                         | Add `--apply` to automatically run `chezmoi apply` when finished editing. Add `--watch` to automatically run `chezmoi apply` on every save                                                                                                                         |
| `chezmoi add $FILE`                                                     | Add an existing file to your `chezmoi` repository.                                                                                                    |                                                                                                                                                                                                                                                                    |
| `chezmoi re-add $FILE`                                                  | Re-add file to `chezmoi` repository after manually editing it at its location (i.e. instead of editing the file in the `chezmoi` repository).         |                                                                                                                                                                                                                                                                    |
| `chezmoi init https://github.com/$GITHUB_USERNAME/$REPOSITORY_NAME.git` | Clone a `chezmoi` repository via HTTP                                                                                                                 |                                                                                                                                                                                                                                                                    |
| `chezmoi init git@github.com:$GITHUB_USERNAME/$REPOSITORY_NAME.git`     | Clone a `chezmoi` repository via SSH                                                                                                                  |                                                                                                                                                                                                                                                                    |
| `chezmoi init $GITHUB_USERNAME`                                         | Searches a given user's public repos for one named `dotfiles` and assumes it's a `chezmoi` repository                                                 |                                                                                                                                                                                                                                                                    |
| `chezmoi diff`                                                          | See what changes will be made if you run `chezmoi apply`                                                                                              |                                                                                                                                                                                                                                                                    |
| `chezmoi apply`                                                         | Apply `chezmoi`-managed dotfiles.                                                                                                                     |                                                                                                                                                                                                                                                                    |
| `chezmoi merge $FILE`                                                   | Merge changes in source file with `chezmoi`-managed version. If merge cannot occur automatically, you will be able to edit the merge before applying. |                                                                                                                                                                                                                                                                    |
| `chezmoi git pull -- --autostash --rebase && chezmoi diff`              | Pull latest changes from repo & see what would change without actually applying the changes.                                                          | This runs git pull --autostash --rebase in your source directory and chezmoi diff then shows the difference between the target state computed from your source directory and the actual state.  If you're happy with the changes, then you can run `chezmoi apply` |
| `chezmoi data`                                                          | List all `chezmoi` variables & their values.                                                                                                          |                                                                                                                                                                                                                                                                    |

## Links

- [Chezmoi home](https://www.chezmoi.io)
- [Chezmoi Github](https://github.com/twpayne/chezmoi)
- [Chezmoi docs: quickstart](https://www.chezmoi.io/quick-start/)
- [Chezmoi docs: user guide](https://www.chezmoi.io/user-guide/command-overview/)
- [Chezmoi docs: usage instructions](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/)
- [Chezmoi docs: include files from elsewhere (3rd party sources, Github URLs, etc)](https://www.chezmoi.io/user-guide/include-files-from-elsewhere/#include-a-subdirectory-from-a-url)
