---
description: |
  RDP enumeration — checking for Remote Desktop access, NLA, NTLM info extraction, and credential validation on port 3389.
commands:
  - have: No_Creds
    cmd: |
      # Nmap RDP scripts — encryption level, NTLM info (hostname, domain, OS)
      nmap -p 3389 --script rdp-enum-encryption,rdp-ntlm-info 10.10.10.27

      # NetExec — check if RDP is open
      nxc rdp 10.10.10.27
  - have: Credentials
    cmd: |
      # NetExec — validate RDP credentials (domain account)
      nxc rdp 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd'

      # NetExec — validate with local account
      nxc rdp 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' --local-auth
  - have: Hash
    cmd: |
      # NetExec — check RDP access with NTLM hash
      nxc rdp 10.10.10.27 -u 'sec_user' -H '<NTLM_HASH>'
phase:
  - Enumeration
target_os:
  - Windows
services:
  - RDP
techniques: []
references:
  - https://www.netexec.wiki/rdp-protocol
---
