---
layout: page
title: Contribute
---

## How to Contribute

Senshu is open source and welcomes contributions from the security community. To add a new command, follow these steps:

### 1. Fork the repository

Fork [Senshu on GitHub](https://github.com/ThureinOo/senshu) and clone it locally.

### 2. Create a new file

Add a `.md` file in the `_senshu/` directory. Name it after the tool, using hyphens for spaces (e.g., `Impacket-PsExec.md`).

### 3. Use the following YAML front matter format

Each entry is a Markdown file that contains **only YAML front matter** (no body content). Here is the template:

```yaml
---
description: |
  Brief description of what the tool/command does and when to use it.

  Reference values:
    Target IP: 10.10.10.27
    Domain: senshu.local
    Username: sec_user
    Attacker IP: 10.10.10.21
    Password: P@ssw0rd
command: |
  your-command-here
phase:
  - Enumeration
target_os:
  - Windows
services:
  - SMB
items:
  - Username
  - Password
techniques:
  - Kerberoasting
references:
  - https://github.com/example/tool
---
```

For entries that need different commands depending on what the user already has, use `commands` instead of `command`:

```yaml
commands:
  - have: No_Creds
    cmd: |
      unauthenticated-command 10.10.10.27
  - have: Credentials
    cmd: |
      authenticated-command -u sec_user -p 'P@ssw0rd' 10.10.10.27
```

### 4. Valid values for each field

**Phase:**
`Reconnaissance`, `Enumeration`, `Exploitation`, `Post-Exploitation`, `PrivEsc`, `Persistence`

**Target OS:**
`Linux`, `Windows`, `macOS`

**Services:**
`Active_Directory`, `ADCS`, `SMB`, `HTTP`, `SSH`, `FTP`, `DNS`, `LDAP`, `Kerberos`, `RDP`, `WinRM`, `MSSQL`, `MySQL`, `SNMP`, `SMTP`, `RPC`, `NFS`, `VNC`, `Redis`, `PostgreSQL`

**Items (What you have):**
`No_Creds`, `Username`, `Password`, `Credentials`, `Hash`, `TGT`, `TGS`, `Certificate`, `Shell`, `Key`, `Token`, `SPN`

**Techniques:**
`XSS`, `Injection`, `Command_Injection`, `SSRF`, `LFI_RFI`, `SSTI`, `File_Upload`, `XXE`, `Token_Impersonation`, `Service_Misconfig`, `DLL_Hijack`, `UAC_Bypass`, `Kernel_Exploit`, `Defense_Evasion`, `Perm_Abuse`, `Cron_Abuse`, `Library_Hijack`, `Docker_Escape`, `NFS_Abuse`, `Writable_Service`, `TCC_Bypass`, `Dylib_Hijack`, `LaunchDaemon_Abuse`, `Kerberoasting`, `AS-REP_Roasting`, `Pass-the-Hash`, `NTLM_Relay`, `DCSync`, `Pass-the-Ticket`, `BloodHound`, `Password_Spraying`, `ACL_Abuse`, `ADCS_Abuse`, `Delegation_Abuse`, `Ticket_Forgery`, `Credential_Theft`, `CVE_Exploit`

The source of truth for these values is `_data/`. Run `ruby scripts/validate_entries.rb` before opening a pull request.

### 5. Guidelines

- Use **placeholder values** consistently: `sec_user`, `P@ssw0rd`, `senshu.local`, `10.10.10.27` (attacker: `10.10.10.21`)
- Commands should be **verified and working**
- Include **multiple variants** where useful (e.g., with password vs. with hash)
- Include at least one **reference link** (tool repository or documentation)
- Use empty arrays `[]` for fields that don't apply (e.g., `techniques: []`)
- Each PR should include **one command entry** for easier review

### 6. Submit a Pull Request

Push your changes and submit a PR to the main repository. Provide a brief description of the tool and why it's useful for pentesters.
