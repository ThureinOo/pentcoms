---
description: |
  PostgreSQL enumeration — version detection, default credential checks, and authenticated database access on port 5432.
commands:
  - have: No_Creds
    cmd: |
      # Nmap version detection and brute-force default credentials
      nmap -sV -p 5432 --script pgsql-brute 10.10.10.27

      # Try default credentials: postgres:postgres
      psql -h 10.10.10.27 -U postgres -d postgres
  - have: Credentials
    cmd: |
      # Connect with valid credentials
      psql -h 10.10.10.27 -U sec_user -d postgres

      # List all databases
      \l

      # List tables in current database
      \dt

      # List users and roles
      \du

      # List all non-system tables
      SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog';

      # Dump data from a table
      SELECT * FROM users;
phase:
  - Enumeration
target_os:
  - Linux
  - Windows
services:
  - PostgreSQL
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-postgresql.html
---
