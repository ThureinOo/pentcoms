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
network_position:
  - Internal
references:
  - https://github.com/example/tool
---
```

### 4. Valid values for each field

**Phase:**
`Recon`, `Scanning`, `Enumeration`, `Exploitation`, `Post-Exploitation`, `PrivEsc`, `Lateral_Movement`, `Persistence`, `Exfiltration`

**Target OS:**
`Linux`, `Windows`, `macOS`

**Services:**
`SMB`, `HTTP`, `SSH`, `FTP`, `DNS`, `LDAP`, `Kerberos`, `RDP`, `WinRM`, `MSSQL`, `MySQL`, `SNMP`, `SMTP`, `RPC`, `NFS`, `WMI`, `DCOM`, `NTLM`, `VNC`, `Redis`, `PostgreSQL`

**Items (What you have):**
`No_Creds`, `Username`, `Password`, `Hash`, `TGT`, `TGS`, `Certificate`, `Shell`, `Key`, `Token`, `SPN`

**Techniques:**
`Kerberoasting`, `AS-REP_Roasting`, `Pass-the-Hash_Ticket`, `Ticket_Forgery`, `DCSync`, `NTLM_Relay_Poisoning`, `BloodHound`, `Password_Spraying`, `Delegation_Abuse`, `ACL_Abuse`, `ADCS_Abuse`, `Shadow_Credentials`, `Web_Injection`, `Web_File_Attack`, `Deserialization`, `Reverse_Shell`, `Pivoting_Tunneling`, `Token_Impersonation`, `Linux_Misconfig`, `Kernel_Exploit`

**Network Position:**
`External`, `Internal`, `Local`

### 5. Guidelines

- Use **placeholder values** consistently: `sec_user`, `P@ssw0rd`, `senshu.local`, `10.10.10.27` (attacker: `10.10.10.21`)
- Commands should be **verified and working**
- Include **multiple variants** where useful (e.g., with password vs. with hash)
- Include at least one **reference link** (tool repository or documentation)
- Use empty arrays `[]` for fields that don't apply (e.g., `techniques: []`)
- Each PR should include **one command entry** for easier review

### 6. Submit a Pull Request

Push your changes and submit a PR to the main repository. Provide a brief description of the tool and why it's useful for pentesters.
