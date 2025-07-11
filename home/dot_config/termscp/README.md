# TermSCP <!-- omit in toc -->

[termscp](https://termscp.veeso.dev) is a file transfer & explorer terminal user interface (TUI). It supports SCP, (S)FTP, Kube, S3, and WebDav.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Usage](#usage)
- [Connecting with args](#connecting-with-args)
  - [(S)FTP](#sftp)
  - [SCP](#scp)
  - [S3](#s3)
- [Bookmarks](#bookmarks)
- [Editing](#editing)
- [Links](#links)

## Usage

You can launch a new session by typing `termscp` in your terminal. You can also [use CLI args](#connecting-with-args) & create [session bookmarks](#bookmarks).

## Connecting with args

Termscp connection commands are in the following format: `termscp [protocol]://[username@]<address>[:port][/path/on/remote]`

### (S)FTP

SFTP is termscp's default connection type. If you do not specify a protocol, SFTP will be used. Replace `sftp` below with `ftp` for unencrypted connections.

- `termscp sftp://$username@$hostnameorip`
- Remote SSH running on port `2222`: `termscp sftp://$username@$hostnameorip:2222`
- Pass connection password: `termscp sftp://$username@$hostnameorip -P yourPassword`
  - It is more secure to load the password from a file, i.e. with `sshpass`: `sshpass -f /path/to/passwordfile termscp sftp://$username@$hostnameorip`
- Connect to a specific directory: `termscp sftp://$username@$hostnameorip/path/on/remote/machine`

### SCP

...

### S3

...

## Bookmarks

Bookmarks can be created during session startup, or by editing a file. You can connect using a saved bookmark by running `termscp -b bookmarkName` (where `bookmarkName` is the name you gave the bookmark).

- In the termscp TUI
  - At startup, you are prompted with a connection screen.
  - Fill in your connection details (host, port, username, password, remote path), then hit `CTRL+S` and follow the menu to save the bookmark.
- By editing the termscp bookmarks file (Linux: `~/.config/termscp/bookmarks.toml`, Windows: `$env:APPDATA\termscp\bookmarks.toml`)
  - Create bookmarks by adding `[bookmarks.<session-name>]` sections in the TOML.
  - If you want your bookmark to have spaces, you must quote the name, i.e. `[bookmarks."Session name with spaces"]`.
  - When you connect via bookmark, you will also need to quote the name.
  - Example `bookmarks.toml` with an FTP and SFTP connection named `demo` and `demo-secure`:

```toml
[bookmarks.demo]
protocol = "FTP"
address = "ftp.someId.example.com"
port = 21
username = "ftpuser"
## Password should be encrypted, which happens automatically if you save from the termscp UI.
#  Otherwise, leave empty when creating manually, enter in the TUI, and save/overwrite with the password.
password = ""

[bookmarks.demo]
protocol = "SFTP"
address = "ftp.someId.example.com"
port = 22
username = "ftpuser"
password = ""

```

## Editing

After connecting, press the `o` key to open a file in your default editor. This is defined in `~/.config/termscp/config.toml` (or `$env:APPDATA\termscp\config.toml` on Windows) in the `[user_interface]` section. Set the value of `text_editor` to the editor you want to use, i.e. `text_editor = "code"` or `text_editor = "/usr/local/bin/nvim`.

## Links

- [termscp homepage](https://termscp.veeso.dev)
- [termscp user manual](https://termscp.veeso.dev/user-manual.html)
- [termscp Github](https://github.com/veeso/termscp)
