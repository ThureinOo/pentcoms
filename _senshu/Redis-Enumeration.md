---
description: |
  Redis enumeration — unauthenticated and authenticated access to the Redis in-memory database on port 6379.
commands:
  - have: No_Creds
    cmd: |
      # Connect to Redis (no auth)
      redis-cli -h 10.10.10.27

      # Server information (version, OS, architecture)
      127.0.0.1:6379> INFO server

      # List databases and key counts
      127.0.0.1:6379> INFO keyspace

      # List all keys (select database with SELECT 0, SELECT 1, etc.)
      127.0.0.1:6379> SELECT 0
      127.0.0.1:6379> KEYS '*'

      # Get value of a specific key
      127.0.0.1:6379> GET keyname

      # Scan for keys matching a pattern (non-blocking alternative to KEYS)
      redis-cli -h 10.10.10.27 --scan --pattern '*'

      # Check working directory and dump file (useful for exploitation)
      127.0.0.1:6379> CONFIG GET dir
      127.0.0.1:6379> CONFIG GET dbfilename

      # List connected clients
      127.0.0.1:6379> CLIENT LIST

      # Nmap Redis info script
      nmap -p 6379 --script redis-info 10.10.10.27
  - have: Credentials
    cmd: |
      # Connect with authentication
      redis-cli -h 10.10.10.27 -a 'P@ssw0rd'

      # Same enumeration commands apply after authentication
      127.0.0.1:6379> INFO server
      127.0.0.1:6379> INFO keyspace
      127.0.0.1:6379> KEYS '*'
      127.0.0.1:6379> CONFIG GET dir
      127.0.0.1:6379> CONFIG GET dbfilename
      127.0.0.1:6379> CLIENT LIST
phase:
  - Enumeration
target_os:
  - Linux
services:
  - Redis
techniques: []
references:
  - https://book.hacktricks.wiki/en/network-services-pentesting/6379-pentesting-redis.html
---
