# .bash_loader <!-- omit in toc -->

The `.bash_loader/` module offloads a lot of customization into a directory at `~/.bash_loader`. This allows for easy attaching/detaching of functionality you may not want to share, or if a configuration is causing a problem and you don't have time to fix it.

In your `~/.bashrc` or `~/.bash_aliases`, add this line to source `~/.bash_loader/main`, which in turn sources each file in the `.bash_loader/` directory:

```plaintext
## Source ~/.bash_loader module
if [[ -f "~/.bash_loader/main" ]]; then
  . ~/.bash_loader/main
fi
```
