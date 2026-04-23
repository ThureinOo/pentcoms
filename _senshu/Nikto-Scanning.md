---
description: |
  Nikto is a web server scanner that checks for dangerous files, outdated software, misconfigurations, and known vulnerabilities across HTTP/HTTPS services.
command: |
  # Basic Scans
  # Default scan on HTTP:
  nikto -h http://10.10.10.27

  # Scan HTTPS target:
  nikto -h https://10.10.10.27

  # Scan non-standard port:
  nikto -h http://10.10.10.27:8080

  # Multiple Ports
  # Scan multiple ports at once:
  nikto -h 10.10.10.27 -p 80,443,8080,8443

  # SSL Options
  # Force SSL mode:
  nikto -h 10.10.10.27 -p 443 -ssl

  # Scan HTTPS on non-standard port:
  nikto -h 10.10.10.27 -p 8443 -ssl

  # Output and Reporting
  # Save results as HTML report:
  nikto -h http://10.10.10.27 -Format htm -o nikto_report.html

  # Save results as CSV:
  nikto -h http://10.10.10.27 -Format csv -o nikto_report.csv

  # Save results as XML:
  nikto -h http://10.10.10.27 -Format xml -o nikto_report.xml

  # Tuning — Specific Test Categories
  # Run specific test types (1=Files, 2=Misconfig, 3=Info, 4=XSS, 5=Remote retrieval, 6=DoS, 7=Remote shell, 8=Command injection, 9=SQL injection):
  nikto -h http://10.10.10.27 -Tuning 1234

  # Only check for XSS and SQL injection:
  nikto -h http://10.10.10.27 -Tuning 49

  # Proxy Support
  # Scan through a proxy (e.g., Burp Suite):
  nikto -h http://10.10.10.27 -useproxy http://127.0.0.1:8080

  # Virtual Host / Hostname
  # Scan with specific hostname (for vhosts):
  nikto -h http://10.10.10.27 -vhost senshu.sh

  # Evasion and Timeouts
  # Set timeout for slow targets:
  nikto -h http://10.10.10.27 -timeout 10

  # Use IDS evasion techniques (1-8):
  nikto -h http://10.10.10.27 -evasion 1

  # Authenticated Scan
  # Scan with cookies (post-login):
  nikto -h http://10.10.10.27 -id sec_user:P@ssw0rd

  # Common Combo
  # Full scan with output
  nikto -h http://10.10.10.27 -Format htm -o nikto_report.html
  # If HTTPS, also scan with SSL
  nikto -h https://10.10.10.27 -ssl -Format htm -o nikto_ssl_report.html
items:
  - No_Creds
phase:
  - Reconnaissance
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques: []
references:
  - https://github.com/sullo/nikto
---
