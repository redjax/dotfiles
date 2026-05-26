# Kitty Terminal

- [Homepage](https://sw.kovidgoyal.net/kitty/)
- [Github](https://github.com/kovidgoyal/kitty)
- [Docs](https://sw.kovidgoyal.net/kitty/quickstart/)

## Troubleshooting

### Fix 'terminal is not fully functional'

When using Kitty, if you SSH to a remote machine you may see a message like this when running commands:

```shell
git branch
WARNING: terminal is not fully functional
Press RETURN to continue
```

The easiest way to fix this is to install the `kitty-terminfo` package on the remote host. You can also use the `ssh` kitten, which automatically copies the needed terminfo on the remote server on the first connection:

```shell
kitty +kitten ssh user@remotehost
```

