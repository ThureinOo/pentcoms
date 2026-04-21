---
layout: page
title: Contributing
---

## How to Contribute

PentComs is open source and community-driven. To add a new command:

### 1. Create a new file

Add a `.md` file in `_pentcoms/` named after the tool (e.g., `Impacket-PsExec.md`).

### 2. Use this YAML template

```yaml
---
description: |
  Brief description of what the tool/command does.

  Reference values:
    Target IP: 10.10.10.1
    Domain: test.local
    Username: john
    Password: password123
command: |
  your-command-here 10.10.10.1
phase:
  - Enumeration          # Recon, Scanning, Enumeration, Exploitation,
                         # Post-Exploitation, PrivEsc, Lateral_Movement,
                         # Persistence, Exfiltration
target_os:
  - Windows              # Linux, Windows, macOS
services:
  - SMB                  # SMB, HTTP, SSH, FTP, DNS, LDAP, Kerberos,
                         # RDP, WinRM, MSSQL, MySQL, SNMP, SMTP, RPC,
                         # NFS, WMI, DCOM, NTLM, VNC, Redis, PostgreSQL
ports:
  - "445"                # Always quote port numbers
items:
  - Username             # No_Creds, Username, Password, Hash, TGT, TGS,
  - Password             # Certificate, Shell, Key, Token, SPN
techniques:
  - Pass-the-Hash        # See _data/techniques.yml for full list
network_position:
  - Internal             # External, Internal, Local
references:
  - https://example.com
---
```

### 3. Guidelines

- Use **placeholder values** consistently: `john`, `password123`, `test.local`, `10.10.10.1`
- Commands should be **verified and working**
- Include **multiple variants** where useful (e.g., with password vs with hash)
- Include a **download/reference link**
- Port numbers must be **quoted strings** (e.g., `"445"` not `445`)

### 4. Submit a Pull Request

Fork the repo, add your entry, and submit a PR. CI will validate your YAML syntax.
