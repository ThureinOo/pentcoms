---
description: |
  Scan all 65535 TCP ports on a target to find non-standard services.

  Reference values:
    Target IP: 10.10.10.1
command: |
  nmap -p- --min-rate 10000 -oN nmap/allports 10.10.10.1
phase:
  - Scanning
target_os:
  - Linux
  - Windows
services: []
ports: []
items:
  - No_Creds
techniques: []
network_position:
  - External
  - Internal
references:
  - https://nmap.org/book/man.html
---
