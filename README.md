# Dotfiles

My dotfiles, managed by [chezmoi](https://www.chezmoi.io). Despite the silly name, this tool makes managing dotfiles across platforms and machines easier :)

## Setup

- Install `chezmoi`
  - Install to `~/.local/bin`: `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin`
- Initialize `chezmoi`
  - If you cloned this repository, i.e. to `~/git/dotfiles`, initialize like:
    - `chezmoi init --source ~/git/dotfiles` (replace `~/git/dotfiles` with the path to this repository)
  - If you did not clone this repository, initialize like:
    - (HTTP) `chezmoi init https://github.com/redjax/dotfiles.git`
    - (SSH) `chezmoi init git@github.com:redjax/dotfiles.git`
- Check what changes `chezmoi` will make to your home directory with: `chezmoi diff`
- When you are comfortable with the changes, run `chezmoi apply -v`

## Usage

After installing `chezmoi` and initializing your home directory with `chezmoi apply -v`, you should no longer directly edit `chezmoi`-managed dotfiles. Instead, use the `chezmoi edit $FILE` command. For example, to edit your `~/.bashrc`, run `chezmoi edit ~/.bashrc`.

You can do a "dry run" of the `chezmoi apply` command to see everything that would change before actually applying those changes. Use the command `chezmoi apply --dry-run --verbose
` to do a dry run.

Sometimes a program will either automatically append lines to your `~/.bashrc`, or will suggest you do so and provide commands you can copy/paste to automatically add the required init lines. This will cause conflicts with your `chezmoi`-managed version of the file. To fix this, use the `chezmoi merge $FILE` command, i.e. `chezmoi merge ~/.bashrc`. This will open a merge tool (`vimdiff` by default), where you can compare the changes and automatically add them to your `chezmoi` template file (`dot_filename.tmpl`).

After making a change to the `chezmoi` repository, follow these steps to commit them (note: you can add individual files with `git add $filename` instead of adding all changes with `git add *`):

```bash
chezmoi cd
git add *
git commit -m "Update bashrc template with merged changes"
git push origin main
```

## Links

- [Chezmoi home](https://www.chezmoi.io)
- [Chezmoi Github](https://github.com/twpayne/chezmoi)
- [Chezmoi docs: quickstart](https://www.chezmoi.io/quick-start/)
- [Chezmoi docs: user guide](https://www.chezmoi.io/user-guide/command-overview/)
