# REPORT-08: Step 5, Enterprise Audit component install attempt (failed, parked, state restored)

This is NOT the planned filtered-audit run. The install of the audit component into schema ddv_sec failed; the documented uninstall script was run, ddv_sec was dropped and the end state equals the baseline. The filter setup, ddv_agent queries and log read-back were not done. See .local/BLOCKED.md (uncommitted) for the question parked for the author.
The commit message for this part differs from the one in the task, because the described result (filtered to ddv_agent, uninstalled) did not happen.

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
9d5105042ff317bc48cf7dbae04df836518e387bf0f90f4c34c9200ab749de44  evidence/54-after.txt
86b9b931ffc1b5f2402e25f1e48bedede79f52ca6e6a835383fa29efc3ba2ffe  evidence/54-audit-error-log.txt
d1e9df96224a290cbe503c0c7008fbf124223a6062aaffb1b55f0bba5a5d2568  evidence/54-audit-install.txt
73d36359007a1d00edaf1ddb0c2bf8e82c68c5c64862228611aa9a342efee067  evidence/54-audit-state.txt
7809db49939ea15237130a1ca14fff2c35064dcd63449d8f997612189d057a09  evidence/54-audit-uninstall.txt
3b96c0587eeb1b855b887cb30100388b0a406b0f42d50bc894ea1d674553900a  evidence/54-compare.txt
beb82f6fb128db18722e0c872ba70c879cdc15c2f6de7ef188a3e3583c81de4d  evidence/54-schema-create.txt
0fbfb28480d97a4cd0fd3471d370141dcc0593ed33b53e3e31ec91ff0a0cd3af  sql/54-audit-state.sql
94678d76ff2eeb93d7b3f9ed15288edba03a1d6c57f19b9f846716988d8a8430  sql/54-drop-schema.sql
2bd265848fe5f57d36d362b84c570b6055750341cd3d1c9f2243e379c72b4c83  sql/54-error-log.sql
```

## Evidence (verbatim)

### evidence/54-after.txt
````text
--------------
SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'ddv%'
--------------

+-------------+
| SCHEMA_NAME |
+-------------+
| ddv_mask    |
| ddv_support |
+-------------+
2 rows in set (0.006 sec)

--------------
SELECT policy_name FROM mysql.column_masking_policies ORDER BY 1
--------------

+-----------------+
| policy_name     |
+-----------------+
| mask_email      |
| mask_phone      |
| sup_mask_card   |
| sup_mask_email  |
| sup_mask_phone  |
| sup_mask_tax_id |
| sup_mask_upi    |
+-----------------+
7 rows in set (0.002 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+--------------------------------------------------------------------+
| Grants for ddv_agent@%                                             |
+--------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                              |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`       |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`          |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`        |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%` |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                     |
+--------------------------------------------------------------------+
6 rows in set (0.002 sec)

--------------
SHOW GRANTS FOR 'ddv_billing'@'%'
--------------

+----------------------------------------------------------------------+
| Grants for ddv_billing@%                                             |
+----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_billing`@`%`                              |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_billing`@`%`       |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_billing`@`%`          |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_billing`@`%`        |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_billing`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_billing`@`%`                     |
+----------------------------------------------------------------------+
6 rows in set (0.002 sec)

--------------
SHOW GRANTS FOR 'ddv_norole'@'%'
--------------

+---------------------------------------------------------------------+
| Grants for ddv_norole@%                                             |
+---------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_norole`@`%`                              |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_norole`@`%`       |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_norole`@`%`          |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_norole`@`%`        |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_norole`@`%` |
+---------------------------------------------------------------------+
5 rows in set (0.001 sec)

--------------
SELECT * FROM mysql.component
--------------

+--------------+--------------------+------------------------------------+
| component_id | component_group_id | component_urn                      |
+--------------+--------------------+------------------------------------+
|            1 |                  1 | file://component_masking           |
|            2 |                  2 | file://component_masking_functions |
|            3 |                  3 | file://component_object_policy     |
+--------------+--------------------+------------------------------------+
3 rows in set (0.002 sec)

--------------
SELECT PLUGIN_NAME, PLUGIN_STATUS FROM information_schema.PLUGINS WHERE PLUGIN_NAME LIKE '%audit%' OR PLUGIN_NAME LIKE '%firewall%'
--------------

