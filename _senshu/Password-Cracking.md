---
description: |
  Crack password hashes offline with Hashcat and John the Ripper — NTLM, NTLMv2, Kerberoast, AS-REP, MD5, SHA256, bcrypt, and more. Includes common modes, rules, and quick lookup tips.
command: |
  # --- Hashcat ---
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt    # NTLM
  hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt    # NTLMv2
  hashcat -m 13100 hash.txt /usr/share/wordlists/rockyou.txt   # Kerberoast
  hashcat -m 18200 hash.txt /usr/share/wordlists/rockyou.txt   # AS-REP
  hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt       # MD5
  hashcat -m 1400 hash.txt /usr/share/wordlists/rockyou.txt    # SHA256
  hashcat -m 1700 hash.txt /usr/share/wordlists/rockyou.txt    # SHA512
  hashcat -m 3200 hash.txt /usr/share/wordlists/rockyou.txt    # bcrypt

  # Rules (append -r to any command above)
  -r /usr/share/hashcat/rules/best64.rule
  -r /usr/share/hashcat/rules/dive.rule
  -r /usr/share/hashcat/rules/OneRuleToRuleThemAll.rule

  # Show cracked / identify hash
  hashcat -m 1000 hash.txt --show
  hashcat --identify hash.txt
  hashid hash_value

  # --- John the Ripper ---
  john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
  john --format=krb5tgs hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
  john --format=krb5asrep hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
  john --show hash.txt

  # --- Hash extraction ---
  unshadow /etc/passwd /etc/shadow > unshadowed.txt
  zip2john file.zip > hash.txt
  ssh2john id_rsa > hash.txt
  keepass2john database.kdbx > hash.txt

  # --- Quick lookup (try before cracking) ---
  # https://ntlm.pw | https://crackstation.net
items:
  - Hash
  - TGS
phase:
  - Post-Exploitation
target_os:
  - Linux
  - Windows
services: []
techniques: []
references:
  - https://hashcat.net/wiki/doku.php?id=example_hashes
  - https://www.openwall.com/john/
---
