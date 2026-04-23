---
description: |
  SMB (Server Message Block) enumeration for discovering shares, users, groups, and policies on ports 139/445.
commands:
  - have: No_Creds
    cmd: |
      nxc smb 10.10.10.27
      nxc smb 10.10.10.27 -u '' -p '' --shares
      smbclient -L //10.10.10.27 -N
      smbmap -H 10.10.10.27
      enum4linux-ng -A 10.10.10.27
      nmap -p 445 --script smb-enum-shares,smb-enum-users,smb-os-discovery 10.10.10.27
      rpcclient -U "" -N 10.10.10.27 -c "enumdomusers"
      rpcclient -U "" -N 10.10.10.27 -c "enumdomgroups"
      nxc smb 10.10.10.27 -u '' -p '' --rid-brute
  - have: Username
    cmd: |
      nxc smb 10.10.10.27 -u 'sec_user' -p '' --rid-brute
      nxc smb 10.10.10.27 -u 'guest' -p '' --shares
  - have: Credentials
    cmd: |
      nxc smb 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' --shares
      smbmap -u 'sec_user' -p 'P@ssw0rd' -H 10.10.10.27
      smbmap -u 'sec_user' -p 'P@ssw0rd' -H 10.10.10.27 -R
      smbclient //10.10.10.27/Share -U 'sec_user%P@ssw0rd'
      rpcclient -U 'sec_user%P@ssw0rd' 10.10.10.27 -c "enumdomusers"
      nxc smb 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' --users
      nxc smb 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' --pass-pol
      nxc smb 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' --local-auth --shares
      nxc smb 10.10.10.27 -u 'sec_user' -p 'P@ssw0rd' -M spider_plus
      # Inside smbclient — download a file:
      # smb: \> get secret.txt
      # Inside smbclient — upload a file:
      # smb: \> put shell.aspx
  - have: Hash
    cmd: |
      nxc smb 10.10.10.27 -u 'sec_user' -H '<NTLM_HASH>' --shares
      smbmap -u 'sec_user' -p '<NTLM_HASH>:' -H 10.10.10.27
phase:
  - Enumeration
target_os:
  - Windows
  - Linux
services:
  - SMB
techniques: []
references:
  - https://www.netexec.wiki/smb-protocol/enumeration
  - https://github.com/cddmp/enum4linux-ng
---
