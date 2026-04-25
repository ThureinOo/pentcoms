---
description: |
  Nmap is the go-to network scanner for port scanning, service/version detection, and vulnerability checks. Supports TCP, UDP, scripting engine (NSE), and multiple output formats.
command: |
  # Service version + default scripts:
  nmap -sCV 10.10.10.27

  # Targeted ports:
  nmap -sCV -p 21,22,80,443,445,3389 10.10.10.27

  # All ports fast, then targeted:
  nmap -p- --min-rate 5000 -T4 10.10.10.27
  nmap -sCV -p <open_ports> 10.10.10.27

  # UDP top 20:
  sudo nmap -sU --top-ports 20 10.10.10.27

  # Vulnerability scan:
  nmap --script vuln 10.10.10.27

  # EternalBlue check:
  nmap --script smb-vuln-ms17-010 -p 445 10.10.10.27

  # Save all formats:
  nmap -sCV 10.10.10.27 -oA scan
items:
  - No_Creds
phase:
  - Reconnaissance
target_os:
  - Linux
  - Windows
  - macOS
services: []
techniques: []
references:
  - https://nmap.org/book/man.html
---
