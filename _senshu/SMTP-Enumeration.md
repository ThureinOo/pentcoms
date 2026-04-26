---
description: |
  SMTP enumeration — user enumeration via VRFY/EXPN, relay testing, and NTLM info extraction on port 25.
commands:
  - have: No_Creds
    cmd: |
      # Nmap SMTP scripts — commands, user enum, NTLM info
      nmap -p 25 --script smtp-commands,smtp-enum-users,smtp-ntlm-info 10.10.10.27

      # Automated user enumeration with smtp-user-enum
      smtp-user-enum -M VRFY -U users.txt -t 10.10.10.27

      # --- Manual enumeration via telnet ---
      telnet 10.10.10.27 25

      # Verify if a user exists
      VRFY sec_user

      # Expand a mailing list / alias
      EXPN admin

      # --- Test for open relay ---
      MAIL FROM:<attacker@senshu.local>
      RCPT TO:<victim@external.com>
      DATA
      Subject: Relay Test
      Test message
      .
      QUIT
phase:
  - Enumeration
target_os:
  - Linux
  - Windows
services:
  - SMTP
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-smtp/index.html
---
