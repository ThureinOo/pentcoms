# Senshu

A fast, filterable pentest cheat sheet built with Jekyll. 111 entries covering recon, exploitation, post-exploitation, and privilege escalation across Windows, Linux, macOS, and Active Directory.

**Live site:** https://thureinoo.github.io/senshu

## Features

- **Line-level search** — filters command output to matching lines only
- **Dynamic filters** — Phase, Target OS, Service, and Technique
- **Technique grouping** — Web → Windows → Linux → macOS → Active Directory
- **Sort** — A→Z or Z→A
- **Dark mode**
- **Per-entry pages** — click any title for the full card with all context

## Local Development

**Prerequisites:** Ruby + Bundler

```bash
gem install bundler
bundle install
bundle exec jekyll serve --livereload
```

Then open `http://localhost:4000/senshu`.

## Adding an Entry

Create a new `.md` file in `_senshu/`. Entries support two formats:

**Single command block:**

```yaml
---
description: |
  Short description of what this does.
command: |
  tool --flag target
items:
  - Shell # what you need to run this
phase:
  - PrivEsc
target_os:
  - Linux
services:
  - SSH
techniques:
  - Perm_Abuse
references:
  - https://example.com
---
```

**Multi-section (different commands depending on what you have):**

```yaml
---
description: |
  Short description.
commands:
  - have: Credentials
    cmd: |
      tool -u user -p pass target
  - have: Shell
    cmd: |
      local-tool target
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - Credential_Theft
references: []
---
```

Valid values for each field are defined in `_data/`:

| Field        | Source file            |
| ------------ | ---------------------- |
| `phase`      | `_data/phases.yml`     |
| `target_os`  | `_data/target_os.yml`  |
| `services`   | `_data/services.yml`   |
| `techniques` | `_data/techniques.yml` |
| `items`      | `_data/items.yml`      |

## Structure

```
_senshu/          # entry markdown files (111 entries)
_data/            # filter value definitions
_includes/        # bin_table.html (main UI), page_title.html
_layouts/         # bin.html (per-entry layout), default.html
assets/           # style.scss, styleDark.scss
```
