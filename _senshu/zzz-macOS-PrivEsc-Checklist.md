---
display_name: "macOS PrivEsc Checklist"
description: |
  macOS privilege escalation checklist — run these fast checks top to bottom after landing a shell.
  Each positive result links to the specific technique entry. Stop and exploit the first win you find.
commands:
  - have: Shell
    cmd: |
      # ════════════════════════════════════════════════════════════════
      # PHASE 1 — WHO AM I / SITUATIONAL AWARENESS
      # ════════════════════════════════════════════════════════════════

      # current user, UID, GID, and all group memberships
      id

      # macOS version and build — needed for CVE selection
      sw_vers

      # kernel version
      uname -a

      # check SIP (System Integrity Protection) status — if disabled, many more attacks possible
      csrutil status

      # environment variables — may expose credentials or interesting paths
      env

      # other users with login shells — potential lateral targets
      dscl . list /Users | grep -v "^_"

      # ════════════════════════════════════════════════════════════════
      # PHASE 2 — SUDO  →  Linux-SUID-Sudo.md (same commands apply)
      # ════════════════════════════════════════════════════════════════

      # list what current user can run with sudo — the single most important check
      sudo -l

      # NOPASSWD entry → immediate root without a password
      # sudo <binary> → check GTFOBins for that binary
      # env_keep LD_PRELOAD → dylib hijack  →  macOS-Dylib-Hijack.md
      # sudo ALL → instant root: sudo su -

      # try sudo without a password
      sudo -n whoami 2>/dev/null

      # ════════════════════════════════════════════════════════════════
      # PHASE 3 — SUID BINARIES
      # ════════════════════════════════════════════════════════════════

      # find all SUID binaries — compare against GTFOBins
      find / -perm -4000 -type f 2>/dev/null

      # macOS common SUID binaries (often exploitable in older versions):
      # /usr/bin/sudo, /usr/bin/newgrp, /usr/libexec/security_authtrampoline

      # ════════════════════════════════════════════════════════════════
      # PHASE 4 — TCC BYPASS / PRIVACY PERMISSIONS  →  macOS-TCC-Bypass.md
      # ════════════════════════════════════════════════════════════════

      # check TCC database — which apps have sensitive permissions (FDA, screen recording, etc.)
      sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT * FROM access" 2>/dev/null

      # check system TCC database (requires root or SIP disabled)
      sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "SELECT * FROM access" 2>/dev/null

      # look for apps with Full Disk Access (kTCCServiceSystemPolicyAllFiles)
      sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db \
        "SELECT client FROM access WHERE service='kTCCServiceSystemPolicyAllFiles'" 2>/dev/null

      # ════════════════════════════════════════════════════════════════
      # PHASE 5 — LAUNCH DAEMONS / AGENTS  →  macOS-LaunchDaemon-Abuse.md
      # ════════════════════════════════════════════════════════════════

      # list all LaunchDaemons (run as root) — check if any plist or binary is writable
      ls -la /Library/LaunchDaemons/
      ls -la /System/Library/LaunchDaemons/

      # list user LaunchAgents (run as current user on login)
      ls -la ~/Library/LaunchAgents/
      ls -la /Library/LaunchAgents/

      # check write permissions on a daemon plist or its binary
      ls -la /Library/LaunchDaemons/com.example.daemon.plist
      plutil -p /Library/LaunchDaemons/com.example.daemon.plist  # read the plist
      ls -la /path/to/daemon/binary

      # if plist or binary is writable → replace binary or modify ProgramArguments  →  macOS-LaunchDaemon-Abuse.md

      # ════════════════════════════════════════════════════════════════
      # PHASE 6 — DYLIB HIJACKING  →  macOS-Dylib-Hijack.md
      # ════════════════════════════════════════════════════════════════

      # find apps that load dylibs from writable locations (DYLD_LIBRARY_PATH, rpath abuse)
      otool -L /Applications/SomeApp.app/Contents/MacOS/SomeApp 2>/dev/null

      # check if any dylib path in the list is missing or writable
      ls -la /usr/local/lib/missing.dylib 2>/dev/null

      # check @rpath entries — if an earlier rpath dir is writable, drop a malicious dylib there
      otool -l /Applications/SomeApp.app/Contents/MacOS/SomeApp | grep -A2 LC_RPATH

      # ════════════════════════════════════════════════════════════════
      # PHASE 7 — CRON JOBS / PERIODIC SCRIPTS
      # ════════════════════════════════════════════════════════════════

      # user crontab
      crontab -l

      # system cron
      cat /etc/crontab 2>/dev/null
      ls -la /etc/periodic/daily /etc/periodic/weekly /etc/periodic/monthly 2>/dev/null

      # check if any periodic script is writable
      ls -la /etc/periodic/daily/

      # use pspy equivalent for macOS — monitor new processes
      # fs_usage -w -f filesys 2>/dev/null | grep -v dtrace  (verbose, look for root processes)

      # ════════════════════════════════════════════════════════════════
      # PHASE 8 — STORED CREDENTIALS / KEYCHAIN
      # ════════════════════════════════════════════════════════════════

      # dump keychain items accessible to current user (prompts for password)
      security dump-keychain -d login.keychain 2>/dev/null

      # find items in the keychain
      security find-generic-password -ga "ServiceName" 2>/dev/null

      # bash/zsh history — may contain passwords passed as CLI arguments
      cat ~/.bash_history ~/.zsh_history 2>/dev/null

      # config files with credentials
      find ~ /etc /usr/local -name "*.conf" -o -name "*.env" -o -name "*.plist" 2>/dev/null \
        | xargs grep -li "password\|passwd\|secret\|token\|apikey" 2>/dev/null

      # SSH private keys
      find ~ -name "id_rsa" -o -name "id_ed25519" -o -name "*.pem" 2>/dev/null

      # clipboard — may contain passwords if user recently copied one
      pbpaste

      # ════════════════════════════════════════════════════════════════
      # PHASE 9 — RUNNING PROCESSES / INTERNAL SERVICES
      # ════════════════════════════════════════════════════════════════

      # processes running as root — look for exploitable services
      ps aux | grep root | grep -v "\[" | grep -v grep

      # listening ports not exposed externally
      netstat -an | grep LISTEN
      lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null

      # identify the process behind an interesting port
      lsof -i :<PORT>

      # ════════════════════════════════════════════════════════════════
      # PHASE 10 — GROUP MEMBERSHIP
      # ════════════════════════════════════════════════════════════════

      # check all groups — look for admin, wheel, staff, _developer
      id
      groups

      # admin group → can use sudo for many commands (check sudo -l)
      dscl . read /Groups/admin GroupMembership

      # _developer group → Xcode debug privileges (may allow process injection)
      dscl . read /Groups/_developer GroupMembership

      # ════════════════════════════════════════════════════════════════
      # PHASE 11 — CLIPBOARD / KEYLOG OPPORTUNITIES  →  macOS-Clipboard-Keylog.md
      # ════════════════════════════════════════════════════════════════

      # read current clipboard contents — useful for capturing recently copied passwords
      pbpaste

      # check if Accessibility permission is granted to any app (enables keylogging)
      sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
        "SELECT client FROM access WHERE service='kTCCServiceAccessibility'" 2>/dev/null

      # ════════════════════════════════════════════════════════════════
      # PHASE 12 — PERSISTENCE REVIEW  →  macOS-Persistence.md
      # ════════════════════════════════════════════════════════════════

      # check all user persistence locations for writable entries
      ls -la ~/Library/LaunchAgents/
      ls -la ~/Library/Application\ Support/*/
      ls -la ~/.config/

      # login items (GUI persistence)
      osascript -e 'tell application "System Events" to get the name of every login item'

      # ════════════════════════════════════════════════════════════════
      # PHASE 13 — KERNEL / OS EXPLOITS  →  Linux-Kernel-Exploit.md
      # ════════════════════════════════════════════════════════════════

      # get exact macOS version for CVE lookup
      sw_vers -productVersion

      # notable macOS local privilege escalation CVEs:
      # CVE-2021-30892  — shrootkit (SIP bypass via system_installd)
      # CVE-2021-1782   — kernel race condition
      # CVE-2020-9934   — TCC bypass via user-writable containers
      # CVE-2019-8526   — launchd race condition

      # check if local privesc tools detect anything
      # macOS-specific: run sudo_killer, linPEAS with -a flag

      # ════════════════════════════════════════════════════════════════
      # PHASE 14 — AUTOMATED SCANNERS (run last — noisy)
      # ════════════════════════════════════════════════════════════════

      # linPEAS — works on macOS too, covers most checks above
      ./linpeas.sh

      # check for misconfigured sudoers, LaunchDaemons, weak file permissions
      find /Library/LaunchDaemons /etc/periodic -type f -writable 2>/dev/null
      find /usr/local/bin /usr/local/lib -type f -writable 2>/dev/null
phase:
  - PrivEsc
target_os:
  - macOS
services: []
techniques: []
references:
  - https://book.hacktricks.wiki/en/macos-hardening/macos-privilege-escalation/index.html
  - https://gtfobins.github.io/
  - https://github.com/peass-ng/PEASS-ng
  - https://www.apple.com/support/security/
---
