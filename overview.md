---
layout: page
title: Overview
---

## How Senshu is Structured

Senshu is an interactive pentest command cheat sheet. Every entry is designed to answer one question: **"I'm at this stage, targeting this service, and I have this — what commands can I run?"**

---

### Filters

Senshu uses 5 filter groups. Select any combination to narrow down relevant commands.

#### 1. Phase — Where are you in the engagement?

| Phase | Description |
|---|---|
| **Reconnaissance** | Passive/active information gathering, port scanning, service discovery |
| **Enumeration** | Extracting detailed information from discovered services |
| **Exploitation** | Gaining access by exploiting vulnerabilities or using credentials |
| **Post-Exploitation** | Actions after gaining access — credential dumping, data collection |
| **Privilege Escalation** | Escalating from low-privileged user to root/SYSTEM/admin |
| **Persistence** | Maintaining access to the compromised environment |

#### 2. Target OS — What OS is the target running?

`Linux` | `Windows` | `macOS`

#### 3. Service — What service are you targeting?

Services represent network services or attack surfaces discovered during reconnaissance.

| Service | Port(s) | Service | Port(s) |
|---|---|---|---|
| SMB | 139, 445 | MSSQL | 1433 |
| HTTP | 80, 443, 8080, 8443 | MySQL | 3306 |
| SSH | 22 | SNMP | 161 |
| FTP | 21 | SMTP | 25, 587 |
| DNS | 53 | RPC | 135 |
| LDAP | 389, 636 | NFS | 2049 |
| Kerberos | 88 | VNC | 5900 |
| RDP | 3389 | Redis | 6379 |
| WinRM | 5985, 5986 | PostgreSQL | 5432 |
| ADCS | — (AD Certificate Services) | | |

#### 4. What You Have — What do you currently possess?

| Item | Meaning | Example use |
|---|---|---|
| **No Creds** | Nothing — unauthenticated | Anonymous SMB enum, nmap scanning |
| **Username** | Username only, no password | AS-REP Roasting, brute-force |
| **Password** | Password only, no username | Password spraying |
| **Credentials** | Username + password pair | Authenticated service access |
| **Hash** | NTLM or other password hash | Pass-the-Hash attacks |
| **TGT** | Kerberos Ticket Granting Ticket | Pass-the-Ticket |
| **TGS** | Kerberos service ticket | Offline cracking |
| **Certificate** | PFX/certificate file | PKINIT authentication |
| **Shell** | Shell access on the target | PrivEsc, post-exploitation |
| **SSH Key** | SSH private key | SSH login |
| **Token** | Access or session token | Token impersonation |
| **SPN** | Known Service Principal Name | Targeted Kerberoasting |

#### 5. Technique — What specific attack technique?

Technique buttons appear **dynamically** based on your other filter selections. For example:

- Select `Exploitation + HTTP` → Web techniques appear (SQLi, LFI, SSRF, SSTI, etc.)
- Select `Exploitation + Kerberos` → AD techniques appear (Kerberoasting, AS-REP Roasting, etc.)
- Select `Privilege Escalation + Windows` → Windows privesc techniques appear (UAC Bypass, Potato, DLL Hijack, etc.)
- Select `Privilege Escalation + Linux` → Linux privesc techniques appear (SUID, Sudo, Cron, Docker Escape, etc.)

Full technique list:

**Web Techniques:**
SQLi, LFI/RFI, Command Injection, File Upload, NoSQL Injection, XXE, SSRF, SSTI, Deserialization, IDOR, JWT Attack, API Testing, CORS Misconfig, WebSocket Attack, XSS, Open Redirect, Request Smuggling

**AD / Network Techniques:**
Kerberoasting, AS-REP Roasting, Pass-the-Hash, Pass-the-Ticket, NTLM Relay/Poisoning, DCSync, BloodHound, Password Spraying, ACL Abuse, ADCS Abuse, Shadow Credentials, Delegation Abuse, Ticket Forgery, GPP Passwords, LAPS Abuse, DNS Admin Abuse, CVE Exploit, RBCD

**Windows Post-Exploitation Techniques:**
AMSI Bypass, AppLocker Bypass, AV Evasion

**Windows Privilege Escalation Techniques:**
Service Exploit, Registry Exploit, UAC Bypass, DLL Hijack, Token Impersonation, AlwaysInstallElevated, Kernel Exploit

