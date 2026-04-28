---
description: |
  BloodHound — collect and visualize Active Directory relationships to identify attack paths to Domain Admin.
commands:
  - have: Credentials
    cmd: |
      # Remote collection from Linux
      bloodhound-python -u sec_user -p 'P@ssw0rd' -d senshu.local -ns 10.10.10.27 --dns-tcp -c All --zip
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' --bloodhound --collection All

      # SharpHound from Windows
      .\SharpHound.exe -c All --zip

      # Import .zip into BloodHound GUI, run: Shortest Paths to DA, Kerberoastable, AS-REP Roastable
      sudo ./BloodHound --no-sandbox
phase:
  - Enumeration
target_os:
  - Windows
services:
  - Active_Directory
  - LDAP
techniques:
  - BloodHound
references:
  - https://github.com/BloodHoundAD/BloodHound
  - https://github.com/dirkjanm/BloodHound.py
  - https://www.netexec.wiki/
---
