---
description: |
  Collect Active Directory data for BloodHound attack path analysis
  using bloodhound-python or SharpHound.

  Reference values:
    Target DC: 10.10.10.1
    Domain: test.local
    Username: john
    Password: password123
command: |
  # bloodhound-python (from Linux)
  bloodhound-python -u john -p 'password123' -d test.local -ns 10.10.10.1 -c All

  # SharpHound (from Windows)
  .\SharpHound.exe -c All --domain test.local

  # SharpHound PowerShell
  Import-Module .\SharpHound.ps1
  Invoke-BloodHound -CollectionMethod All
phase:
  - Enumeration
target_os:
  - Windows
services:
  - LDAP
  - Kerberos
ports:
  - "389"
  - "88"
  - "445"
items:
  - Username
  - Password
techniques:
  - BloodHound
network_position:
  - Internal
references:
  - https://github.com/BloodHoundAD/BloodHound
  - https://github.com/dirkjanm/BloodHound.py
---
