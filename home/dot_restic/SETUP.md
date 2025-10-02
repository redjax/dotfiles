# Setup Guide

My checklist for setting up restic, rclone, and resticprofile. Check the [Commands Only](#commands-only) for copy/paste-able commands

## Guide

Run `. ~/.restic/scripts/install_restic.sh`
	- Answer `y` for `rclone` and `resticprofile` install
- Copy the default profile to `~/profiles.yaml`:
	- `cp ~/.restic/resticprofile/profiles/default.yaml ~/profiles.yaml`
- Generate resticprofile keys with:
	- "Main" key: `. ~/.restic/scripts/apps/resticprofile/generate-key.sh -o ~/.restic/passwords/main`
	- "User" key: `. ~/.restic/scripts/apps/resticprofile/generate-key.sh -o ~/.restic/passwords/user`
	- Save these passwords somewhere secure!
- Edit the `~/profiles.yaml` file
	- Change the default `repository:` if you want to use a different path.
		- Note this path must exist ahead of time, create with `sudo mkdir -p /opt/restic/repo`.
	- Set the default key to `/home/$USER/.restic/passwords/main`
		- After initializing a repository, add your `user` key with `resticprofile -c ~/profiles.yaml` key add --new-password-file ~/.restic/passwords/user`
		- Then, update individual backup jobs/profiles to use this key, leaving the default as the `main` key.
		- You should delete the main key file as soon as possible and only create it temporarily to set up a new profile.
	- Create an ignore/excludes file at `~/.restic/ignores/<hostname>`
		- Add the path to the default `backup:  exclude-file:` line
- Initialize the repository/ies with `resticprofile -c ~/profiles.yaml init`
- Add the user key with `resticprofile -c ~/profiles.yaml key add --new-password-file ~/.restic/passwords/user`
	- Delete the `main` key after adding the 'user' key.
- Create the first backup with (use `sudo` if you need root access to any of the paths in the backup):
	- `resticprofile -c ~/profiles.yaml -n full-backup backup`
- Install the resticprofile schedules with:
	- `resticprofile -c ~/profiles.yaml schedule install --all`

### pCloud remote

> [!NOTE]
> This requires `rclone`

- On a machine with a GUI, install `rclone` and `rclone authorize pcloud`
	- Copy/paste the link into your browser and log in
	- Copy the token (the whole JSON string), you will paste it in the next step
- Back on your machine where you're setting up `resticprofile`, run `rclone config` to start a new configuration.
	- Choose `n` to create a new remote and name if `pcloud`
	- Find `'Pcloud` in the list and type the number to the left (`42` as of 2025-10-01)
	- Press `Enter` twice to skip past `client_id` and `client_secret`, then `y` to enter advanced config
	- Continue hitting `Enter` through the rest of the options until you're prompted to save the configuration
- Edit the `profiles.yaml` and add a backup for pCloud, i.e. your home directory:

```yaml
home_pcloud:
  inherit: default
  default-command: backup
  repository: "rclone:pcloud:backup/restic/hetzner-spooki-proxy"
  ## Replace this with a 'user' token after initializing the repo
  password-file: "/home/$USER/.restic/passwords/pcloud_main"

  ## Set path to rclone.conf so sudo resticprofile works
  env:
    RCLONE_CONFIG: "/home/$USER/.config/rclone/rclone.conf"

  backup:
    source: "/home/$USER"
    exclude-file:
      - "/home/.restic/ignores/default"
      - "/home/.restic/ignores/home"
    schedule-permission: "system"

  tags:
    - home
    - pcloud
```

- Initialize the backup repo with `resticprofile -c profiles.yaml -n pcloud init`
- Add your `pcloud_user` key with `resticprofile -c profiles.yaml key add --new-password-file ~/.restic/passwords/pcloud_user`
- Remove the `pcloud_main` key from the machine

### Setup SSH remote

- Create an SSH key for `resticprofile` to use with `ssh-keygen -t rsa -b 4096 -f ~/.ssh/resticprofile_id_rsa -N ""`
	- Omit `-N ""` if you want to add a password, or type the password between the quotes
	- You should use a better algorithm, like `-t ed25519 -f ~/.ssh/resticprofile_id_ed2519`
- Copy the key to your remote with `ssh-copy-id -i ~/.ssh/resticprofile_id_rsa.pub user@hostname-or-ip`.
	- If you can't use `ssh-copy-id`, you can also copy the contents of `~/.ssh/resticprofile_id_rsa.pub` (or whatever key name you used) into the remote server's `~/.ssh/authorized_keys`
- Edit your `~/.ssh/config` and add an entry for your remote, i.e.:

```plaintext
Host remote-hostname-or-ip
  HostName remote-hostname-or-ip
  User remote_username
  IdentityFile ~/.ssh/resticprofile_id_rsa

```

- Do an initial connection with `ssh remote-hostname-or-ip` to authorize the connection.
- If you are going to use `sudo` with your `resticprofile` commands, also create an entry for the same host in `/root/.ssh/config`
	- Instead of `~`, type out the full home path, i.e. `IdentityFile /home/username/.ssh/resticprofile_id_rsa`
- Add an SSH backup job:

```yaml
## other resticprofile config

remote_ssh:
  inherit: default
  default-command: backup
  repository: "sftp:remote-hostnamee-or-ip:/path/on/remote/to/restic/$HOSTNAME"  # replace with your hostname

  backup:
    source: "/home/$USER"
    exclude-file:
      - "/home/$USER/.restic/ignores/default"
      - "/home/$USER/.restic/ignores/home"
    schedule-permission: "system"

  tags:
    - home
    - userland
    - ssh
```

`source:` can also be a list of multiple directories to backup.

## Commands Only

```shell
. ~/.restic/scripts/install_restic.sh

cp ~/.restic/resticprofile/profiles/default.yaml ~/profiles.yaml

. ~/.restic/scripts/apps/resticprofile/generate-key.sh -o ~/.restic/passwords/main

. ~/.restic/scripts/apps/resticprofile/generate-key.sh -o ~/.restic/passwords/user
```

- Edit the `~/profiles.yaml` file.
  - (Optional) set a different path for `repository:` (default is /opt/restic/repo)
  - Either way, ensure it exists with:

```shell
sudo mkdir -pv /path/to/restic/repo && sudo chown -R $USER:$USER /path/to/restic/repo
```

- Set the path to your 'main' key in 'password-file:'
    - i.e. `password-file: "/home/$USER/.restic/passwords/main"`

- Create a host-specific ignores file with: 
```shell
touch ~/.restic/ignores/$(hostname)
```

- You can add host-specific ignores to this file and use it in one of the `exclude-file:` options

- Initialize the repositories with:
  
```shell
resticprofile -c ~/profiles.yaml init
```

- Add your user key with

```shell
resticprofile -c ~/profiles.yaml key add --new-password-file ~/.restic/passwords/user
```

- You can now delete the 'main' key: 

```shell
rm ~/.restic/passwords/main
```

- Schedule your backups with:

```shell
sudo resticprofile -c ~/profiles.yaml schedule install --all
```

- (Optional) Take a backup with:

```shell
resticprofile -c ~/profile.yaml -n full-backup backup
```
