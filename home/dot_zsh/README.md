# ZSH <!-- omit in toc -->

My `zsh` configs.

## Table of Contents <!-- omit in toc -->

- [Usage](#usage)
- [The Configurations](#the-configurations)
- [Oh-My-ZSH](#oh-my-zsh)
- [Notes](#notes)
- [Links](#links)

## Usage

The [`.zshrc` template](../dot_zshrc.tmpl) imports configurations from this path. The order of sourcing does matter!

After applying this configuration with `chezmoi apply`, change your shell with:

```bash
chsh -s $(which zsh)
```

To revert back to Bash, re-run the `chsh` command, but use `bash` instead of `zsh`.

## The Configurations

The following files are composed by `~/.zshrc` to define the shell's functionality.

| Config                                            | Purpose                                                                                                                |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| [`_early.zsh`](./_early.zsh.tmpl)                 | Code that should be loaded very early on in the `.zshrc` init. Provides functions like `dedup_path` and `add_to_path`. |
| [`aliases.zsh`](./aliases.zsh.tmpl)               | Provides alias definitions.                                                                                            |
| [`env.zsh`](./env.zsh.tmpl)                       | Set environment variables & locale.                                                                                    |
| [`functions.zsh`](./functions.zsh.tmpl)           | Provide functions to the shell.                                                                                        |
| [`git.zsh`](./git.zsh.tmpl)                       | Configures git for `zsh` prompt.                                                                                       |
| [`history.zsh`](./history.zsh.tmpl)               | Configures the `~/.zsh_history` settings.                                                                              |
| [`oh-my-zsh.zsh`](./oh-my-zsh.zsh.tmpl)           | If [oh-my-zsh](https://ohmyz.sh) is installed, source & configure it.                                                  |
| [`plugins.zsh`](./plugins.zsh.tmpl)               | Define plugin imports for `zsh`.                                                                                       |
| [`profile.zsh`](./profile.zsh.tmpl)               | Configure profile, which defines shell behavior for local sessions.                                                    |
| [`prompt.zsh`](./prompt.zsh.tmpl)                 | Set the `zsh` `$PROMPT`                                                                                                |
| [`software_inits.zsh`](./software_inits.zsh.tmpl) | Dynamically configure extra software like `homebrew` and `chezmoi`.                                                    |

## Oh-My-ZSH

The configuration should work fine without adding [oh-my-zsh](https://ohmyz.sh), but if you [install it](https://github.com/ohmyzsh/ohmyzsh#basic-installation), the [`.zshrc`](../dot_zshrc.tmpl) will source it.

For more information on setting up & using oh-my-zsh, [browse their wiki](https://github.com/ohmyzsh/ohmyzsh/wiki).

## Notes

...

## Links

- [oh-my-zsh home](https://ohmyz.sh)
- [oh-my-zsh Github](https://github.com/ohmyzsh/ohmyzsh)
  - [oh-my-zsh install instructions](https://github.com/ohmyzsh/ohmyzsh#basic-installation)
  - [oh-my-zsh cheatsheet](https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet)
  - [oh-my-zsh wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
  - [oh-my-zsh themes](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
  - [oh-my-zsh plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
