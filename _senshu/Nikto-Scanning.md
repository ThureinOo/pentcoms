---
description: |
  Nikto is a web server scanner that checks for dangerous files, outdated software, misconfigurations, and known vulnerabilities across HTTP/HTTPS services.
command: |
  # Basic scan
  nikto -h http://10.10.10.27

  # Multiple ports
  nikto -h 10.10.10.27 -p 80,443,8080,8443

  # Save report
  nikto -h http://10.10.10.27 -Format htm -o nikto_report.html

  # Tuning (1=Files 2=Misconfig 3=Info 4=XSS 5=Remote 6=DoS 7=Shell 8=CMDi 9=SQLi)
  nikto -h http://10.10.10.27 -Tuning 1234

  # Authenticated scan
  nikto -h http://10.10.10.27 -id sec_user:P@ssw0rd
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
