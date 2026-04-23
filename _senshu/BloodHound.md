---
description: |
  BloodHound — collect and visualize Active Directory relationships to identify attack paths to Domain Admin.
commands:
  - have: Credentials
    cmd: |
      # bloodhound-python — remote collection from Linux
      bloodhound-python -u sec_user -p 'P@ssw0rd' -d senshu.sh -ns 10.10.10.27 --dns-tcp -c All --zip

      # NetExec — BloodHound collection via LDAP
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' --bloodhound --collection All

      # NetExec — with explicit DNS server
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' --dns-server 10.10.10.27 --bloodhound --collection All

      # SharpHound — run from Windows session (generates zip)
      .\SharpHound.exe -c All --zip

      # Start BloodHound GUI
      sudo ./BloodHound --no-sandbox

      # Import the .zip file into BloodHound and run queries:
      # - Find Shortest Paths to Domain Admins
      # - Find AS-REP Roastable Users
      # - Find Kerberoastable Users
phase:
  - Enumeration
target_os:
  - Windows
services:
  - LDAP
techniques:
  - BloodHound
references:
  - https://github.com/BloodHoundAD/BloodHound
  - https://github.com/dirkjanm/BloodHound.py
  - https://www.netexec.wiki/
---
