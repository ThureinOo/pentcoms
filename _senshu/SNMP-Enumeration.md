---
description: |
  SNMP enumeration — community string discovery, MIB walking, and extraction of users, processes, and software on UDP port 161.
commands:
  - have: No_Creds
    cmd: |
      # Nmap SNMP scripts — brute community strings, info, processes, Windows users
      nmap -sU -p 161 --script snmp-brute,snmp-info,snmp-processes,snmp-win32-users 10.10.10.27

      # SNMP walk with v1
      snmpwalk -v 1 -c public 10.10.10.27

      # SNMP walk with v2c
      snmpwalk -v 2c -c public 10.10.10.27

      # Bulk walk (faster, v2c only)
      snmpbulkwalk -v 2c -c public 10.10.10.27

      # --- Specific OID queries ---
      # Enumerate Windows users
      snmpwalk -v 2c -c public 10.10.10.27 1.3.6.1.4.1.77.1.2.25

      # Enumerate running processes
      snmpwalk -v 2c -c public 10.10.10.27 1.3.6.1.2.1.25.4.2.1.2

      # Enumerate installed software
      snmpwalk -v 2c -c public 10.10.10.27 1.3.6.1.2.1.25.6.3.1.2

      # Enumerate TCP listening ports
      snmpwalk -v 2c -c public 10.10.10.27 1.3.6.1.2.1.6.13.1.3
phase:
  - Enumeration
target_os:
  - Linux
  - Windows
services:
  - SNMP
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-snmp/index.html
---
