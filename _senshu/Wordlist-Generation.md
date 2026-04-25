---
description: |
  Wordlist generation techniques — CeWL website scraping, username generation from names, Crunch patterns, Hashcat rule-based expansion, and common wordlist locations.
command: |
  # CeWL — scrape website for words
  cewl http://10.10.10.27 -d 3 -m 5 -w wordlist.txt
  cewl http://10.10.10.27 --with-numbers -w wordlist.txt

  # Username generation from names
  username-anarchy --select-format first.last,flast,f.last names.txt > users.txt

  # Crunch — custom patterns
  crunch 8 8 -t P@ss%%^^ -o passwords.txt
  crunch 6 6 0123456789 -o pins.txt

  # Common wordlist locations
  /usr/share/wordlists/rockyou.txt
  /usr/share/wordlists/dirb/big.txt
  /usr/local/share/seclists/Discovery/Web-Content/big.txt
  /usr/local/share/seclists/Usernames/xato-net-10-million-usernames.txt
items:
  - No_Creds
phase:
  - Reconnaissance
target_os:
  - Linux
  - Windows
services: []
techniques: []
references:
  - https://github.com/digininja/CeWL
  - https://github.com/urbanadventurer/username-anarchy
  - https://hashcat.net/wiki/doku.php?id=rule_based_attack
---
