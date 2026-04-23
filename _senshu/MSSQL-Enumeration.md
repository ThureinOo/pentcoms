---
description: |
  MSSQL enumeration — service discovery, NTLM info extraction, and authenticated database access on port 1433.
commands:
  - have: No_Creds
    cmd: |
      # Nmap scripts for MSSQL version info and NTLM authentication details
      nmap -p 1433 --script ms-sql-info,ms-sql-ntlm-info 10.10.10.27
  - have: Credentials
    cmd: |
      # Connect with Impacket mssqlclient
      impacket-mssqlclient 'sec_user:P@ssw0rd@10.10.10.27'

      # Check SQL Server version
      SQL> SELECT @@version;

      # List all databases
      SQL> SELECT name FROM sys.databases;

      # List all tables across databases
      SQL> SELECT * FROM information_schema.tables;

      # NetExec — validate MSSQL credentials
      nxc mssql 10.10.10.27 -u sec_user -p 'P@ssw0rd'

      # NetExec — run a query
      nxc mssql 10.10.10.27 -u sec_user -p 'P@ssw0rd' -q "SELECT @@version"
phase:
  - Enumeration
target_os:
  - Windows
services:
  - MSSQL
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-mssql-microsoft-sql-server/index.html
---