**Linux Privilege Escalation Techniques:**
SUID Abuse, Sudo Abuse, Cron Abuse, Capability Abuse, NFS Abuse, Kernel Exploit, Docker Escape, Wildcard Injection, LD_PRELOAD, Python Hijack, Writable Service

**macOS Privilege Escalation Techniques:**
TCC Bypass, Dylib Hijack, LaunchDaemon Abuse

---

### Search

The search box searches across **all command content and entry titles**. Type any command name (e.g., `nxc`, `certipy`, `gobuster`) to find entries containing that command. Search works alongside filters.

---

### How Entries Are Organized

Each entry represents **one service + one phase** (or one technique). Inside each entry, commands are grouped by **what you have**:

```
SMB - Enumeration
├── No Creds:      nxc smb, smbclient -L, smbmap, enum4linux
├── Username:      nxc smb --rid-brute
├── Credentials:   nxc smb --shares, smbclient -U, smbmap -u -p
└── Hash:          nxc smb -H --shares
```

When you apply a "What you have" filter on the main page, only the matching command section is shown. Click the entry title to see the **full detail page** with all command sections.

---

### Entry Categories

| Category | Count | How filtered |
|---|---|---|
| Reconnaissance | 3 | Phase: Reconnaissance |
| Service Enumeration | 19 | Phase: Enumeration + Service |
| Service Exploitation | 12 | Phase: Exploitation + Service |
| HTTP Exploitation (by technique) | 17 | Phase: Exploitation + Service: HTTP + Technique |
| AD / Network Techniques | 24 | Technique filter |
| Windows Privilege Escalation | 7 | Phase: PrivEsc + OS: Windows + Technique |
| Windows Post-Exploitation | 7 | Phase: Post-Exploitation + OS: Windows |
| Linux Privilege Escalation | 10 | Phase: PrivEsc + OS: Linux + Technique |
| macOS Privilege Escalation | 3 | Phase: PrivEsc + OS: macOS + Technique |
| Post-Exploitation (by OS) | 4 | Phase: Post-Exploitation + OS |
| Persistence (by OS) | 4 | Phase: Persistence + OS |
| General / Utility | 14 | Phase + search |
| **Total** | **118** | |

---

### Filter Layout

```
Row 1: [ What you have ]        [ Phase ]
Row 2: [ Target OS ]
Row 3: [ Service ]
Row 4: [ Technique ]  ← dynamic, shows only relevant buttons
Search: [ type command or keyword... ]
```

---

### Placeholder Values

Commands use these default placeholder values which can be replaced via the Settings panel:

| Placeholder | Default Value |
|---|---|
| Target IP | 10.10.10.27 |
| Attacker IP | 10.10.10.21 |
| Domain | senshu.local |
| Username | sec_user |
| Password | P@ssw0rd |

---

### Typical Workflow

**Scenario: You run nmap and find SMB (445) and HTTP (80) on a Windows target.**

1. Select `Enumeration` + `SMB` + `No Creds` → See all unauthenticated SMB enum commands
2. You find a username via RID brute-force. Select `Username` → See AS-REP Roasting, brute-force options
3. You crack a password. Select `Credentials` + `SMB` → See authenticated SMB access commands
4. You get a shell via psexec. Select `Privilege Escalation` + `Windows` → See all Windows privesc techniques
5. Select `Token Impersonation` technique → See Potato attacks specifically

**Scenario: You find a web application.**

1. Select `Reconnaissance` → See nmap, nikto, whatweb
2. Select `Enumeration` + `HTTP` → See gobuster, ffuf, feroxbuster
3. Select `Exploitation` + `HTTP` → Technique buttons appear: SQLi, LFI, SSRF, IDOR, JWT, etc.
4. Select `SQLi` → See sqlmap commands and manual injection techniques

**Scenario: You compromise a Linux host and need to escalate.**

1. Select `Privilege Escalation` + `Linux` → See all Linux privesc technique buttons
2. Select `SUID Abuse` → See SUID/sudo enumeration and GTFOBins exploitation
3. Select `Cron Abuse` → See crontab checks, pspy, PATH hijack, wildcard injection

---

### Contributing

See [Contribute](contribute) for the YAML format and guidelines for adding new entries.
