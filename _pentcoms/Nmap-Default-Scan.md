---
description: |
  Run a default nmap scan to discover open ports and services on a target.

  Reference values:
    Target IP: 10.10.10.1
command: |
  nmap -sC -sV -oN nmap/initial 10.10.10.1
phase:
  - Scanning
target_os:
  - Linux
  - Windows
services:
  - HTTP
  - SSH
  - SMB
ports:
  - "80"
  - "22"
  - "445"
items:
  - No_Creds
techniques: []
network_position:
  - External
  - Internal
references:
  - https://nmap.org/book/man.html
---
