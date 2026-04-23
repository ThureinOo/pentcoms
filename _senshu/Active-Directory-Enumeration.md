---
description: |
  Active Directory enumeration — discover domain information, users, groups, shares, and relationships using LDAP, SMB, Kerberos, and BloodHound.
commands:
  - have: No_Creds
    cmd: |
      # Basic SMB enumeration — domain name, signing, SMBv1
      nxc smb 10.10.10.27

      # Null session — enumerate shares and users
      nxc smb 10.10.10.27 -u '' -p '' --shares
      nxc smb 10.10.10.27 -u '' -p '' --users

      # enum4linux — automated SMB/LDAP enumeration
      enum4linux 10.10.10.27

      # RID brute-force — enumerate users via SID lookup
      nxc smb 10.10.10.27 -u '' -p '' --rid-brute

      # Kerbrute — username enumeration via Kerberos (no auth required)
      kerbrute userenum -d senshu.sh --dc 10.10.10.27 /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt
  - have: Credentials
    cmd: |
      # Enumerate domain users (check BadPW count for lockout awareness)
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --users

      # Password policy — check lockout threshold before spraying
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --pass-pol

      # rpcclient — enumerate users and groups
      rpcclient -U 'sec_user%P@ssw0rd' 10.10.10.27 -c 'enumdomusers'
      rpcclient -U 'sec_user%P@ssw0rd' 10.10.10.27 -c 'enumdomgroups'

      # ldapsearch — query all users
      ldapsearch -x -H ldap://10.10.10.27 -D "sec_user@senshu.sh" -w 'P@ssw0rd' -b "DC=senshu,DC=sh" "(objectClass=user)" sAMAccountName memberOf

      # ldapsearch — query all groups
      ldapsearch -x -H ldap://10.10.10.27 -D "sec_user@senshu.sh" -w 'P@ssw0rd' -b "DC=senshu,DC=sh" "(objectClass=group)" cn member

      # BloodHound — collect all AD data for graph analysis
      bloodhound-python -c All -u sec_user -p 'P@ssw0rd' -d senshu.sh -ns 10.10.10.27 --zip

      # NetExec — BloodHound collection
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' --bloodhound --collection All

      # SharpHound — run from Windows
      .\SharpHound.exe -c All --zip

      # PowerView — detailed enumeration
      Import-Module .\PowerView.ps1
      Get-DomainUser | Select-Object samaccountname, memberof, description
      Get-DomainGroup -Identity "Domain Admins" | Select-Object member
      Get-DomainComputer | Select-Object name, operatingsystem
      Find-InterestingDomainAcl -ResolveGUIDs

      # adPEAS — automated AD enumeration
      . .\adPEAS.ps1
      Invoke-adPEAS

      # Net commands
      net user /domain
      net group "Domain Admins" /domain
  - have: Shell
    cmd: |
      # SharpHound from domain-joined host
      .\SharpHound.exe -c All --zip

      # PowerView from domain-joined host
      Import-Module .\PowerView.ps1
      Get-DomainUser
      Get-DomainGroup
      Get-DomainComputer

      # Net commands — basic enumeration
      whoami /all
      net user /domain
      net group "Domain Admins" /domain
      net localgroup Administrators
      nltest /dclist:senshu.sh
phase:
  - Enumeration
target_os:
  - Windows
services:
  - LDAP
  - Kerberos
techniques:
  - BloodHound
references:
  - https://github.com/BloodHoundAD/BloodHound
  - https://github.com/BloodHoundAD/SharpHound
  - https://github.com/PowerShellMafia/PowerSploit/tree/master/Recon
  - https://www.netexec.wiki/
  - https://github.com/61106960/adPEAS
---
