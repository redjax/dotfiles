# Restic <!-- omit in toc -->

[Restic](https://restic.net) is a flexible & fast backup tool. It works with a repository system, storing differential snapshots of paths you add to the repository each time you run the backup command.

Restic is [scriptable](https://restic.readthedocs.io/en/latest/075_scripting.html), too, making it great for scheduled backups.

## Table of Contents <!-- omit in toc -->

- [Setup](#setup)
- [Managing encryptiong keys](#managing-encryptiong-keys)
- [Restic key command cheat sheet](#restic-key-command-cheat-sheet)
- [Links](#links)

## Setup

First, install Restic, either using the [official install docs](https://restic.readthedocs.io/en/latest/020_installation.html), or the included [`install_restic.sh` script](./scripts/executable_install_restic.sh).

To use this directory on a new machine, you have to do a bit of setup. There is an [init script](./scripts/executable_restic_init_local.sh) to guide you through initializing a local Restic repository, which accepts CLI args (run it with `-h/--help` to see usage) or prompts the user for missing inputs like a password.

> [!WARNING]
>
> When creating a repository with this script, the password is stored in a file in `~/.restic/passwords/`. This is not very secure, but is simple for local backups If your repository contains sensitive files, or you are running this in a production environment, use a stronger method.
>
> One better method is to use [encryption keys](#managing-encryptiong-keys)

## Creating backups

*[Restic backup docs](https://restic.readthedocs.io/en/stable/040_backup.html)*

After [setting up your Restic repository](#setup), you can create backups by running the `restic -r /repo/path backup [/path/to/backup]`. If you set a `RESTIC_REPOSITORY_FILE` or `RESTIC_REPOSITORY` environment variable, you do not need to pass the repository with `-r`, and if you set a `RESTIC_PASSWORD_FILE` or `RESTIC_PASSWORD_COMMAND`, you will not need to input your password.

You can add the `--verbose` flag to see more info.

You can add the `--skip-if-unchanged` flag to skip snapshotting if nothing in the source path has changed.

## Managing encryption keys

Restic uses [key-based encryption](https://restic.readthedocs.io/en/latest/070_encryption.html#manage-repository-keys), deriving new keys from the repository's master password with the `restic -r /repo/path key add` command.

It is good practice to keep your initial/"master" password backed up somewhere separate from the repository, and to use keys for repository access. That way, you can create a key for users to use, another for scripts to use, etc, and revoke keys as needed.

If you ever need to revoke a specific key/password, you can do so with `restic -r /repo/path key remove <keyID>`, where `<keyId>` is the shorthash/ID of one of the keys you see when you run `restic -r /repo/path key list`.

## Restic key command cheat sheet

> [!NOTE]
> All `restic key` commands require your master passsword. They do not make use of the `RESTIC_PASSWORD_FILE` env var.

| Command                                   | Description                                                                                                                                       |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `restic -r /repo/path key list`           | List repository key thumbprints.                                                                                                                  |
| `restic -r /repo/path cat masterkey`      | Show your master key (you will probably never need to do this).                                                                                   |
| `restic -r /repo/path key add             | Create a new repository key. Prompts for the master password first, then the new password. Useful for creating 'access keys' that you can revoke. |
| `restic -r /repo/path key remove <keyId>` | Remove a key by its ID/thumbprint. Uses `restic -r /repo/path key list` to see IDs.                                                               |

## Links

- [Restic home](https://restic.net)
- [Restic docs](https://restic.readthedocs.io)
  - [Restic installation docs](https://restic.readthedocs.io/en/latest/020_installation.html)
  - [Restic CLI reference](https://restic.readthedocs.io/en/latest/manual_rest.html)
  - [Prepare new Restic repository](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html)
  - [Backing up](https://restic.readthedocs.io/en/latest/040_backup.html)
  - [Restoring from backup](https://restic.readthedocs.io/en/latest/050_restore.html)
    - [Restore from snapshot](https://restic.readthedocs.io/en/latest/050_restore.html#restoring-from-a-snapshot)
    - [Restore to mount point](https://restic.readthedocs.io/en/latest/050_restore.html#restore-using-mount)
    - [Print files to stdout](https://restic.readthedocs.io/en/latest/050_restore.html#printing-files-to-stdout)
  - [Scripting restic](https://restic.readthedocs.io/en/latest/075_scripting.html)
- [Restic Github](https://github.com/restic/restic)
