---
description: |
  Enumerate information from Windows/Samba systems via SMB — users, shares,
  groups, password policies, and more.

  Reference values:
    Target IP: 10.10.10.1
command: |
  # Full enumeration (no creds)
  enum4linux-ng 10.10.10.1 -A

  # With credentials
  enum4linux-ng 10.10.10.1 -u john -p 'password123' -A
phase:
  - Enumeration
target_os:
  - Windows
  - Linux
services:
  - SMB
  - RPC
ports:
  - "445"
  - "139"
  - "135"
items:
  - No_Creds
  - Username
  - Password
techniques: []
network_position:
  - Internal
references:
  - https://github.com/cddmp/enum4linux-ng
---
