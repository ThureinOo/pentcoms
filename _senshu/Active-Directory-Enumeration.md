---
description: |
  Active Directory enumeration — discover domain information, users, groups, shares, and relationships using LDAP, SMB, Kerberos, and BloodHound.
commands:
  - have: No_Creds
    cmd: |
      nxc smb 10.10.10.27
      nxc smb 10.10.10.27 -u '' -p '' --shares --users --rid-brute
      kerbrute userenum -d senshu.local --dc 10.10.10.27 /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt
  - have: Credentials
    cmd: |
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --users
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --pass-pol
      bloodhound-python -c All -u sec_user -p 'P@ssw0rd' -d senshu.local -ns 10.10.10.27 --zip

      # bloodyAD — enumerate group members
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get groupMember "Domain Admins"

      # bloodyAD — find all objects you have write access to
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get writable --detail

      # bloodyAD — arbitrary LDAP search
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get search --filter '(sAMAccountName=targetuser)'

      # PowerView
      Import-Module .\PowerView.ps1
      Get-DomainUser | Select-Object samaccountname, memberof, description
      Find-InterestingDomainAcl -ResolveGUIDs
  - have: Shell
    cmd: |
      whoami /all
      net user /domain
      net group "Domain Admins" /domain
      net localgroup Administrators
      nltest /dclist:senshu.local
phase:
  - Enumeration
target_os:
  - Windows
services:
  - Active_Directory
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
