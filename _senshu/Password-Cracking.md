---
description: |
  Crack password hashes offline with Hashcat and John the Ripper — NTLM, NTLMv2, Kerberoast, AS-REP, MD5, SHA256, bcrypt, and more. Includes common modes, rules, and quick lookup tips.
command: |
  # Hashcat — Common Hash Modes
  # NTLM (mode 1000) — Windows local passwords:
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

  # NTLMv2 (mode 5600) — captured from Responder/relay:
  hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt
  hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

  # Kerberoast TGS-REP (mode 13100):
  hashcat -m 13100 tgs_hash.txt /usr/share/wordlists/rockyou.txt
  hashcat -m 13100 tgs_hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

  # AS-REP Roast (mode 18200):
  hashcat -m 18200 asrep_hash.txt /usr/share/wordlists/rockyou.txt
  hashcat -m 18200 asrep_hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

  # MD5 (mode 0):
  hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt

  # SHA1 (mode 100):
  hashcat -m 100 hash.txt /usr/share/wordlists/rockyou.txt

  # SHA256 (mode 1400):
  hashcat -m 1400 hash.txt /usr/share/wordlists/rockyou.txt

  # SHA512 (mode 1700):
  hashcat -m 1700 hash.txt /usr/share/wordlists/rockyou.txt

  # bcrypt (mode 3200) — slow, use smaller wordlist or targeted rules:
  hashcat -m 3200 hash.txt /usr/share/wordlists/rockyou.txt
  hashcat -m 3200 hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

  # NetNTLMv1 (mode 5500):
  hashcat -m 5500 hash.txt /usr/share/wordlists/rockyou.txt

  # MySQL SHA1 (mode 300):
  hashcat -m 300 hash.txt /usr/share/wordlists/rockyou.txt

  # MSSQL (mode 1731):
  hashcat -m 1731 hash.txt /usr/share/wordlists/rockyou.txt

  # Hashcat — Rule-Based Attacks
  # With best64 rule (fast, high hit rate):
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

  # With dive rule (thorough, slower):
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/dive.rule

  # With OneRuleToRuleThemAll (community rule, excellent coverage):
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/OneRuleToRuleThemAll.rule

  # Hashcat — Useful Options
  # Show cracked passwords:
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt --show

  # Force CPU (if no GPU):
  hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt --force

  # Identify hash type:
  hashcat --identify hash.txt
  hashid hash_value

  # John the Ripper
  # Basic wordlist attack:
  john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt

  # NTLM format:
  john --format=NT hash.txt --wordlist=/usr/share/wordlists/rockyou.txt

  # Kerberoast TGS:
  john --format=krb5tgs hash.txt --wordlist=/usr/share/wordlists/rockyou.txt

  # AS-REP:
  john --format=krb5asrep hash.txt --wordlist=/usr/share/wordlists/rockyou.txt

  # Show cracked passwords:
  john --show hash.txt

  # John with rules:
  john --wordlist=/usr/share/wordlists/rockyou.txt --rules=best64 hash.txt

  # Hash Extraction Helpers
  # Extract hashes from /etc/shadow:
  unshadow /etc/passwd /etc/shadow > unshadowed.txt
  john --wordlist=/usr/share/wordlists/rockyou.txt unshadowed.txt

  # Convert to john format (zip, ssh, keepass, etc.):
  zip2john file.zip > hash.txt
  ssh2john id_rsa > hash.txt
  keepass2john database.kdbx > hash.txt
  john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt

  # Quick Lookup — No Cracking Needed
  # Paste NTLM hash at https://ntlm.pw for instant lookup
  # Also try: https://crackstation.net
  # Works for common/weak passwords — always try before cracking

  # Quick Reference — Mode Cheat Sheet
  # Hashcat Mode | Hash Type
  # -m 0         | MD5
  # -m 100       | SHA1
  # -m 1000      | NTLM
  # -m 1400      | SHA256
  # -m 1700      | SHA512
  # -m 3200      | bcrypt
  # -m 5500      | NetNTLMv1
  # -m 5600      | NTLMv2 / NetNTLMv2
  # -m 13100     | Kerberoast (TGS-REP etype 23)
  # -m 18200     | AS-REP Roast
  # -m 22000     | WPA-PBKDF2-PMKID+EAPOL
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
