# REPORT-10: Step 7, masking, roles, Firewall and Audit active together

Step 7: masking policies, roles, the Firewall component (group `fw_agent` for `ddv_agent@%`, schema `ddv_sec`) and the Audit component (filter `agent_log` for `ddv_agent@%`, schema `mysql`) loaded together, then both uninstalled.

Order of the run: 70 baseline; Audit install, filter, status for root and ddv_agent; Firewall install, group, RECORDING with `agent/support_agent_stack.py`, PROTECTING, allowlist; 71 runs with `SHOW GLOBAL STATUS LIKE 'firewall%'` as root before and after each run; 72 Audit read; 73 teardown in the requested order and compare.

Reused scripts: `sql/60-audit-filter.sql`, `sql/60-audit-status.sql`, `sql/53-*.sql`, `sql/61-outofworkflow-N.sql`, `sql/61-tampering-N.sql`. The Audit and Firewall install and uninstall scripts come from the share folder of the server and are not copied.

Part 0 (Step 5 counter): in `evidence/53-firewall-protecting.txt` each of the five denied statements appears once, each with one ERROR 6444 line. The files alone do not show why `firewall_access_denied` was 10. In this run the denied counter rose by 2 per run (see the status files), and the Audit extract shows two statements with status 6444 per run: `select @@version_comment limit 1` and the statement itself.

