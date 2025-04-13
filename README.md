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

## Links

- [Chezmoi home](https://www.chezmoi.io)
- [Chezmoi Github](https://github.com/twpayne/chezmoi)
- [Chezmoi docs: quickstart](https://www.chezmoi.io/quick-start/)
- [Chezmoi docs: user guide](https://www.chezmoi.io/user-guide/command-overview/)
