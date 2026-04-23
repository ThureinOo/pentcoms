---
description: |
  WinRM enumeration — checking for Windows Remote Management access on ports 5985/5986.
commands:
  - have: Credentials
    cmd: |
      nxc winrm 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd'
  - have: Hash
    cmd: |
      nxc winrm 10.10.10.27 -u 'sec_user' -H '<NTLM_HASH>'
phase:
  - Enumeration
target_os:
  - Windows
services:
  - WinRM
techniques: []
references:
  - https://www.netexec.wiki/winrm-protocol
---
