---
description: |
  Host discovery and ping sweep techniques to identify live hosts on a network. Covers ICMP, ARP, and TCP-based discovery using nmap, fping, netdiscover, arp-scan, and masscan.
command: |
  # ICMP ping sweep:
  nmap -sn 10.10.10.0/24

  # ARP discovery (local subnet):
  nmap -sn -PR 10.10.10.0/24

  # TCP SYN ping (when ICMP blocked):
  nmap -sn -PS22,80,443,445 10.10.10.0/24

  # fping — fast ICMP sweep:
  fping -asgq 10.10.10.0/24

  # arp-scan — Layer 2 discovery:
  arp-scan -l

  # masscan — fast port-based discovery:
  masscan 10.10.10.0/24 -p 22,80,443,445 --rate=1000

  # Bash ping sweep (no tools needed):
  for i in {1..255} ;do (ping -c 1 192.168.110.$i | grep "bytes from"|cut -d ' ' -f4|tr -d ':' &);done
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
  - https://nmap.org/book/man-host-discovery.html
  - https://github.com/fping/fping
  - https://github.com/royhills/arp-scan
  - https://github.com/robertdavidgraham/masscan
---
