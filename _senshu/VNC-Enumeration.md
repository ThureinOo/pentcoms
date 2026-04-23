---
description: |
  VNC enumeration — version detection, authentication checks, and brute-forcing on ports 5900-5910.
commands:
  - have: No_Creds
    cmd: |
      # Nmap VNC version and authentication info
      nmap -sV -p 5900-5910 --script vnc-info 10.10.10.27

      # Nmap VNC brute-force with default passwords
      nmap -p 5900 --script vnc-brute 10.10.10.27

      # Run all VNC NSE scripts (info, brute, title)
      nmap -p 5900-5910 --script "vnc-*" 10.10.10.27
phase:
  - Enumeration
target_os:
  - Linux
  - Windows
services:
  - VNC
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-vnc.html
---
