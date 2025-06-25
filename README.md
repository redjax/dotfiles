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
  <a href="https://github.com/redjax/dotfiles">
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

My dotfiles, managed by [chezmoi](https://www.chezmoi.io). While I am not a fan of its name, this tool simplifies managing Linux/Mac dotfiles across multiple machines much easier.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Synchronizing Changes](#synchronizing-changes)
  - [Cheat-Sheet](#cheat-sheet)
- [Links](#links)

## Quick Start

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

Now that your dotfiles are managed by `chezmoi`, you do not (read: *should* not) manually edit these files. If you want to make a change, use `chezmoi edit $FILE` if the file is managed by `chezmoi`. For example, to make a change to your `~/.bashrc`, run `chezmoi edit ~/.bashrc`.

If you do make manual changes (either out of habit, or installing a program/running an Ansible script that edits a file managed by `chezmoi`), you can run `chezmoi merge $FILE` and manually merge those changes into the `chezmoi` template/file.

Any time you make changes to your `chezmoi` repository, you should also [synchronize the changes](#synchronizing-changes).

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