Empty set (0.026 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

Empty set (0.052 sec)

--------------
SHOW VARIABLES LIKE '%audit%'
--------------

Empty set (0.040 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.007 sec)

Bye
````

### evidence/54-audit-error-log.txt
````text
--------------
SELECT LOGGED, PRIO, ERROR_CODE, SUBSYSTEM, DATA FROM performance_schema.error_log WHERE DATA LIKE '%audit%' ORDER BY LOGGED DESC LIMIT 8
--------------

+----------------------------+-------+------------+-----------+------------------------------------------------------------------------------------------+
| LOGGED                     | PRIO  | ERROR_CODE | SUBSYSTEM | DATA                                                                                     |
+----------------------------+-------+------------+-----------+------------------------------------------------------------------------------------------+
| 2026-11-03 04:35:53.768374 | Error | MY-015664  | Server    | Component audit_log reported: 'Failed to open 'mysql.audit_log_filter' audit_log table.' |
+----------------------------+-------+------------+-----------+------------------------------------------------------------------------------------------+
1 row in set (0.084 sec)

Bye
````

### evidence/54-audit-install.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
CREATE TABLE IF NOT EXISTS audit_log_filter(NAME VARCHAR(64) BINARY NOT NULL PRIMARY KEY, FILTER JSON NOT NULL) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 1 warning (0.346 sec)

--------------
CREATE TABLE IF NOT EXISTS audit_log_user(USER VARCHAR(32) BINARY NOT NULL, HOST VARCHAR(255) CHARACTER SET ASCII NOT NULL, FILTERNAME VARCHAR(64) BINARY NOT NULL, PRIMARY KEY (USER, HOST), FOREIGN KEY (FILTERNAME) REFERENCES audit_log_filter(NAME)) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 2 warnings (0.288 sec)

--------------
INSTALL COMPONENT "file://component_audit_log"
--------------

ERROR 3536 (HY000) at line 6: Initialization method provided by component 'audit_log' failed.
Bye
````

### evidence/54-audit-state.txt
````text
--------------
SELECT * FROM mysql.component
--------------

+--------------+--------------------+------------------------------------+
| component_id | component_group_id | component_urn                      |
+--------------+--------------------+------------------------------------+
|            1 |                  1 | file://component_masking           |
|            2 |                  2 | file://component_masking_functions |
|            3 |                  3 | file://component_object_policy     |
+--------------+--------------------+------------------------------------+
3 rows in set (0.003 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.011 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.008 sec)

--------------
SHOW FULL TABLES FROM ddv_sec
--------------

+-------------------+------------+
| Tables_in_ddv_sec | Table_type |
+-------------------+------------+
| audit_log_filter  | BASE TABLE |
| audit_log_user    | BASE TABLE |
+-------------------+------------+
2 rows in set (0.030 sec)

--------------
SHOW STATUS LIKE 'audit_log%'
--------------

Empty set (0.028 sec)

--------------
SHOW GRANTS FOR CURRENT_USER()
--------------

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for root@localhost                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `root`@`localhost` WITH GRANT OPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| GRANT ALLOW_NONEXISTENT_DEFINER,APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,CREATE_SPATIAL_REFERENCE_SYSTEM,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_PRIVILEGES,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,MANAGE_DATA_MASKING_POLICY,OPTIMIZE_LOCAL_TABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_ANY_DEFINER,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,TELEMETRY_LOG_ADMIN,TRANSACTION_GTID_TAG,XA_RECOVER_ADMIN ON *.* TO `root`@`localhost` WITH GRANT OPTION |
| GRANT PROXY ON ``@`` TO `root`@`localhost` WITH GRANT OPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
3 rows in set (0.008 sec)

Bye
````

### evidence/54-audit-uninstall.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- Audit Log Uninstallation script
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- 1. Drops the functions.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- 2. Drops the tables.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- 3. Uninstalls the component.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- Note: Please specify the schema name before
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- running the script using either -D or --database.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- Uninstall the component.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
UNINSTALL COMPONENT "file://component_audit_log"
--------------

ERROR 3537 (HY000) at line 12: Component specified by URN 'file://component_audit_log' to unload has not been loaded before.
--------------
-- Drop the tables.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
DROP TABLE IF EXISTS audit_log_user
--------------

Query OK, 0 rows affected (0.267 sec)

--------------
DROP TABLE IF EXISTS audit_log_filter
--------------

Query OK, 0 rows affected (0.112 sec)

Bye
--------------
DROP SCHEMA ddv_sec
--------------

Query OK, 0 rows affected (0.040 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SELECT * FROM mysql.component
--------------

+--------------+--------------------+------------------------------------+
| component_id | component_group_id | component_urn                      |
+--------------+--------------------+------------------------------------+
|            1 |                  1 | file://component_masking           |
|            2 |                  2 | file://component_masking_functions |
|            3 |                  3 | file://component_object_policy     |
+--------------+--------------------+------------------------------------+
3 rows in set (0.002 sec)

Bye
````

### evidence/54-compare.txt
````text
Compare-Object evidence\50-baseline.txt evidence\54-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).
(no differences)
````

### evidence/54-schema-create.txt
````text
--------------
CREATE SCHEMA ddv_sec
--------------

Query OK, 1 row affected (0.107 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

Bye
````

## Not captured

- Filter creation, filter assignment, ddv_agent queries under audit, audit_log_read output and the .local/audit-raw.txt scan: not done.
- Whether an audit log file remains in the Data folder: not checked (the Data folder was not listed, and the component never loaded).
- Where the failure comes from beyond the one error-log line was not investigated; no install into the mysql schema and no restart were tried, as instructed.
- The manual quotes (.local/manual-notes-step5.md) are uncommitted and relayed by web-fetch subagents.

## Observations (Claude Code's reading, not evidence)

- The install script created the two tables in ddv_sec (with warnings) and then failed at INSTALL COMPONENT; the error log line says the component tried to open mysql.audit_log_filter.
- The manual says audit_log.database defaults to mysql and is read only, and that a custom database can be given to the install script; on this server the script-in-custom-schema route did not make the component start.
- mysql.component was unchanged by the failed install; the uninstall script printed ERROR 3537 for UNINSTALL COMPONENT and then dropped both tables.
- The end state matches the baseline.
