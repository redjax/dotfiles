# Home <!-- omit in toc -->

My dotfiles! The files in this path are rendered when `chezmoi apply` is run. Directories and files that start with `dot_` will be renamed `.<file-or-dir-name>` when rendered. Scripts that begin with `executable_` will be converted to executable scripts, as if `chmod +x script_name.sh` had been run.

## Table of Contents <!-- omit in toc -->

- [Configs](#configs)

## Configs

> [!WARNING]
> This table may not be entirely up to date.
> You can explore the files & directories in this `home/` path to see the dotfiles
> that will be generated with `chezmoi apply`.

| Config                                             | Rendered              | Notes                                                                                                                                          |
| -------------------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [`dot_bash_loader/`](./dot_bash_loader/)           | `~/.bash_loader/`     | A shell module sourced by my `~/.bashrc`, which extends my Bash profile.                                                                       |
| [`dot_chezmoi_scripts/`](./dot_chezmoi_scripts/)   | `~/.chezmoi_scripts/` | Shared scripts & files to extend `chezmoi` functionality. Includes install scripts, utilities, & more.                                         |
| [`dot_config/`](./dot_config/)                     | `~/.config/`          | Many Linux apps look to `~/.config` for their configurations. Merges my `chezmoi`-managed configs with existing files at `~/.config`.          |
| [`dot_oh-my-zsh/`](./dot_oh-my-zsh/)               | `~/.oh-my-zssh/`      | My [`oh-my-zsh` configuration](https://ohmyz.sh)                                                                                               |
| [`dot_zsh/`](./dot_zsh/)                           | `~/.zsh`              | Modular configuration for the `zsh` shell.                                                                                                     |
| [`dot_chezmoi.toml`](./dot_chezmoi.toml)           | `~/dot_chezmoi.toml`  | Initialized `chezmoi` configuration. User answers prompt first time `chezmoi init` command is run, and that configuration is stored & re-used. |
| [`dot_bash_aliases.tmpl`](./dot_bash_aliases.tmpl) | `~/.bash_aliases`     | My Bash aliases.                                                                                                                               |
| [`dot_bashrc.tmpl`](./dot_bashrc.tmpl)             | `~/.bashrc`           | My main Bash configuration. Dynamically loads configuration.                                                                                   |
| [`dot_gitconfig.tmpl`](./dot_gitconfig.tmpl)       | `~/.gitconfig`        | Stores global git configuration.                                                                                                               |
| [`dot_profile.toml`](./dot_profile.tmpl)           | `~/.profile`          | Sources my `~/.bashrc` & appends to `$PATH`.                                                                                                   |
| [`dot_zshrc.tmpl`](./dot_zshrc.tmpl)               | `~/.zshrc`            | My ZSH config entrypoint.                                                                                                                      |
