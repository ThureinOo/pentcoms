---
description: |
  FTP enumeration — anonymous login checks, file listing, and file transfer on port 21.
commands:
  - have: No_Creds
    cmd: |
      # Nmap FTP scripts — check anonymous access, bounce attack, vsftpd backdoor
      nmap -sCV -p 21 --script ftp-anon,ftp-bounce,ftp-vsftpd-backdoor 10.10.10.27

      # Connect as anonymous (use blank password or any email)
      ftp 10.10.10.27
      Name: anonymous
      Password: (leave blank or enter any email)

      # List all files including hidden ones
      ftp> ls -la

      # Switch to passive mode (helps bypass firewalls, may reveal hidden files)
      ftp> passive

      # Switch to binary mode for non-text files (executables, images, archives)
      ftp> binary

      # Disable interactive prompts for batch downloads
      ftp> prompt off

      # Download all files in current directory
      ftp> mget *
  - have: Credentials
    cmd: |
      # Connect with valid credentials
      ftp 10.10.10.27
      Name: sec_user
      Password: P@ssw0rd

      # Download a specific file
      ftp> get filename

      # Upload a file to the target
      ftp> put filename

      # Change local directory (where files download to)
      ftp> lcd /tmp

      # Disable interactive prompts and download everything
      ftp> prompt off
      ftp> mget *

      # List all files including hidden
      ftp> ls -la

      # Switch to binary mode before transferring non-text files
      ftp> binary
phase:
  - Enumeration
target_os:
  - Linux
  - Windows
services:
  - FTP
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-ftp/index.html
---
