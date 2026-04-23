---
description: |
  HTTP/HTTPS enumeration — directory brute-forcing, vhost fuzzing, CMS scanning, and content discovery on web services.
commands:
  - have: No_Creds
    cmd: |
      gobuster dir -u http://10.10.10.27 -w /usr/share/seclists/Discovery/Web-Content/big.txt
      gobuster dir -u http://10.10.10.27 -w /usr/share/seclists/Discovery/Web-Content/big.txt -x php,txt,zip,sql,asp,json
      ffuf -u http://10.10.10.27/FUZZ -w /usr/share/seclists/Discovery/Web-Content/big.txt
      ffuf -u http://10.10.10.27 -H "Host: FUZZ.senshu.sh" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -fs <default_size>
      feroxbuster -u http://10.10.10.27 -w /usr/share/seclists/Discovery/Web-Content/big.txt
      # Nested directory search (after finding /admin/):
      gobuster dir -u http://10.10.10.27/admin/ -w /usr/share/seclists/Discovery/Web-Content/big.txt
      # For port 8443 try HTTPS:
      # https://10.10.10.27:8443
      # WordPress scan:
      docker run -it --rm wpscanteam/wpscan --url http://10.10.10.27 --enumerate vp,vt,u
      # ALWAYS check page source for: admin, password, login, secret, key, .js files, commented-out sections
  - have: Credentials
    cmd: |
      gobuster dir -u http://10.10.10.27 -w /usr/share/seclists/Discovery/Web-Content/big.txt -c "session=<COOKIE_VALUE>"
      ffuf -u http://10.10.10.27/FUZZ -w /usr/share/seclists/Discovery/Web-Content/big.txt -H "Cookie: session=<COOKIE_VALUE>"
      docker run -it --rm wpscanteam/wpscan --url http://10.10.10.27 -U sec_user -P /usr/share/wordlists/rockyou.txt
phase:
  - Enumeration
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques: []
references:
  - https://github.com/OJ/gobuster
  - https://github.com/ffuf/ffuf
  - https://github.com/epi052/feroxbuster
  - https://github.com/wpscanteam/wpscan
---
