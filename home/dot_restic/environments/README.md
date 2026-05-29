# Environments

`.env` files for `resticprofile`. In a `resticprofile` [`profiles.yaml`](https://creativeprojects.github.io/resticprofile/configuration/index.html), you can use the `env-file:` option to pass a path to a `.env` file, then use `{{ .Env.VAR_NAME }}` to load values from that file into the profile.

This can be useful for separating any sensitive information (infrastructure like remote hostnames, IP addresses, bucket URLs, etc) from the config file, making it safe to version control with git.

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

  ## Use a value from the .env file
  repository: "{{ .Env.RESTIC_REPOSITORY }}"
  password-file: "{{ .Env.RESTIC_PASSWORD_FILE }}"

...
```
