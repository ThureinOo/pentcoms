---
description: |
  WhatWeb identifies websites — CMS, blogging platforms, web frameworks, server software, and more. Use the results to guide further enumeration: Apache means look for PHP, IIS means look for asp/aspx, nginx means check for misconfigs.
command: |
  # Quick fingerprint
  whatweb http://10.10.10.27

  # Aggressive mode (more requests, more accurate)
  whatweb -a 3 http://10.10.10.27

  # Next steps based on results:
  # Apache → gobuster -x php,txt,bak
  # IIS → gobuster -x asp,aspx,config
  # nginx → check off-by-slash: curl http://target/static../etc/passwd
  # Tomcat → check /manager/html, default creds tomcat:tomcat
  # WordPress → wpscan --url http://target --enumerate ap,at,u
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
