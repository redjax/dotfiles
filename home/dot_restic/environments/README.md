# Environments

`.env` files for `resticprofile`. In a `resticprofile` [`profiles.yaml`](https://creativeprojects.github.io/resticprofile/configuration/index.html), you can use the `env-file:` option to pass a path to a `.env` file, then use `{{ .Env.VAR_NAME }}` to load values from that file into the profile.

This can be useful for separating any sensitive information (infrastructure like remote hostnames, IP addresses, bucket URLs, etc) from the config file, making it safe to version control with git.

> [!WARNING]
> There are some values that must load before environment variables, like repository paths and `exclude-file` paths. You must set these manually.
> You can still use `resticprofile` env substitution for variables that already exist in your environment. For example, to use `$HOME`, you can
> type `{{ .Env.HOME }}`.

Example of using `env-file:`:

```yaml
# yaml-language-server: $schema=https://creativeprojects.github.io/resticprofile/jsonschema/config.json
---
version: "1"

global:
  default-command: backup
  initialize: false
  priority: low
  min-memory: 100

default:
  ## Load environment variables from a file
  env-file:
    - "/home/YOUR_USERNAME/.restic.env"

  backup:
    verbose: false
    repository: "/path/to/restic/repository"
    password-file: "/path/to/restic/main.key"

    source:
      ## Use a value loaded from the restic .env
      - "{{ .Env.BACKUP_PATH_1 }}"

...
```
