---
description: |
  NFS enumeration — listing exported shares and mounting them locally on ports 111/2049.
commands:
  - have: No_Creds
    cmd: |
      showmount -e 10.10.10.27
      # Note: sometimes requires sudo
      sudo showmount -e 10.10.10.27
      nmap -p 111,2049 --script nfs-ls,nfs-showmount,nfs-statfs 10.10.10.27
      mkdir /tmp/nfs && sudo mount -t nfs 10.10.10.27:/share /tmp/nfs
phase:
  - Enumeration
target_os:
  - Linux
services:
  - NFS
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/nfs-service-pentesting.html
---
