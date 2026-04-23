---
description: |
  RPC enumeration — enumerating domain users, groups, SIDs, and password policies via MS-RPC on port 135.
commands:
  - have: No_Creds
    cmd: |
      # Null session — open interactive rpcclient (anonymous/no password)
      rpcclient -U "" -N 10.10.10.27

      # Inside rpcclient shell:
      rpcclient $> srvinfo
      rpcclient $> enumdomusers
      rpcclient $> enumdomgroups
      rpcclient $> querydispinfo
      rpcclient $> getdompwinfo
      rpcclient $> enumprinters

      # Nmap RPC scripts
      nmap -p 135 --script rpc-grind,rpcinfo 10.10.10.27
  - have: Credentials
    cmd: |
      # Authenticated rpcclient session
      rpcclient 10.10.10.27 -U 'sec_user%P@ssw0rd'

      # Enumerate domain users and groups
      rpcclient $> enumdomusers
      rpcclient $> enumdomgroups

      # Query specific user by RID (0x1f4 = Administrator, RID 500)
      rpcclient $> queryuser 0x1f4

      # Query specific group by RID (0x200 = Domain Users)
      rpcclient $> querygroup 0x200

      # Resolve username to SID
      rpcclient $> lookupnames administrator
phase:
  - Enumeration
target_os:
  - Windows
services:
  - RPC
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/135-pentesting-msrpc.html
---
