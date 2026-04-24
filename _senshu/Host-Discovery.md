---
description: |
  Host discovery and ping sweep techniques to identify live hosts on a network. Covers ICMP, ARP, and TCP-based discovery using nmap, fping, netdiscover, arp-scan, and masscan.
command: |
  # Nmap — Ping Sweep
  # ICMP ping sweep (no port scan):
  nmap -sn 10.10.10.0/24

  # Ping sweep with output:
  nmap -sn 10.10.10.0/24 -oG ping_sweep.gnmap

  # ARP discovery on local subnet:
  nmap -sn -PR 10.10.10.0/24

  # TCP SYN ping (useful when ICMP is blocked):
  nmap -sn -PS22,80,443,445 10.10.10.0/24

  # TCP ACK ping:
  nmap -sn -PA80,443 10.10.10.0/24

  # UDP ping:
  nmap -sn -PU53,161 10.10.10.0/24

  # Scan from target list file:
  nmap -sn -iL targets.txt

  # fping — Fast ICMP Sweep
  # Sweep a subnet, show alive hosts:
  fping -asgq 10.10.10.0/24

  # Sweep with timeout:
  fping -asgq -t 100 10.10.10.0/24

  # Sweep from file:
  fping -asgq -f targets.txt

  # arp-scan — Layer 2 Discovery
  # Scan local network:
  arp-scan -l

  # Scan specific subnet:
  arp-scan 10.10.10.0/24

  # Scan specific interface:
  arp-scan -I eth0 -l

  # netdiscover — ARP Reconnaissance
  # Active ARP scan:
  netdiscover -r 10.10.10.0/24

  # Passive ARP sniffing:
  netdiscover -p

  # Active scan on specific interface:
  netdiscover -i eth0 -r 10.10.10.0/24

  # masscan — Fast Port-Based Discovery
  # Discover hosts with common ports open:
  masscan 10.10.10.0/24 -p 22,80,443,445 --rate=1000

  # Full port scan at high speed:
  masscan 10.10.10.0/24 -p1-65535 --rate=10000

  # Output to list format:
  masscan 10.10.10.0/24 -p 80,443 --rate=1000 -oL alive_hosts.txt

  # Bash — ICMP Ping Sweep
  # One-liner ping sweep:
  for i in $(seq 1 254); do (ping -c 1 -W 1 10.10.10.$i | grep "bytes from" &); done

  # PowerShell — Windows Ping Sweep
  # One-liner ping sweep:
  1..254 | ForEach-Object { Test-Connection -Count 1 -Quiet -ComputerName "10.10.10.$_" | Where-Object { $_ } | ForEach-Object { "10.10.10.$_" } }
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
