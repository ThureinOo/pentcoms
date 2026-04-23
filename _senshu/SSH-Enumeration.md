---
description: |
  SSH enumeration — banner grabbing, version detection, authentication method checks, and algorithm enumeration on port 22.
commands:
  - have: No_Creds
    cmd: |
      # Nmap service/version detection on SSH
      nmap -sCV -p 22 10.10.10.27

      # Banner grab with netcat — reveals SSH version and OS hints
      nc -nv 10.10.10.27 22

      # Verbose SSH connection attempt — shows version negotiation details
      ssh -v sec_user@10.10.10.27 2>&1 | head -20

      # Enumerate supported authentication methods
      nmap --script ssh-auth-methods -p 22 10.10.10.27

      # Enumerate supported key exchange, encryption, and MAC algorithms
      nmap --script ssh2-enum-algos -p 22 10.10.10.27
phase:
  - Enumeration
target_os:
  - Linux
  - macOS
services:
  - SSH
techniques: []
references:
  - https://nmap.org/nsedoc/scripts/ssh2-enum-algos.html
  - https://nmap.org/nsedoc/scripts/ssh-auth-methods.html
---
