---
description: |
  Nmap is the go-to network scanner for port scanning, service/version detection, and vulnerability checks. Supports TCP, UDP, scripting engine (NSE), and multiple output formats.
command: |
  # Basic Scans
  # Default scan (top 1000 TCP ports):
  nmap 10.10.10.27

  # Default scan with timing (faster):
  nmap -T4 10.10.10.27

  # Service and Version Detection
  # Service version and default scripts:
  nmap -sCV 10.10.10.27

  # Targeted service scan on specific ports:
  nmap -sCV -p 21,22,80,443,445,3389 10.10.10.27

  # Service version detection with aggressive timing:
  nmap -sCV -T4 10.10.10.27

  # Full Port Scans
  # All 65535 TCP ports:
  nmap -p- 10.10.10.27

  # All ports fast, then targeted service scan:
  nmap -p- --min-rate 5000 -T4 10.10.10.27
  nmap -sCV -p <open_ports> 10.10.10.27

  # Full port scan with service detection (slow but thorough):
  nmap -p- -sCV 10.10.10.27

  # UDP Scanning
  # UDP top 20 ports:
  nmap -sU --top-ports 20 10.10.10.27

  # UDP top 100 ports with version detection:
  nmap -sU --top-ports 100 -sCV 10.10.10.27

  # Windows-Focused Scans
  # Common Windows ports, skip host discovery:
  nmap -Pn -p 135,139,445,80,443,3389,5985,5986 --open 10.10.10.27

  # Windows ports with service detection:
  nmap -Pn -sCV -p 135,139,445,80,443,3389,5985 10.10.10.27

  # Vulnerability Scanning
  # Run all vuln scripts:
  nmap --script vuln 10.10.10.27

  # EternalBlue (MS17-010) check:
  nmap --script smb-vuln-ms17-010 -p 445 10.10.10.27

  # All SMB vulnerability scripts:
  nmap --script smb-vuln* -p 445 10.10.10.27

  # Subnet Scanning
  # Scan entire subnet (skip host discovery):
  nmap -Pn 10.10.10.0/24

  # Subnet scan with service detection on common ports:
  nmap -Pn -sCV -p 22,80,443,445 10.10.10.0/24 --open

  # IPv6 Scanning
  # Scan IPv6 target:
  nmap -6 -sCV fe80::1

  # Output Options
  # Save output in normal format:
  nmap -sCV 10.10.10.27 -oN scan.nmap

  # Save output in all formats (normal, XML, grepable):
  nmap -sCV 10.10.10.27 -oA scan

  # Common Combo — Full Enumeration
  # Quick all-port discovery:
  nmap -p- --min-rate 5000 -T4 10.10.10.27 -oN allports.nmap
  # Detailed scan on discovered ports:
  nmap -sCV -p 22,80,443,8080 10.10.10.27 -oN targeted.nmap
  # UDP check:
  nmap -sU --top-ports 20 10.10.10.27 -oN udp.nmap
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