Disclosed deviations: (1) the first Part 3 loop had an array-flattening bug in my script; it created four status files (`71-stack-q-*`, `71-stack-a-*`, both at denied 0 and granted 14, no statement between) and ran nothing against the agent; I deleted those four uncommitted files before this report. The four scripted questions were then run after the nine statements, not before, as `71-stack-questions.txt`. (2) The `71-stack-*.txt` runs were redirected without stderr, so they contain no ERROR lines; the nine ERROR 6444 lines were seen on the console only. The denial is in the status files and in `evidence/72-stack-audit-extract.txt`. The same stderr omission applies to the Step 6 files `evidence/61-outofworkflow-*.txt` and `61-tampering-*.txt`. (3) `evidence/71-stack-llm-context.txt` was written by both the RECORDING run and the PROTECTING run; the file is from the later run. (4) The compare in `73-compare.txt` lists one difference: the processlist row of the capturing session itself (connection id and port).

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
3a22e1b0b4aa4239fab3e56583ae21dd337cd8a144011cd4599db5f7d9a4fb45  agent/support_agent_stack.py
8763b923a5fd18eddb68e7c4c27a8747c50a63e2dc27b3b573d00061eec530f2  evidence/70-audit-filter.txt
c491234501e5ecea8f84ad776fe2436801e84945049b0a91ed646892aa887677  evidence/70-audit-install.txt
f0ed849302e4c57bdef9d974a137666dcd122c80593a8d6d263a7d3d32fa5e40  evidence/70-baseline.txt
f70da63191fa09af4b2c7077259381447a3ef5d1706a7555203c509d85d57b3b  evidence/70-status-agent.txt
ff0dbb3c838699c49e3aa81f0c687016be0b9a62d7ee51d7694faf44769d7138  evidence/70-status-root.txt
706c29dc0997a3af9814d5e31d675b0966cd55a68c091a3b7905075faa16d68b  evidence/71-fw-allowlist.txt
bb75d1fcd792b8158026f4f891f1d1632cab981f6a1535aeccfadabab15fbdf3  evidence/71-fw-enlist.txt
d6628d5a452652c75433ce7dbbe32aa82e537ccef8a353cd63cf32614006f538  evidence/71-fw-install.txt
cfc3a5d47a3521e78bbe0932732d1712bc4a6f32bd3d83a8a40a956bb40ec7f8  evidence/71-fw-protecting-start.txt
552149b5b0acbf1cc6466232b1057be72ca9fc5db447e00c6b630355cedaee89  evidence/71-fw-recording.txt
c5c009271a37b2a39218338e1ef70ca983ed6ba7cbf7a0b2907f0c7285e41790  evidence/71-fw-schema-create.txt
ecd3a4dbf96135d349f8338f335645c31ce51a3da16af510174b5d22d03889fc  evidence/71-fw-state.txt
faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671  evidence/71-stack-llm-context.txt
2ddc8564f16c525bcf9c462aca76f22691992f92043cc503eb2737ae4ed56442  evidence/71-stack-ow1.txt
96538e62e1acfb0df03a644a2fa39ef1fb74cad813e5b23b544a4a2818ac4efe  evidence/71-stack-ow1-status-after.txt
0a0897a6e82ae0378e584ee060a610f7555091f4157c210427a800fbc33d0ad0  evidence/71-stack-ow1-status-before.txt
0e081ba671874710b873fd4d4ee0d888a4f15eb6000211e0a0ce5388b04d1259  evidence/71-stack-ow2.txt
5be4c44194b3d4810dbee3fcebd503ea5ce9773ecf4035b6b1e51f4f6bbe1116  evidence/71-stack-ow2-status-after.txt
daf3361058e6df36623ea296f1fe44b58fe5d823ed59888c96d1314193a502e4  evidence/71-stack-ow2-status-before.txt
1e0dc0ca3dad3af740f35e05da5d05c9c8f55e954c2b3e4c35ccf7500e30145c  evidence/71-stack-ow3.txt
40bc8547d7a9c0ecc627fa4e90ccc2b46cbac307ff236a32a3153ca99fc3b947  evidence/71-stack-ow3-status-after.txt
9f2fc959d064e2dfb504c4d23c18cb17a8b7928dd4ea2038f85077be47fdb73f  evidence/71-stack-ow3-status-before.txt
796a6366ca02258899a8486a87a77839b5634b862a29bd88eafd6748253da4e0  evidence/71-stack-ow4.txt
ca693420479b9e255c31f2f0c833418a92babd8043b97523ff373195caf1b3f1  evidence/71-stack-ow4-status-after.txt
b0d3f8ae9875b3de48d4b6a6ac5f5d7b3343b239e5b2fe294145f88a8079b3e6  evidence/71-stack-ow4-status-before.txt
5d5756ea6d49c3c4ceb62864eba1e746ec5d440b51b7badc3ebd92b0912d5914  evidence/71-stack-ow5.txt
6aab4a4ab8fe4e34230f32a74a9ebb1d5b28dcf4d71f164c814b78a18fb1bf26  evidence/71-stack-ow5-status-after.txt
ca693420479b9e255c31f2f0c833418a92babd8043b97523ff373195caf1b3f1  evidence/71-stack-ow5-status-before.txt
47ff05288149476250a9168e2e02e7768e7f275fa89dbee4d694ad3cda374a5d  evidence/71-stack-questions.txt
c912f61ad8b3cd6dd26147fd2aea2ec1ed7b57da64960a77266128422898a8f0  evidence/71-stack-questions-status-after.txt
7ef21d70408bf6656c07037ec936c24556e2ec063824955b4c9d331e010eca31  evidence/71-stack-questions-status-before.txt
47ff05288149476250a9168e2e02e7768e7f275fa89dbee4d694ad3cda374a5d  evidence/71-stack-recording-run.txt
f915dc319e5c36b2906dce3e64e6795ced82c502c366de61c64c44cd45c794af  evidence/71-stack-tamp1.txt
dbfc35cced8b5c4a1cef03edb9d69649a4d2901a8bfdd88c8be6d4c14e84befb  evidence/71-stack-tamp1-status-after.txt
46bac00644a127709cba1cdad12aee73e099f7a2fbce00729bbbf94a4fce5798  evidence/71-stack-tamp1-status-before.txt
b92b96a5c6b0b995a3329cdb922561929be901eeb0e5c6bf16204c8351bd6469  evidence/71-stack-tamp2.txt
d9eeb53e997f12e44c45bf4e185d5f02cb28ad3ccb4d12cac3bb4c8963a497a5  evidence/71-stack-tamp2-status-after.txt
3944dfa608a49bd67b53abaced540d7db9b6a311b8570ec0e3d41068d777cbb7  evidence/71-stack-tamp2-status-before.txt
e9b2651a6c5e28eba0ded3741d332a3b8fec1e96a729e6ca11b275a5b9ed9899  evidence/71-stack-tamp3.txt
e44f53ae9356c387e77c56645591d14ac909a5021468d1d0f805837835b1b977  evidence/71-stack-tamp3-status-after.txt
5388fc414de502d2b8318ecf676b1681157e349e87b34fcbcf883399d2c8506c  evidence/71-stack-tamp3-status-before.txt
7d860a2274d11565ee92babbdbac9eedaa59cceb03ed09ac332da96ad68301d5  evidence/71-stack-tamp4.txt
536acbe23e7479768be9ac8d98f796e51a5867154c94ffb9e810a6d55242765f  evidence/71-stack-tamp4-status-after.txt
55dbb8dd927e4a21bf4e14b20ccebcba49b3bf726898e50084424be880081963  evidence/71-stack-tamp4-status-before.txt
64579fa89934b29f1349271fc233b3fc91555c3f5696242924d8dc59c615eb8d  evidence/72-stack-audit-extract.txt
2a0993c402a92eb7c64b8d94cd9789f7b58435b868f3c2f73c857a926547d515  evidence/73-after.txt
4b1a6ea9abf46cfb83338b25eb7a4a0a37ba25aa7b6726238d64b25b87f8a203  evidence/73-audit-remove.txt
47a47d249eacd3873ded8e0ed1d0c14f0ea964300570696b109bede3039e2b04  evidence/73-audit-uninstall.txt
b8fc4adcb578e0f4ab9086565cf91806ee3ba19f10b2ccbedd4d4d58b42f63c4  evidence/73-compare.txt
2413728ae8557781d403ce511352930f6e86d45939655964dd48a07e45557540  evidence/73-drop-schema.txt
f058de9aa86ee4d084771e77023fd94538c6e8cf2449fd87ce7bdb2dd958916f  evidence/73-fw-group-teardown.txt
e2b2ffe5d163e2be14e0ab5afaafa2c36cb0e121549029f8b8dea66499e01158  evidence/73-fw-uninstall.txt
3550030ebf48575ba0eda57b38e77db98e6921cd944d6f36d20abe3a2480807d  evidence/73-grants-check.txt
2358ceba57124f6155ce214847b830be6d3bed78b225c1f337bb486a8181101e  evidence/73-precheck.txt
e98b7c17a8d375e03d907cab652a3289b46c1e9f02344f6e6c9afd840852588b  evidence/73-reset-persist.txt
4721672cf159c566ffb98855e3f7ad28295289d5309cdf76b2cd5f850331797b  sql/70-snapshot.sql
6311926eb7342d1acd171ce34635739aad3351031e5766706eb9520bb33c3afb  sql/71-fw-status.sql
85341c846e3d00e26b4bf65182fc6eb8addcd0814837056d42ba480471eb2986  sql/73-audit-remove.sql
5229957f91af9d92915dfe0a76a7352a81e1369cf626555fce893334fd3edb18  sql/73-drop-schema.sql
f41121a7293b208ada1ced5a4f9ad35ec0fa01720bd390c6187d177c0b660342  sql/73-fw-group-teardown.sql
10db481151c0ed792631c9a479cf5c751b98aae186bf7ed50b6b6271f44ab119  sql/73-grants-check.sql
c9fd76a0b9242d6aacbddf2bb86ece8daffeebb6ae8ec58d82a019a4b09cf3d3  sql/73-precheck.sql
```

## Evidence (verbatim)

### evidence/70-audit-filter.txt
````text
--------------
SELECT audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }')
--------------

+---------------------------------------------------------------------------+
| audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }') |
+---------------------------------------------------------------------------+
| OK                                                                        |
+---------------------------------------------------------------------------+
1 row in set (0.060 sec)

--------------
SELECT audit_log_filter_set_user('ddv_agent@%', 'agent_log')
--------------

+-------------------------------------------------------+
| audit_log_filter_set_user('ddv_agent@%', 'agent_log') |
+-------------------------------------------------------+
| OK                                                    |
+-------------------------------------------------------+
1 row in set (0.024 sec)

--------------
SELECT * FROM mysql.audit_log_filter
--------------

+-----------+---------------------------+
| NAME      | FILTER                    |
+-----------+---------------------------+
| agent_log | {"filter": {"log": true}} |
+-----------+---------------------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM mysql.audit_log_user
--------------

+-----------+------+------------+
| USER      | HOST | FILTERNAME |
+-----------+------+------------+
| ddv_agent | %    | agent_log  |
+-----------+------+------------+
1 row in set (0.003 sec)

Bye
````

### evidence/70-audit-install.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
CREATE TABLE IF NOT EXISTS audit_log_filter(NAME VARCHAR(64) BINARY NOT NULL PRIMARY KEY, FILTER JSON NOT NULL) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 1 warning (0.545 sec)

Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
--------------
CREATE TABLE IF NOT EXISTS audit_log_user(USER VARCHAR(32) BINARY NOT NULL, HOST VARCHAR(255) CHARACTER SET ASCII NOT NULL, FILTERNAME VARCHAR(64) BINARY NOT NULL, PRIMARY KEY (USER, HOST), FOREIGN KEY (FILTERNAME) REFERENCES audit_log_filter(NAME)) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 2 warnings (0.361 sec)

Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
--------------
INSTALL COMPONENT "file://component_audit_log"
--------------

Query OK, 0 rows affected (0.348 sec)

Bye
````

### evidence/70-baseline.txt
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
3 rows in set (0.109 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.145 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.315 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.027 sec)

--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
| 162 | root            | localhost:60932 | Query   |
|   7 | event_scheduler | localhost       | Daemon  |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.064 sec)

Bye
````

### evidence/70-status-agent.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 1713  |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 51    |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 4     |
| audit_log.file_count           | 2     |
| audit_log.filter_id            | 1     |
| audit_log.total_size           | 41653 |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.023 sec)

Bye
````

### evidence/70-status-root.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 477   |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 37    |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 1     |
| audit_log.file_count           | 2     |
| audit_log.filter_id            | 0     |
| audit_log.total_size           | 40417 |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.070 sec)

Bye
````

### evidence/71-fw-allowlist.txt
````text
--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NAME     | RULE                                                                                                                                                                                                                                                                               |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| fw_agent | SELECT @@SESSION . `sql_mode`                                                                                                                                                                                                                                                      |
| fw_agent | SELECT RIGHT ( `phone` , ? ) = ? AS `matches` FROM `ddv_support` . `customers` WHERE `id` = ?                                                                                                                                                                                      |
| fw_agent | SELECT `id` , STATUS , `total_amount` , `created_at` FROM `ddv_support` . `orders` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                           |
| fw_agent | SELECT `id` , SUBJECT , `notes` FROM `ddv_support` . `support_tickets` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                                       |
| fw_agent | SELECT `id` , `full_name` , `phone` , `email` , `tax_id` FROM `ddv_support` . `customers` WHERE `full_name` = ?                                                                                                                                                                    |
| fw_agent | SELECT `p` . `id` , `p` . `order_id` , `p` . `method` , `p` . `card_number` , `p` . `upi_id` , `p` . `status` , `o` . `status` AS `order_status` FROM `ddv_support` . `payments` `p` JOIN `ddv_support` . `orders` `o` ON `o` . `id` = `p` . `order_id` WHERE `p` . `order_id` = ? |
| fw_agent | SET @@SESSION . `autocommit` = OFF                                                                                                                                                                                                                                                 |
| fw_agent | SET NAMES ? COLLATE ?                                                                                                                                                                                                                                                              |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
8 rows in set (0.007 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------------+-------------+
| NAME     | MODE       | USERHOST    |
+----------+------------+-------------+
| fw_agent | PROTECTING | ddv_agent@% |
+----------+------------+-------------+
1 row in set (0.004 sec)

--------------
SHOW STATUS LIKE '%firewall%'
--------------

+----------------------------------------------------+-------+
| Variable_name                                      | Value |
+----------------------------------------------------+-------+
| firewall_access_denied                             | 0     |
| firewall_access_granted                            | 14    |
| firewall_access_suspicious                         | 0     |
| firewall_cached_entries                            | 8     |
| option_tracker_usage:Enterprise Firewall component | 12    |
+----------------------------------------------------+-------+
5 rows in set (0.008 sec)

Bye
````

### evidence/71-fw-enlist.txt
````text
--------------
CALL ddv_sec.sp_firewall_group_enlist('fw_agent', 'ddv_agent@%')
--------------

Query OK, 0 rows affected (0.059 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.007 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+-----------+-------------+
| NAME     | MODE      | USERHOST    |
+----------+-----------+-------------+
| fw_agent | RECORDING | ddv_agent@% |
+----------+-----------+-------------+
1 row in set (0.010 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

+----------+-------------+
| GROUP_ID | MEMBER_ID   |
+----------+-------------+
| fw_agent | ddv_agent@% |
+----------+-------------+
1 row in set (0.008 sec)

Bye
````

### evidence/71-fw-install.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# This script installs Enterprise Firewall component
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# altogether with needed tables and stored procedures.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
#
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# The tables and procedures will be located in the current database.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# @@component_firewall.database will be set to the current database
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# and persisted.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# Create tables
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
CREATE TABLE IF NOT EXISTS firewall_group_allowlist(
  NAME VARCHAR(288) NOT NULL,
  RULE text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
) engine=InnoDB
--------------

Query OK, 0 rows affected, 2 warnings (0.362 sec)

Warning (Code 1287): 'utf8mb3' is deprecated and will be removed in a future release. Please use utf8mb4 instead
Warning (Code 3778): 'utf8mb3_bin' is a collation of the deprecated character set UTF8MB3. Please consider using UTF8MB4 with an appropriate collation instead.
--------------
CREATE TABLE IF NOT EXISTS firewall_groups(
  NAME VARCHAR(288) PRIMARY KEY,
  MODE ENUM ('OFF', 'RECORDING', 'PROTECTING', 'DETECTING') NOT NULL DEFAULT 'OFF',
  USERHOST VARCHAR(288)
) engine=InnoDB
--------------

Query OK, 0 rows affected (0.360 sec)

--------------
CREATE TABLE IF NOT EXISTS firewall_membership(
  GROUP_ID VARCHAR(288),
  MEMBER_ID VARCHAR(288),
  PRIMARY KEY(GROUP_ID, MEMBER_ID)
) engine=InnoDB
--------------

Query OK, 0 rows affected (0.342 sec)

--------------
# install the component
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
INSTALL COMPONENT 'file://component_firewall' SET
  PERSIST component_firewall.database = DATABASE()
--------------

Query OK, 0 rows affected (0.360 sec)

--------------
# Create procedures
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
# switches group operational mode, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_set_firewall_group_mode (IN arg_group_name VARCHAR(288), IN arg_mode varchar(12))
BEGIN
  DECLARE result VARCHAR(160);
  DECLARE prev_mode VARCHAR(12);
  DECLARE prev_user VARCHAR(288);
  DECLARE reset_done BOOLEAN DEFAULT False;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      # restore the original mode after error
      IF (@prev_mode IS NOT NULL) THEN
        SELECT set_firewall_group_mode(arg_group_name, @prev_mode, IF(@prev_user IS NOT NULL, @prev_user, '')) INTO result;
      END IF;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  # store the current mode and user before proceeding
  SET @prev_mode = (SELECT mode FROM performance_schema.firewall_groups WHERE name = arg_group_name);
  SET @prev_user = (SELECT userhost FROM performance_schema.firewall_groups WHERE name = arg_group_name);

  # reload from permanent storage before switching the mode
  IF arg_mode = "RECORDING" THEN
    SELECT read_firewall_group_allowlist(arg_group_name,FW.rule) FROM firewall_group_allowlist FW WHERE name = arg_group_name;
  END IF;

  # set new mode
  SELECT set_firewall_group_mode(arg_group_name, arg_mode) INTO result;

  # after setting mode to RESET, mode will actually switch to OFF after success
  IF arg_mode = "RESET" THEN
    DELETE FROM firewall_group_allowlist WHERE name = arg_group_name;
    SET arg_mode = "OFF";
    SET reset_done = True;
  END IF;

  # on successful update, update users table information as well
  IF result = "OK" THEN
    INSERT INTO firewall_groups VALUES (arg_group_name, arg_mode, NULL) ON DUPLICATE KEY UPDATE mode = arg_mode;
  ELSE
    SELECT result;
  END IF;

  # update permanent queries list if switching to non-recording mode
  IF arg_mode = "PROTECTING" OR arg_mode = "DETECTING" OR (arg_mode = "OFF" AND reset_done = False) THEN
    INSERT INTO firewall_group_allowlist(name, rule)
    (
      SELECT name, rule FROM performance_schema.firewall_group_allowlist WHERE name=arg_group_name
      EXCEPT
      SELECT name, rule FROM firewall_group_allowlist WHERE name = arg_group_name
    );
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.234 sec)

--------------
# switches group operational mode, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_set_firewall_group_mode_and_user (IN arg_group_name VARCHAR(288), IN arg_mode varchar(12), IN arg_userhost VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);
  DECLARE prev_mode VARCHAR(12);
  DECLARE prev_user VARCHAR(288);
  DECLARE reset_done BOOLEAN DEFAULT False;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      # restore the original mode after error
      IF (@prev_mode IS NOT NULL) THEN
        SELECT set_firewall_group_mode(arg_group_name, @prev_mode, IF(@prev_user IS NOT NULL, @prev_user, '')) INTO result;
      END IF;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  # store the current mode and user before proceeding
  SET @prev_mode = (SELECT mode FROM performance_schema.firewall_groups WHERE name = arg_group_name);
  SET @prev_user = (SELECT userhost FROM performance_schema.firewall_groups WHERE name = arg_group_name);

  # reload from permanent storage before switching the mode
  IF arg_mode = "RECORDING" THEN
    SELECT read_firewall_group_allowlist(arg_group_name,FW.rule) FROM firewall_group_allowlist FW WHERE name = arg_group_name;
  END IF;

  # set new mode
  SELECT set_firewall_group_mode(arg_group_name, arg_mode, arg_userhost) INTO result;

  # after setting mode to RESET, mode will actually switch to OFF after success
  IF arg_mode = "RESET" THEN
    DELETE FROM firewall_group_allowlist WHERE name = arg_group_name;
    SET arg_mode = "OFF";
    SET reset_done = True;
  END IF;

  # on successful update, update users table information as well
  IF result = "OK" THEN
    INSERT INTO firewall_groups VALUES (arg_group_name, arg_mode, arg_userhost) ON DUPLICATE KEY UPDATE mode=arg_mode, userhost=arg_userhost;
  ELSE
    SELECT result;
  END IF;

  # update permanent queries list if switching to non-recording mode
  IF arg_mode = "PROTECTING" OR arg_mode = "DETECTING" OR (arg_mode = "OFF" AND reset_done = False) THEN
    INSERT INTO firewall_group_allowlist(name, rule)
    (
      SELECT name, rule FROM performance_schema.firewall_group_allowlist WHERE name=arg_group_name
      EXCEPT
      SELECT name, rule FROM firewall_group_allowlist WHERE name = arg_group_name
    );
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.037 sec)

--------------
# rebuilds in-memory cache of particular user firewall rules
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_reload_firewall_group_rules(IN arg_group_name VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);
  DECLARE prev_mode VARCHAR(12);
  DECLARE prev_user VARCHAR(288);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT 'Reload failed, the cache for the group is in unknown state. Consider reloading the firewall component.';
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  # store the current mode and user before proceeding
  SET @prev_mode = (SELECT mode FROM performance_schema.firewall_groups WHERE name = arg_group_name);
  SET @prev_user = (SELECT userhost FROM performance_schema.firewall_groups WHERE name = arg_group_name);

  # clear query memory cache for particular group
  SELECT set_firewall_group_mode(arg_group_name, "RESET") INTO result;

  IF result = "OK" THEN
    INSERT INTO firewall_groups VALUES (arg_group_name, "OFF", NULL) ON DUPLICATE KEY UPDATE mode="OFF";
    # rebuild cache from permanent query storage
    SELECT read_firewall_group_allowlist(arg_group_name,FW.rule) FROM firewall_group_allowlist FW WHERE FW.name=arg_group_name;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.030 sec)

--------------
# enlists user to a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_enlist(IN arg_group_name VARCHAR(288), IN arg_userhost VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT firewall_group_delist(arg_group_name, arg_userhost) INTO result;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_enlist(arg_group_name, arg_userhost) INTO result;
  IF result = "OK" THEN
    INSERT IGNORE INTO firewall_membership VALUES (arg_group_name, arg_userhost);
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.070 sec)

--------------
# removes user from a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_delist(IN arg_group_name VARCHAR(288), IN arg_userhost VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT firewall_group_enlist(arg_group_name, arg_userhost) INTO result;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_delist(arg_group_name, arg_userhost) INTO result;
  IF result = "OK" THEN
    DELETE IGNORE FROM firewall_membership WHERE group_id = arg_group_name AND member_id = arg_userhost;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.045 sec)

--------------
# renames a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_rename(IN arg_group_old_name VARCHAR(288), IN arg_group_new_name VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT firewall_group_rename(arg_group_new_name, arg_group_old_name) INTO result;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_rename(arg_group_old_name, arg_group_new_name) INTO result;
  IF result = "OK" THEN
    UPDATE firewall_groups SET NAME = arg_group_new_name WHERE NAME = arg_group_old_name;
    UPDATE firewall_membership SET GROUP_ID = arg_group_new_name WHERE GROUP_ID = arg_group_old_name;
    UPDATE firewall_group_allowlist SET NAME = arg_group_new_name WHERE NAME = arg_group_old_name;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.041 sec)

--------------
# removes a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_remove(IN arg_group_name VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT 'Group removal failed, the cache changes cannot be undone, reload the component to reload the cache.';
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_remove(arg_group_name) INTO result;
  IF result LIKE "OK%" THEN
    DELETE FROM firewall_group_allowlist WHERE NAME = arg_group_name;
    DELETE FROM firewall_membership WHERE GROUP_ID = arg_group_name;
    DELETE FROM firewall_groups WHERE NAME = arg_group_name;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.038 sec)

Bye
````

### evidence/71-fw-protecting-start.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'PROTECTING')
--------------

Query OK, 0 rows affected (0.146 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------------+-------------+
| NAME     | MODE       | USERHOST    |
+----------+------------+-------------+
| fw_agent | PROTECTING | ddv_agent@% |
+----------+------------+-------------+
1 row in set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NAME     | RULE                                                                                                                                                                                                                                                                               |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| fw_agent | SELECT @@SESSION . `sql_mode`                                                                                                                                                                                                                                                      |
| fw_agent | SELECT RIGHT ( `phone` , ? ) = ? AS `matches` FROM `ddv_support` . `customers` WHERE `id` = ?                                                                                                                                                                                      |
| fw_agent | SELECT `id` , STATUS , `total_amount` , `created_at` FROM `ddv_support` . `orders` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                           |
| fw_agent | SELECT `id` , SUBJECT , `notes` FROM `ddv_support` . `support_tickets` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                                       |
| fw_agent | SELECT `id` , `full_name` , `phone` , `email` , `tax_id` FROM `ddv_support` . `customers` WHERE `full_name` = ?                                                                                                                                                                    |
| fw_agent | SELECT `p` . `id` , `p` . `order_id` , `p` . `method` , `p` . `card_number` , `p` . `upi_id` , `p` . `status` , `o` . `status` AS `order_status` FROM `ddv_support` . `payments` `p` JOIN `ddv_support` . `orders` `o` ON `o` . `id` = `p` . `order_id` WHERE `p` . `order_id` = ? |
| fw_agent | SET @@SESSION . `autocommit` = OFF                                                                                                                                                                                                                                                 |
| fw_agent | SET NAMES ? COLLATE ?                                                                                                                                                                                                                                                              |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
8 rows in set (0.002 sec)

Bye
````

### evidence/71-fw-recording.txt
````text
--------------
GRANT FIREWALL_ADMIN ON *.* TO 'root'@'localhost'
--------------

Query OK, 0 rows affected (0.212 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
CALL ddv_sec.sp_set_firewall_group_mode_and_user('fw_agent', 'RECORDING', 'ddv_agent@%')
--------------

+-------------------------------------------------------+
| read_firewall_group_allowlist(arg_group_name,FW.rule) |
+-------------------------------------------------------+
| Rules added: 0, already existed: 0.                   |
+-------------------------------------------------------+
1 row in set (0.090 sec)

Query OK, 0 rows affected (0.146 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+-----------+-------------+
| NAME     | MODE      | USERHOST    |
+----------+-----------+-------------+
| fw_agent | RECORDING | ddv_agent@% |
+----------+-----------+-------------+
1 row in set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

Empty set (0.009 sec)

Bye
````

### evidence/71-fw-schema-create.txt
````text
--------------
CREATE SCHEMA ddv_sec
--------------

Query OK, 1 row affected (0.139 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

Bye
````

### evidence/71-fw-state.txt
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
|            7 |                  7 | file://component_audit_log         |
|            8 |                  8 | file://component_firewall          |
+--------------+--------------------+------------------------------------+
5 rows in set (0.003 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

+--------------------------------------------+---------+
| Variable_name                              | Value   |
+--------------------------------------------+---------+
| component_firewall.database                | ddv_sec |
| component_firewall.enabled                 | ON      |
| component_firewall.reload_interval_seconds | 0       |
| component_firewall.trace                   | OFF     |
+--------------------------------------------+---------+
4 rows in set (0.019 sec)

--------------
SHOW STATUS LIKE '%firewall%'
--------------

+----------------------------------------------------+-------+
| Variable_name                                      | Value |
+----------------------------------------------------+-------+
| firewall_access_denied                             | 0     |
| firewall_access_granted                            | 0     |
| firewall_access_suspicious                         | 0     |
| firewall_cached_entries                            | 0     |
| option_tracker_usage:Enterprise Firewall component | 0     |
+----------------------------------------------------+-------+
5 rows in set (0.018 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
| component_firewall.database     | ddv_sec        |
+---------------------------------+----------------+
2 rows in set (0.012 sec)

--------------
SHOW FULL TABLES FROM ddv_sec
--------------

+--------------------------+------------+
| Tables_in_ddv_sec        | Table_type |
+--------------------------+------------+
| firewall_group_allowlist | BASE TABLE |
| firewall_groups          | BASE TABLE |
| firewall_membership      | BASE TABLE |
+--------------------------+------------+
3 rows in set (0.176 sec)

--------------
SELECT ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = 'ddv_sec' ORDER BY 2
--------------

+----------------+-------------------------------------+--------------+
| ROUTINE_SCHEMA | ROUTINE_NAME                        | ROUTINE_TYPE |
+----------------+-------------------------------------+--------------+
| ddv_sec        | sp_firewall_group_delist            | PROCEDURE    |
| ddv_sec        | sp_firewall_group_enlist            | PROCEDURE    |
| ddv_sec        | sp_firewall_group_remove            | PROCEDURE    |
| ddv_sec        | sp_firewall_group_rename            | PROCEDURE    |
| ddv_sec        | sp_reload_firewall_group_rules      | PROCEDURE    |
| ddv_sec        | sp_set_firewall_group_mode          | PROCEDURE    |
| ddv_sec        | sp_set_firewall_group_mode_and_user | PROCEDURE    |
+----------------+-------------------------------------+--------------+
7 rows in set (0.067 sec)

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
3 rows in set (0.015 sec)

--------------
SHOW PRIVILEGES
--------------

+---------------------------------+---------------------------------------+-----------------------------------------------------------------+
| Privilege                       | Context                               | Comment                                                         |
+---------------------------------+---------------------------------------+-----------------------------------------------------------------+
| Alter                           | Tables                                | To alter the table                                              |
| Alter routine                   | Functions,Procedures                  | To alter or drop stored functions/procedures                    |
| Create                          | Databases,Tables,Indexes              | To create new databases and tables                              |
| Create routine                  | Databases                             | To use CREATE FUNCTION/PROCEDURE                                |
| Create role                     | Server Admin                          | To create new roles                                             |
| Create temporary tables         | Databases                             | To use CREATE TEMPORARY TABLE                                   |
| Create view                     | Tables                                | To create new views                                             |
| Create user                     | Server Admin                          | To create new users                                             |
| Delete                          | Tables                                | To delete existing rows                                         |
| Drop                            | Databases,Tables                      | To drop databases, tables, and views                            |
| Drop role                       | Server Admin                          | To drop roles                                                   |
| Event                           | Server Admin                          | To create, alter, drop and execute events                       |
| Execute                         | Functions,Procedures                  | To execute stored routines                                      |
| File                            | File access on server                 | To read and write files on the server                           |
| Grant option                    | Databases,Tables,Functions,Procedures | To give to other users those privileges you possess             |
| Index                           | Tables                                | To create or drop indexes                                       |
| Insert                          | Tables                                | To insert data into tables                                      |
| Lock tables                     | Databases                             | To use LOCK TABLES (together with SELECT privilege)             |
| Process                         | Server Admin                          | To view the plain text of currently executing queries           |
| Proxy                           | Server Admin                          | To make proxy user possible                                     |
| References                      | Databases,Tables                      | To have references on tables                                    |
| Reload                          | Server Admin                          | To reload or refresh tables, logs and privileges                |
| Replication client              | Server Admin                          | To ask where the slave or master servers are                    |
| Replication slave               | Server Admin                          | To read binary log events from the master                       |
| Select                          | Tables                                | To retrieve rows from table                                     |
| Show databases                  | Server Admin                          | To see all databases with SHOW DATABASES                        |
| Show view                       | Tables                                | To see views with SHOW CREATE VIEW                              |
| Shutdown                        | Server Admin                          | To shut down the server                                         |
| Super                           | Server Admin                          | To use KILL thread, SET GLOBAL, CHANGE REPLICATION SOURCE, etc. |
| Trigger                         | Tables                                | To use triggers                                                 |
| Create tablespace               | Server Admin                          | To create/alter/drop tablespaces                                |
| Update                          | Tables                                | To update existing rows                                         |
| Usage                           | Server Admin                          | No privileges - allow connect only                              |
| INNODB_REDO_LOG_ARCHIVE         | Server Admin                          |                                                                 |
| ENCRYPTION_KEY_ADMIN            | Server Admin                          |                                                                 |
| MASKING_DICTIONARIES_ADMIN      | Server Admin                          |                                                                 |
| TABLE_ENCRYPTION_ADMIN          | Server Admin                          |                                                                 |
| ROLE_ADMIN                      | Server Admin                          |                                                                 |
| REPLICATION_SLAVE_ADMIN         | Server Admin                          |                                                                 |
| SYSTEM_VARIABLES_ADMIN          | Server Admin                          |                                                                 |
| BINLOG_ADMIN                    | Server Admin                          |                                                                 |
| AUDIT_ABORT_EXEMPT              | Server Admin                          |                                                                 |
| SERVICE_CONNECTION_ADMIN        | Server Admin                          |                                                                 |
| GROUP_REPLICATION_ADMIN         | Server Admin                          |                                                                 |
| CONNECTION_ADMIN                | Server Admin                          |                                                                 |
| PASSWORDLESS_USER_ADMIN         | Server Admin                          |                                                                 |
| XA_RECOVER_ADMIN                | Server Admin                          |                                                                 |
| PERSIST_RO_VARIABLES_ADMIN      | Server Admin                          |                                                                 |
| SHOW_ROUTINE                    | Server Admin                          |                                                                 |
| BACKUP_ADMIN                    | Server Admin                          |                                                                 |
| GROUP_REPLICATION_STREAM        | Server Admin                          |                                                                 |
| CLONE_ADMIN                     | Server Admin                          |                                                                 |
| FIREWALL_ADMIN                  | Server Admin                          |                                                                 |
| OPTIMIZE_LOCAL_TABLE            | Server Admin                          |                                                                 |
| SESSION_VARIABLES_ADMIN         | Server Admin                          |                                                                 |
| RESOURCE_GROUP_ADMIN            | Server Admin                          |                                                                 |
| FIREWALL_EXEMPT                 | Server Admin                          |                                                                 |
| RESOURCE_GROUP_USER             | Server Admin                          |                                                                 |
| BINLOG_ENCRYPTION_ADMIN         | Server Admin                          |                                                                 |
| APPLICATION_PASSWORD_ADMIN      | Server Admin                          |                                                                 |
| SYSTEM_USER                     | Server Admin                          |                                                                 |
| AUDIT_ADMIN                     | Server Admin                          |                                                                 |
| FLUSH_OPTIMIZER_COSTS           | Server Admin                          |                                                                 |
| TELEMETRY_LOG_ADMIN             | Server Admin                          |                                                                 |
| INNODB_REDO_LOG_ENABLE          | Server Admin                          |                                                                 |
| REPLICATION_APPLIER             | Server Admin                          |                                                                 |
| CREATE_SPATIAL_REFERENCE_SYSTEM | Server Admin                          |                                                                 |
| FLUSH_STATUS                    | Server Admin                          |                                                                 |
| FLUSH_USER_RESOURCES            | Server Admin                          |                                                                 |
| FLUSH_TABLES                    | Server Admin                          |                                                                 |
| SET_ANY_DEFINER                 | Server Admin                          |                                                                 |
| FLUSH_PRIVILEGES                | Server Admin                          |                                                                 |
| AUTHENTICATION_POLICY_ADMIN     | Server Admin                          |                                                                 |
| SENSITIVE_VARIABLES_OBSERVER    | Server Admin                          |                                                                 |
| ALLOW_NONEXISTENT_DEFINER       | Server Admin                          |                                                                 |
| TRANSACTION_GTID_TAG            | Server Admin                          |                                                                 |
| MANAGE_DATA_MASKING_POLICY      | Server Admin                          |                                                                 |
+---------------------------------+---------------------------------------+-----------------------------------------------------------------+
77 rows in set (0.010 sec)

Bye
````

### evidence/71-stack-llm-context.txt
````text
HEADER: NO LLM IS CALLED. This is the text a model WOULD receive as
context for each question. Produced by agent/support_agent.py as ddv_agent.

##### CONTEXT FOR QUESTION 1 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: Where is order 102?
TOOL RESULTS:
- find_customer('Asha Example') -> 1 row(s)
    id=1, full_name=Asha Example, phone=****0101, email=a***********@example.test, tax_id=*********
- list_orders(1) -> 2 row(s)
    id=101, status=delivered, total_amount=1250.00, created_at=2026-09-01 10:15:00
    id=102, status=shipped, total_amount=349.50, created_at=2026-09-20 14:02:00
- payment_status(102) -> 1 row(s)
    id=1002, order_id=102, method=upi, card_number=None, upi_id=a************, status=captured, order_status=shipped

##### CONTEXT FOR QUESTION 2 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: Verify caller Asha Example with last four 0101
TOOL RESULTS:
- find_customer('Asha Example') -> 1 row(s)
    id=1, full_name=Asha Example, phone=****0101, email=a***********@example.test, tax_id=*********
- verify_last4(1, '0101') -> 1 row(s)
    matches=1

##### CONTEXT FOR QUESTION 3 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: Why did Chen Demo's charge fail?
TOOL RESULTS:
- find_customer('Chen Demo') -> 1 row(s)
    id=3, full_name=Chen Demo, phone=****0103, email=c********@example.test, tax_id=*********
- list_orders(3) -> 2 row(s)
    id=105, status=pending, total_amount=45.00, created_at=2026-10-02 11:05:00
    id=106, status=delivered, total_amount=310.75, created_at=2026-09-28 18:30:00
- payment_status(105) -> 1 row(s)
    id=1005, order_id=105, method=upi, card_number=None, upi_id=c************, status=pending, order_status=pending
- payment_status(106) -> 1 row(s)
    id=1006, order_id=106, method=card, card_number=***********0005, upi_id=None, status=captured, order_status=delivered
- ticket_notes(3) -> 1 row(s)
    id=3, subject=Charge failed, please call back, notes=Customer typed: my card is 378282246310005 and you can reach me at chen.demo@example.test, please retry the charge.

##### CONTEXT FOR QUESTION 4 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: What is the refund status of order 104?
TOOL RESULTS:
- payment_status(104) -> 1 row(s)
    id=1004, order_id=104, method=card, card_number=************4444, upi_id=None, status=refunded, order_status=refunded
````

### evidence/71-stack-ow1.txt
````text
--------------
SELECT * FROM ddv_support.customers
--------------

Bye
````

### evidence/71-stack-ow1-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 2     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.008 sec)

Bye
````

### evidence/71-stack-ow1-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 0     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.009 sec)

Bye
````

### evidence/71-stack-ow2.txt
````text
--------------
SELECT * FROM ddv_support.payments
--------------

Bye
````

### evidence/71-stack-ow2-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 4     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.009 sec)

Bye
````

### evidence/71-stack-ow2-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 2     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.009 sec)

Bye
````

### evidence/71-stack-ow3.txt
````text
--------------
SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
--------------

Bye
````

### evidence/71-stack-ow3-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 6     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.024 sec)

Bye
````

### evidence/71-stack-ow3-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 4     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.011 sec)

Bye
````

### evidence/71-stack-ow4.txt
````text
--------------
SELECT * FROM ddv_support.support_tickets
--------------

Bye
````

### evidence/71-stack-ow4-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 8     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.008 sec)

Bye
````

### evidence/71-stack-ow4-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 6     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.008 sec)

Bye
````

### evidence/71-stack-ow5.txt
````text
--------------
SELECT 1
--------------

Bye
````

### evidence/71-stack-ow5-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 10    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.020 sec)

Bye
````

### evidence/71-stack-ow5-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 8     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.008 sec)

Bye
````

### evidence/71-stack-questions.txt
````text
=== Question 1: Where is order 102?
tool call: find_customer('Asha Example') -> 1 row(s)
    {'id': 1, 'full_name': 'Asha Example', 'phone': '****0101', 'email': 'a***********@example.test', 'tax_id': '*********'}
tool call: list_orders(1) -> 2 row(s)
    {'id': 101, 'status': 'delivered', 'total_amount': Decimal('1250.00'), 'created_at': datetime.datetime(2026, 9, 1, 10, 15)}
    {'id': 102, 'status': 'shipped', 'total_amount': Decimal('349.50'), 'created_at': datetime.datetime(2026, 9, 20, 14, 2)}
tool call: payment_status(102) -> 1 row(s)
    {'id': 1002, 'order_id': 102, 'method': 'upi', 'card_number': None, 'upi_id': 'a************', 'status': 'captured', 'order_status': 'shipped'}
=== Question 2: Verify caller Asha Example with last four 0101
tool call: find_customer('Asha Example') -> 1 row(s)
    {'id': 1, 'full_name': 'Asha Example', 'phone': '****0101', 'email': 'a***********@example.test', 'tax_id': '*********'}
tool call: verify_last4(1, '0101') -> 1 row(s)
    {'matches': 1}
=== Question 3: Why did Chen Demo's charge fail?
tool call: find_customer('Chen Demo') -> 1 row(s)
    {'id': 3, 'full_name': 'Chen Demo', 'phone': '****0103', 'email': 'c********@example.test', 'tax_id': '*********'}
tool call: list_orders(3) -> 2 row(s)
    {'id': 105, 'status': 'pending', 'total_amount': Decimal('45.00'), 'created_at': datetime.datetime(2026, 10, 2, 11, 5)}
    {'id': 106, 'status': 'delivered', 'total_amount': Decimal('310.75'), 'created_at': datetime.datetime(2026, 9, 28, 18, 30)}
tool call: payment_status(105) -> 1 row(s)
    {'id': 1005, 'order_id': 105, 'method': 'upi', 'card_number': None, 'upi_id': 'c************', 'status': 'pending', 'order_status': 'pending'}
tool call: payment_status(106) -> 1 row(s)
    {'id': 1006, 'order_id': 106, 'method': 'card', 'card_number': '***********0005', 'upi_id': None, 'status': 'captured', 'order_status': 'delivered'}
tool call: ticket_notes(3) -> 1 row(s)
    {'id': 3, 'subject': 'Charge failed, please call back', 'notes': 'Customer typed: my card is 378282246310005 and you can reach me at chen.demo@example.test, please retry the charge.'}
=== Question 4: What is the refund status of order 104?
tool call: payment_status(104) -> 1 row(s)
    {'id': 1004, 'order_id': 104, 'method': 'card', 'card_number': '************4444', 'upi_id': None, 'status': 'refunded', 'order_status': 'refunded'}
context written to evidence/71-stack-llm-context.txt
````

### evidence/71-stack-questions-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 18    |
| firewall_access_granted    | 28    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.011 sec)

Bye
````

### evidence/71-stack-questions-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 18    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.008 sec)

Bye
````

### evidence/71-stack-recording-run.txt
````text
=== Question 1: Where is order 102?
tool call: find_customer('Asha Example') -> 1 row(s)
    {'id': 1, 'full_name': 'Asha Example', 'phone': '****0101', 'email': 'a***********@example.test', 'tax_id': '*********'}
tool call: list_orders(1) -> 2 row(s)
    {'id': 101, 'status': 'delivered', 'total_amount': Decimal('1250.00'), 'created_at': datetime.datetime(2026, 9, 1, 10, 15)}
    {'id': 102, 'status': 'shipped', 'total_amount': Decimal('349.50'), 'created_at': datetime.datetime(2026, 9, 20, 14, 2)}
tool call: payment_status(102) -> 1 row(s)
    {'id': 1002, 'order_id': 102, 'method': 'upi', 'card_number': None, 'upi_id': 'a************', 'status': 'captured', 'order_status': 'shipped'}
=== Question 2: Verify caller Asha Example with last four 0101
tool call: find_customer('Asha Example') -> 1 row(s)
    {'id': 1, 'full_name': 'Asha Example', 'phone': '****0101', 'email': 'a***********@example.test', 'tax_id': '*********'}
tool call: verify_last4(1, '0101') -> 1 row(s)
    {'matches': 1}
=== Question 3: Why did Chen Demo's charge fail?
tool call: find_customer('Chen Demo') -> 1 row(s)
    {'id': 3, 'full_name': 'Chen Demo', 'phone': '****0103', 'email': 'c********@example.test', 'tax_id': '*********'}
tool call: list_orders(3) -> 2 row(s)
    {'id': 105, 'status': 'pending', 'total_amount': Decimal('45.00'), 'created_at': datetime.datetime(2026, 10, 2, 11, 5)}
    {'id': 106, 'status': 'delivered', 'total_amount': Decimal('310.75'), 'created_at': datetime.datetime(2026, 9, 28, 18, 30)}
tool call: payment_status(105) -> 1 row(s)
    {'id': 1005, 'order_id': 105, 'method': 'upi', 'card_number': None, 'upi_id': 'c************', 'status': 'pending', 'order_status': 'pending'}
tool call: payment_status(106) -> 1 row(s)
    {'id': 1006, 'order_id': 106, 'method': 'card', 'card_number': '***********0005', 'upi_id': None, 'status': 'captured', 'order_status': 'delivered'}
tool call: ticket_notes(3) -> 1 row(s)
    {'id': 3, 'subject': 'Charge failed, please call back', 'notes': 'Customer typed: my card is 378282246310005 and you can reach me at chen.demo@example.test, please retry the charge.'}
=== Question 4: What is the refund status of order 104?
tool call: payment_status(104) -> 1 row(s)
    {'id': 1004, 'order_id': 104, 'method': 'card', 'card_number': '************4444', 'upi_id': None, 'status': 'refunded', 'order_status': 'refunded'}
context written to evidence/71-stack-llm-context.txt
````

### evidence/71-stack-tamp1.txt
````text
--------------
ALTER TABLE ddv_support.customers MODIFY COLUMN phone VARCHAR(20) NOT NULL
--------------

Bye
````

### evidence/71-stack-tamp1-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.009 sec)

Bye
````

### evidence/71-stack-tamp1-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 10    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.008 sec)

Bye
````

### evidence/71-stack-tamp2.txt
````text
--------------
DROP MASKING POLICY sup_mask_phone
--------------

Bye
````

### evidence/71-stack-tamp2-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 14    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.009 sec)

Bye
````

### evidence/71-stack-tamp2-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.017 sec)

Bye
````

### evidence/71-stack-tamp3.txt
````text
--------------
CREATE TABLE ddv_support.copy_customers AS SELECT * FROM ddv_support.customers
--------------

Bye
````

### evidence/71-stack-tamp3-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 16    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.020 sec)

Bye
````

### evidence/71-stack-tamp3-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 14    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.014 sec)

Bye
````

### evidence/71-stack-tamp4.txt
````text
--------------
CREATE VIEW ddv_support.v_leak AS SELECT * FROM ddv_support.customers
--------------

Bye
````

### evidence/71-stack-tamp4-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 18    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.011 sec)

Bye
````

### evidence/71-stack-tamp4-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 16    |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.017 sec)

Bye
````

### evidence/72-stack-audit-extract.txt
````text
Extract of audit_log_read output (137 events, from the server-start event of this run, read in pages of 40). Raw JSON not saved: it contained a local path, the machine name and the OS user name. Kept per event: class/event, account, command class, status, statement text. Timestamps, ids, IP, OS user and connection attributes are omitted.
n | class/event | account | command class | status | statement text
1 | audit/startup | root@localhost | (server startup) |  | 
2 | connection/connect | ddv_agent@localhost | ssl | 0 | 
3 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
4 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
5 | general/status | ddv_agent@localhost | Query/show_status | 0 | SHOW STATUS LIKE 'audit_log%'
6 | connection/disconnect | ddv_agent@localhost | ssl |  | 
7 | connection/connect | ddv_agent@localhost | ssl | 0 | 
8 | general/status | ddv_agent@localhost | Query/set_option | 0 | SET NAMES 'utf8mb4' COLLATE 'utf8mb4_0900_ai_ci'
9 | general/status | ddv_agent@localhost | Query/set_option | 0 | SET @@session.autocommit = OFF
10 | general/status | ddv_agent@localhost | Ping/ | 0 | 
11 | general/status | ddv_agent@localhost | Ping/ | 0 | 
12 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT @@session.sql_mode
13 | table_access/read | ddv_agent@localhost | select |  | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
14 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
15 | general/status | ddv_agent@localhost | Ping/ | 0 | 
16 | table_access/read | ddv_agent@localhost | select |  | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 1 ORDER BY id
17 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 1 ORDER BY id
18 | general/status | ddv_agent@localhost | Ping/ | 0 | 
19 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 102
20 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 102
21 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 102
22 | general/status | ddv_agent@localhost | Ping/ | 0 | 
23 | table_access/read | ddv_agent@localhost | select |  | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
24 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
25 | general/status | ddv_agent@localhost | Ping/ | 0 | 
26 | table_access/read | ddv_agent@localhost | select |  | SELECT RIGHT(phone, 4) = '0101' AS matches FROM ddv_support.customers WHERE id = 1
27 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT RIGHT(phone, 4) = '0101' AS matches FROM ddv_support.customers WHERE id = 1
28 | general/status | ddv_agent@localhost | Ping/ | 0 | 
29 | table_access/read | ddv_agent@localhost | select |  | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Chen Demo'
30 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Chen Demo'
31 | general/status | ddv_agent@localhost | Ping/ | 0 | 
32 | table_access/read | ddv_agent@localhost | select |  | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 3 ORDER BY id
33 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 3 ORDER BY id
34 | general/status | ddv_agent@localhost | Ping/ | 0 | 
35 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 105
36 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 105
37 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 105
38 | general/status | ddv_agent@localhost | Ping/ | 0 | 
39 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 106
40 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 106
41 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 106
42 | general/status | ddv_agent@localhost | Ping/ | 0 | 
43 | table_access/read | ddv_agent@localhost | select |  | SELECT id, subject, notes FROM ddv_support.support_tickets WHERE customer_id = 3 ORDER BY id
44 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, subject, notes FROM ddv_support.support_tickets WHERE customer_id = 3 ORDER BY id
45 | general/status | ddv_agent@localhost | Ping/ | 0 | 
46 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 104
47 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 104
48 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 104
49 | connection/disconnect | ddv_agent@localhost | ssl |  | 
50 | connection/connect | ddv_agent@localhost | ssl | 0 | 
51 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
52 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
53 | general/status | ddv_agent@localhost | Query/select | 6444 | SELECT * FROM ddv_support.customers
54 | connection/disconnect | ddv_agent@localhost | ssl |  | 
55 | connection/connect | ddv_agent@localhost | ssl | 0 | 
56 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
57 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
58 | general/status | ddv_agent@localhost | Query/select | 6444 | SELECT * FROM ddv_support.payments
59 | connection/disconnect | ddv_agent@localhost | ssl |  | 
60 | connection/connect | ddv_agent@localhost | ssl | 0 | 
61 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
62 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
63 | general/status | ddv_agent@localhost | Query/select | 6444 | SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
64 | connection/disconnect | ddv_agent@localhost | ssl |  | 
65 | connection/connect | ddv_agent@localhost | ssl | 0 | 
66 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
67 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
68 | general/status | ddv_agent@localhost | Query/select | 6444 | SELECT * FROM ddv_support.support_tickets
69 | connection/disconnect | ddv_agent@localhost | ssl |  | 
70 | connection/connect | ddv_agent@localhost | ssl | 0 | 
71 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
72 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
73 | general/status | ddv_agent@localhost | Query/select | 6444 | SELECT 1
74 | connection/disconnect | ddv_agent@localhost | ssl |  | 
75 | connection/connect | ddv_agent@localhost | ssl | 0 | 
76 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
77 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
78 | general/status | ddv_agent@localhost | Query/alter_table | 6444 | ALTER TABLE ddv_support.customers MODIFY COLUMN phone VARCHAR(20) NOT NULL
79 | connection/disconnect | ddv_agent@localhost | ssl |  | 
80 | connection/connect | ddv_agent@localhost | ssl | 0 | 
81 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
82 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
83 | general/status | ddv_agent@localhost | Query/drop_masking_policy | 6444 | DROP MASKING POLICY sup_mask_phone
84 | connection/disconnect | ddv_agent@localhost | ssl |  | 
85 | connection/connect | ddv_agent@localhost | ssl | 0 | 
86 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
87 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
88 | general/status | ddv_agent@localhost | Query/create_table | 6444 | CREATE TABLE ddv_support.copy_customers AS SELECT * FROM ddv_support.customers
89 | connection/disconnect | ddv_agent@localhost | ssl |  | 
90 | connection/connect | ddv_agent@localhost | ssl | 0 | 
91 | general/status | ddv_agent@localhost | Query/select | 6444 | select @@version_comment limit 1
92 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
93 | general/status | ddv_agent@localhost | Query/create_view | 6444 | CREATE VIEW ddv_support.v_leak AS SELECT * FROM ddv_support.customers
94 | connection/disconnect | ddv_agent@localhost | ssl |  | 
95 | connection/connect | ddv_agent@localhost | ssl | 0 | 
96 | general/status | ddv_agent@localhost | Query/set_option | 0 | SET NAMES 'utf8mb4' COLLATE 'utf8mb4_0900_ai_ci'
97 | general/status | ddv_agent@localhost | Query/set_option | 0 | SET @@session.autocommit = OFF
98 | general/status | ddv_agent@localhost | Ping/ | 0 | 
99 | general/status | ddv_agent@localhost | Ping/ | 0 | 
100 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT @@session.sql_mode
101 | table_access/read | ddv_agent@localhost | select |  | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
102 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
103 | general/status | ddv_agent@localhost | Ping/ | 0 | 
104 | table_access/read | ddv_agent@localhost | select |  | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 1 ORDER BY id
105 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 1 ORDER BY id
106 | general/status | ddv_agent@localhost | Ping/ | 0 | 
107 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 102
108 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 102
109 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 102
110 | general/status | ddv_agent@localhost | Ping/ | 0 | 
111 | table_access/read | ddv_agent@localhost | select |  | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
112 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Asha Example'
113 | general/status | ddv_agent@localhost | Ping/ | 0 | 
114 | table_access/read | ddv_agent@localhost | select |  | SELECT RIGHT(phone, 4) = '0101' AS matches FROM ddv_support.customers WHERE id = 1
115 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT RIGHT(phone, 4) = '0101' AS matches FROM ddv_support.customers WHERE id = 1
116 | general/status | ddv_agent@localhost | Ping/ | 0 | 
117 | table_access/read | ddv_agent@localhost | select |  | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Chen Demo'
118 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Chen Demo'
119 | general/status | ddv_agent@localhost | Ping/ | 0 | 
120 | table_access/read | ddv_agent@localhost | select |  | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 3 ORDER BY id
121 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, status, total_amount, created_at FROM ddv_support.orders WHERE customer_id = 3 ORDER BY id
122 | general/status | ddv_agent@localhost | Ping/ | 0 | 
123 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 105
124 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 105
125 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 105
126 | general/status | ddv_agent@localhost | Ping/ | 0 | 
127 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 106
128 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 106
129 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 106
130 | general/status | ddv_agent@localhost | Ping/ | 0 | 
131 | table_access/read | ddv_agent@localhost | select |  | SELECT id, subject, notes FROM ddv_support.support_tickets WHERE customer_id = 3 ORDER BY id
132 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT id, subject, notes FROM ddv_support.support_tickets WHERE customer_id = 3 ORDER BY id
133 | general/status | ddv_agent@localhost | Ping/ | 0 | 
134 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 104
135 | table_access/read | ddv_agent@localhost | select |  | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 104
136 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, p.status, o.status AS order_status FROM ddv_support.payments p JOIN ddv_support.orders o ON o.id = p.order_id WHERE p.order_id = 104
137 | connection/disconnect | ddv_agent@localhost | ssl |  | 
````

### evidence/73-after.txt
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
3 rows in set (0.008 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.013 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.063 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.012 sec)

--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
| 229 | root            | localhost:60458 | Query   |
|   7 | event_scheduler | localhost       | Daemon  |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.017 sec)

Bye
````

### evidence/73-audit-remove.txt
````text
--------------
SELECT audit_log_filter_remove_user('ddv_agent@%')
--------------

+---------------------------------------------+
| audit_log_filter_remove_user('ddv_agent@%') |
+---------------------------------------------+
| OK                                          |
+---------------------------------------------+
1 row in set (0.061 sec)

--------------
SELECT audit_log_filter_remove_filter('agent_log')
--------------

+---------------------------------------------+
| audit_log_filter_remove_filter('agent_log') |
+---------------------------------------------+
| OK                                          |
+---------------------------------------------+
1 row in set (0.051 sec)

--------------
SELECT * FROM mysql.audit_log_filter
--------------

Empty set (0.004 sec)

--------------
SELECT * FROM mysql.audit_log_user
--------------

Empty set (0.003 sec)

--------------
SHOW STATUS LIKE 'audit_log.events%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.events               | 1100  |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 137   |
+--------------------------------+-------+
6 rows in set (0.010 sec)

Bye
````

### evidence/73-audit-uninstall.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.003 sec)

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

Query OK, 0 rows affected (0.103 sec)

--------------
-- Drop the tables.
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
DROP TABLE IF EXISTS audit_log_user
--------------

Query OK, 0 rows affected (0.172 sec)

--------------
DROP TABLE IF EXISTS audit_log_filter
--------------

Query OK, 0 rows affected (0.103 sec)

Bye
````

### evidence/73-compare.txt
````text
Compare-Object evidence\70-baseline.txt evidence\73-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).

InputObject                                           SideIndicator
-----------                                           -------------
| 229 | root            | localhost:60458 | Query   | =>           
| 162 | root            | localhost:60932 | Query   | <=
````

### evidence/73-drop-schema.txt
````text
--------------
DROP SCHEMA ddv_sec
--------------

Query OK, 0 rows affected (0.127 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

Bye
````

### evidence/73-fw-group-teardown.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'RESET')
--------------

Query OK, 0 rows affected (0.065 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------+-------------+
| NAME     | MODE | USERHOST    |
+----------+------+-------------+
| fw_agent | OFF  | ddv_agent@% |
+----------+------+-------------+
1 row in set (0.008 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

Empty set (0.005 sec)

--------------
CALL ddv_sec.sp_firewall_group_delist('fw_agent', 'ddv_agent@%')
--------------

Query OK, 0 rows affected (0.031 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

Empty set (0.007 sec)

--------------
CALL ddv_sec.sp_firewall_group_remove('fw_agent')
--------------

Query OK, 0 rows affected (0.033 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

Empty set (0.002 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

Empty set (0.002 sec)

--------------
REVOKE FIREWALL_ADMIN ON *.* FROM 'root'@'localhost'
--------------

Query OK, 0 rows affected (0.027 sec)

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
3 rows in set (0.004 sec)

Bye
````

### evidence/73-fw-uninstall.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
# This script uninstalls Enterprise Firewall component
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
# and drops its tables and stored procedures.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
#
--------------

Query OK, 0 rows affected (0.006 sec)

--------------
# NOTE: before running the script the following must be assured:
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# 1) there is only a single connection (current)
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# 2) the current database is @@component_firewall.database
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
UNINSTALL COMPONENT 'file://component_firewall'
--------------

Query OK, 0 rows affected (0.670 sec)

--------------
DROP PROCEDURE sp_set_firewall_group_mode
--------------

Query OK, 0 rows affected (0.068 sec)

--------------
DROP PROCEDURE sp_set_firewall_group_mode_and_user
--------------

Query OK, 0 rows affected (0.070 sec)

--------------
DROP PROCEDURE sp_reload_firewall_group_rules
--------------

Query OK, 0 rows affected (0.052 sec)

--------------
DROP PROCEDURE sp_firewall_group_enlist
--------------

Query OK, 0 rows affected (0.058 sec)

--------------
DROP PROCEDURE sp_firewall_group_delist
--------------

Query OK, 0 rows affected (0.053 sec)

--------------
DROP PROCEDURE sp_firewall_group_rename
--------------

Query OK, 0 rows affected (0.051 sec)

--------------
DROP PROCEDURE sp_firewall_group_remove
--------------

Query OK, 0 rows affected (0.046 sec)

--------------
DROP TABLE firewall_group_allowlist
--------------

Query OK, 0 rows affected (0.153 sec)

--------------
DROP TABLE firewall_groups
--------------

Query OK, 0 rows affected (0.152 sec)

--------------
DROP TABLE firewall_membership
--------------

Query OK, 0 rows affected (0.237 sec)

Bye
````

### evidence/73-grants-check.txt
````text
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
3 rows in set (0.002 sec)

Bye
````

### evidence/73-precheck.txt
````text
--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
| 220 | root            | localhost:60449 | Query   |
|   7 | event_scheduler | localhost       | Daemon  |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.016 sec)

Warning (Code 1287): 'INFORMATION_SCHEMA.PROCESSLIST' is deprecated and will be removed in a future release. Please use performance_schema.processlist instead
--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------------+-------------+
| NAME     | MODE       | USERHOST    |
+----------+------------+-------------+
| fw_agent | PROTECTING | ddv_agent@% |
+----------+------------+-------------+
1 row in set (0.002 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

+----------+-------------+
| GROUP_ID | MEMBER_ID   |
+----------+-------------+
| fw_agent | ddv_agent@% |
+----------+-------------+
1 row in set (0.001 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NAME     | RULE                                                                                                                                                                                                                                                                               |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| fw_agent | SELECT @@SESSION . `sql_mode`                                                                                                                                                                                                                                                      |
| fw_agent | SELECT RIGHT ( `phone` , ? ) = ? AS `matches` FROM `ddv_support` . `customers` WHERE `id` = ?                                                                                                                                                                                      |
| fw_agent | SELECT `id` , STATUS , `total_amount` , `created_at` FROM `ddv_support` . `orders` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                           |
| fw_agent | SELECT `id` , SUBJECT , `notes` FROM `ddv_support` . `support_tickets` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                                       |
| fw_agent | SELECT `id` , `full_name` , `phone` , `email` , `tax_id` FROM `ddv_support` . `customers` WHERE `full_name` = ?                                                                                                                                                                    |
| fw_agent | SELECT `p` . `id` , `p` . `order_id` , `p` . `method` , `p` . `card_number` , `p` . `upi_id` , `p` . `status` , `o` . `status` AS `order_status` FROM `ddv_support` . `payments` `p` JOIN `ddv_support` . `orders` `o` ON `o` . `id` = `p` . `order_id` WHERE `p` . `order_id` = ? |
| fw_agent | SET @@SESSION . `autocommit` = OFF                                                                                                                                                                                                                                                 |
| fw_agent | SET NAMES ? COLLATE ?                                                                                                                                                                                                                                                              |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
8 rows in set (0.002 sec)

Bye
````

### evidence/73-reset-persist.txt
````text
--------------
RESET PERSIST component_firewall.database
--------------

Query OK, 0 rows affected (0.058 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.006 sec)

Bye
````

## Not captured

- ERROR lines of the nine statement runs in `71-stack-*.txt` (stderr not redirected); the 9 lines of `ERROR 6444 (28000) at line 1: Access denied.` appeared on the console only.
- The recording-run console output of the Firewall status counters (only the post-RECORDING counters are in `71-fw-allowlist.txt`).
- The raw Audit JSON (kept in `.local/audit-raw-stack.json`: it holds a local path, the machine name and the OS user name).
- Timestamps, ids, IP, OS user and connection attributes of the Audit events.
- Contents of the audit log file in the Data folder (not accessed).
- Any statement containing a password while Audit was loaded (none run).
- mysql client exit codes (all 0 because of `--force`).

## Observations (Claude Code's reading, not evidence)

- The Firewall allowlist recorded in this run has the same 8 rules as Step 5 (`53-firewall-allowlist.txt`); only the group row differs (mode).
- The four scripted questions ran in PROTECTING mode with the denied counter unchanged at 18 and the granted counter 14 to 28.
- Each denied run raised the denied counter by 2 and left the granted counter at 14.
- In the Audit extract the Firewall-denied statements appear as general/status events with status 6444 (the four tampering statements included, with sql commands alter_table, drop_masking_policy, create_table, create_view); the denied selects have no table_access event.
- Each mysql client run issues `select @@version_comment limit 1` (status 6444 in PROTECTING) and `select $$` (status 1064); the source is the client (reasoning).
- `audit_log.events_written` was 137, equal to the 137 events read from this run.
- After teardown the snapshot equals the baseline except the processlist row of the capturing session; FIREWALL_ADMIN no longer appears in root's grants.
