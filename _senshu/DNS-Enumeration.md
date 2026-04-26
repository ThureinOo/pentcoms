---
description: |
  DNS enumeration — zone transfers, record lookups, and subdomain discovery on port 53.
commands:
  - have: No_Creds
    cmd: |
      nmap -p 53 --script dns-zone-transfer,dns-nsid,dns-service-discovery 10.10.10.27
      dig axfr @10.10.10.27 senshu.local

      nslookup
      # > server 10.10.10.27
      # > senshu.local

      dnsenum --dnsserver 10.10.10.27 senshu.local

      # Subdomain fuzzing (if domain found):
      gobuster dns -d senshu.local -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -r 10.10.10.27:53
      ffuf -u http://FUZZ.senshu.local -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -fs <default_size>
phase:
  - Enumeration
target_os:
  - Linux
  - Windows
services:
  - DNS
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-dns.html
---
