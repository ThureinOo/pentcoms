---
description: |
  WhatWeb identifies websites — CMS, blogging platforms, web frameworks, server software, and more. Use the results to guide further enumeration: Apache means look for PHP, IIS means look for asp/aspx, nginx means check for misconfigs.
command: |
  # Basic Fingerprinting
  # Quick fingerprint:
  whatweb http://10.10.10.27

  # Verbose output (more detail):
  whatweb -v http://10.10.10.27

  # Aggressive Scanning
  # Aggressive mode (level 3 — makes additional requests, more accurate):
  whatweb -a 3 http://10.10.10.27

  # Stealthy mode (level 1 — single request per target):
  whatweb -a 1 http://10.10.10.27

  # HTTPS and Non-Standard Ports
  # HTTPS target:
  whatweb https://10.10.10.27

  # Non-standard port:
  whatweb http://10.10.10.27:8080

  # HTTPS on non-standard port:
  whatweb https://10.10.10.27:8443

  # Multiple Targets
  # Scan a range:
  whatweb 10.10.10.0/24

  # Scan from a file:
  whatweb -i targets.txt

  # Output Options
  # JSON output:
  whatweb -a 3 http://10.10.10.27 --log-json=whatweb.json

  # Verbose with log file:
  whatweb -v http://10.10.10.27 --log-verbose=whatweb.log

  # Custom User-Agent
  whatweb -U "Mozilla/5.0" http://10.10.10.27

  # Proxy Support
  # Scan through proxy (e.g., Burp):
  whatweb --proxy 127.0.0.1:8080 http://10.10.10.27

  # Web Server Identification Tips
  # If Apache is detected:
  #   - Look for PHP extensions (.php) in gobuster/feroxbuster
  #   - gobuster dir -u http://10.10.10.27 -w wordlist.txt -x php,txt,bak
  # If IIS is detected:
  #   - Look for asp/aspx extensions
  #   - gobuster dir -u http://10.10.10.27 -w wordlist.txt -x asp,aspx,config
  # If nginx is detected:
  #   - Check for misconfigurations (path traversal, alias misconfiguration)
  #   - Check for off-by-slash bugs: curl http://10.10.10.27/static../etc/passwd
  #   - gobuster dir -u http://10.10.10.27 -w wordlist.txt -x php,html
  # If Tomcat is detected:
  #   - Look for /manager/html, default creds (tomcat:tomcat)
  #   - gobuster dir -u http://10.10.10.27 -w wordlist.txt -x jsp,war
  # If WordPress is detected:
  #   - Run wpscan: wpscan --url http://10.10.10.27 --enumerate ap,at,u
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
  - https://github.com/urbanadventurer/WhatWeb
---
