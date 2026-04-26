---
description: |
  LDAP enumeration — querying Active Directory for naming contexts, users, groups, and domain info on ports 389/636.
commands:
  - have: No_Creds
    cmd: |
      ldapsearch -x -H ldap://10.10.10.27 -s base namingcontexts
      nmap -p 389 --script ldap-rootdse,ldap-search 10.10.10.27
  - have: Credentials
    cmd: |
      ldapsearch -x -H ldap://10.10.10.27 -D 'sec_user@senshu.local' -w 'P@ssw0rd' -b 'DC=senshu,DC=sh' '(objectClass=user)'
      nxc ldap 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' --users
      nxc ldap 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' --groups
      kerbrute userenum -d senshu.local /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt --dc 10.10.10.27
      impacket-GetADUsers -all -dc-ip 10.10.10.27 senshu.local/sec_user:'P@ssw0rd'
      # adPEAS (from Windows):
      # . .\adPEAS.ps1; Invoke-adPEAS -Domain senshu.local
phase:
  - Enumeration
target_os:
  - Windows
services:
  - LDAP
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-ldap.html
  - https://github.com/61106960/adPEAS
---
