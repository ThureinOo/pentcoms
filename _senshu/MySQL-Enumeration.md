---
description: |
  MySQL enumeration — service discovery, empty password checks, and authenticated database access on port 3306.
commands:
  - have: No_Creds
    cmd: |
      # Nmap scripts — version info, user enumeration, empty password check
      nmap -p 3306 --script mysql-info,mysql-enum,mysql-empty-password 10.10.10.27
  - have: Credentials
    cmd: |
      # Connect to MySQL with credentials
      mysql -h 10.10.10.27 -u sec_user -p

      # List all databases
      mysql> SHOW DATABASES;

      # Select a database
      mysql> USE dbname;

      # List all tables in current database
      mysql> SHOW TABLES;

      # Show table structure/columns
      mysql> DESCRIBE tablename;

      # Dump all rows from a table
      mysql> SELECT * FROM users;

      # Extract all MySQL user accounts and password hashes
      mysql> SELECT user, host, authentication_string FROM mysql.user;
phase:
  - Enumeration
target_os:
  - Linux
services:
  - MySQL
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-mysql.html
---
