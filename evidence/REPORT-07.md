# REPORT-07: Step 5, Enterprise Firewall component (dedicated schema, uninstalled)

The firewall component was installed into schema ddv_sec with share\install_component_firewall.sql (run with -D ddv_sec), exercised on one group (fw_agent, ddv_agent@% only), uninstalled with share\uninstall_component_firewall.sql, and ddv_sec was dropped. No capture was repeated. evidence/53-firewall-recording-run.txt and 53-firewall-protecting.txt contain agent console output; the agent copy's hard-coded final message says evidence/21-llm-context.txt but the file written was evidence/53-fw-llm-context.txt (evidence/21-llm-context.txt hash unchanged: faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671).
The second run of the agent copy (PROTECTING) rewrote evidence/53-fw-llm-context.txt with identical bytes (same hash before and after).
Files 53-firewall-uninstall.txt and 53-firewall-protecting.txt are several client runs appended in order.

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
2c4ff3551eefa89130912b394899e06309e1aaa95520e1274f78e9e458391112  agent/support_agent_fw.py
0daa5d680d5b74b1cb63f6f000b73f28b905044e79856524aa80d1c919e62d48  evidence/53-after.txt
3578c435122e896b341f1b94c31ed5f1e33edf7cad3e9e96a80633a93f1f3264  evidence/53-compare.txt
7769c4b270d2aa5b6616ce992d0291f4fe40b06378ba175ad54762f71bf9d0b6  evidence/53-firewall-allowlist.txt
486c26f778315089dcd9e2bd628d1723bbbe38d51e09a770963438815d294208  evidence/53-firewall-enlist.txt
2329acc01f1849e6e8141289dd92e7dd17a718d04feafc703316b831c73fcc88  evidence/53-firewall-install.txt
1820c636c4e780668e6bd3c78cf1a10416fc1181f7fa6f5485219789ca0a4a0a  evidence/53-firewall-others.txt
d1c7d388e5775c380b7b43eb30e76c21bb48e3e75ce412bf5ac5ea8763e37fc9  evidence/53-firewall-protecting.txt
5a75ea46e3621a69b6d4174ab17bf36194935e1966931e858c9dd74370e4eba7  evidence/53-firewall-protecting-status.txt
f31cc479dd57cfb0c5573fbaf6ebd3f0ffd656b0e7f61b2275c94fb798a26391  evidence/53-firewall-recording.txt
67da58bd32738e437abf5893a2d498e4e54f6a35a9946fbfb086132720df0d2c  evidence/53-firewall-recording-run.txt
a9f5c4de1e0880979a91771bab734c432182cc068d10660a39eeeff942c86b61  evidence/53-firewall-state.txt
5d098db6fb1c577d2c36dc16806be628a0fb186f17ea0d1adc72c8f7ddc7c8ba  evidence/53-firewall-uninstall.txt
faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671  evidence/53-fw-llm-context.txt
d9fb415d3fdfd3774fd2d39b4192f2270a15e1db694c4f2cd3bf3c7f298c5b37  evidence/53-schema-create.txt
ac00fd48835cec239bd5aef77bce7713f2beecaeedaecbcd978d2f7ed172a11b  sql/53-allowlist.sql
a4d798dcbd163bfa14ffb1304ca3e026d660bae4808c1703f34bb7b2cd390725  sql/53-create-schema.sql
5ce2848fc2efc8168edeb20b564fb0173a7a43bb2916cb2309e40819d49b1ae0  sql/53-enlist.sql
391ae0134f80c0a603d530c9dfa7b69e4e274619f0d1b949f7677c93c178fa45  sql/53-firewall-state.sql
ae1ef3101a5ac1d5f19a29836e9cda8717b429af74b405c39c058afcd5b296af  sql/53-others.sql
e245ca12d84f4ffc5ed107a2bd38d922b14fd24181b144d1a118b6878c9c336a  sql/53-protecting-start.sql
8d6f9b37966420397b83850de6019001033b54c47c300d18fa7e64366f142d38  sql/53-protecting-status.sql
451797a4d32828f397fcfe52d4621ec1cd7bcee596099bd546962ca5dc8fb1be  sql/53-protecting-stmts.sql
550b4506f123702b58d288ea44b60f4949e62a3adb4b7e0c483ae1d57ead4680  sql/53-recording-start.sql
c7b27a7b9232f2e706d54a94d0c46da2d32c83fd475f92048647a5afac1a5bec  sql/53-reset-persist.sql
95170137e4ffcdc2f51d7d6a541a7ea691a57404959f04b8bf9b2f3ce243c800  sql/53-teardown-1.sql
faceeebda5e078c18e53b5d898cb33d58e20b78023691364de6fe7db00706a0d  sql/53-teardown-2.sql
```

## Evidence (verbatim)

### evidence/53-after.txt
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
6 rows in set (0.001 sec)

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
6 rows in set (0.001 sec)

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

Empty set (0.079 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

Empty set (0.013 sec)

--------------
SHOW VARIABLES LIKE '%audit%'
--------------

Empty set (0.041 sec)

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

### evidence/53-compare.txt
````text
Compare-Object evidence\50-baseline.txt evidence\53-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).
(no differences)
````

### evidence/53-firewall-allowlist.txt
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
8 rows in set (0.023 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+-----------+-------------+
| NAME     | MODE      | USERHOST    |
+----------+-----------+-------------+
| fw_agent | RECORDING | ddv_agent@% |
+----------+-----------+-------------+
1 row in set (0.006 sec)

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
| option_tracker_usage:Enterprise Firewall component | 11    |
+----------------------------------------------------+-------+
5 rows in set (0.023 sec)

Bye
````

### evidence/53-firewall-enlist.txt
````text
--------------
CALL ddv_sec.sp_firewall_group_enlist('fw_agent', 'ddv_agent@%')
--------------

Query OK, 0 rows affected (0.111 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+-----------+-------------+
| NAME     | MODE      | USERHOST    |
+----------+-----------+-------------+
| fw_agent | RECORDING | ddv_agent@% |
+----------+-----------+-------------+
1 row in set (0.007 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

+----------+-------------+
| GROUP_ID | MEMBER_ID   |
+----------+-------------+
| fw_agent | ddv_agent@% |
+----------+-------------+
1 row in set (0.007 sec)

Bye
````

### evidence/53-firewall-install.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
# This script installs Enterprise Firewall component
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
# altogether with needed tables and stored procedures.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
#
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
# The tables and procedures will be located in the current database.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# @@component_firewall.database will be set to the current database
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
# and persisted.
--------------

Query OK, 0 rows affected (0.002 sec)

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

Query OK, 0 rows affected, 2 warnings (0.305 sec)

--------------
CREATE TABLE IF NOT EXISTS firewall_groups(
  NAME VARCHAR(288) PRIMARY KEY,
  MODE ENUM ('OFF', 'RECORDING', 'PROTECTING', 'DETECTING') NOT NULL DEFAULT 'OFF',
  USERHOST VARCHAR(288)
) engine=InnoDB
--------------

Query OK, 0 rows affected (0.151 sec)

--------------
CREATE TABLE IF NOT EXISTS firewall_membership(
  GROUP_ID VARCHAR(288),
  MEMBER_ID VARCHAR(288),
  PRIMARY KEY(GROUP_ID, MEMBER_ID)
) engine=InnoDB
--------------

Query OK, 0 rows affected (0.156 sec)

--------------
# install the component
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
INSTALL COMPONENT 'file://component_firewall' SET
  PERSIST component_firewall.database = DATABASE()
--------------

Query OK, 0 rows affected (0.315 sec)

--------------
# Create procedures
--------------

Query OK, 0 rows affected (0.043 sec)

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

Query OK, 0 rows affected (0.104 sec)

--------------
# switches group operational mode, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.001 sec)

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

Query OK, 0 rows affected (0.024 sec)

--------------
# rebuilds in-memory cache of particular user firewall rules
--------------

Query OK, 0 rows affected (0.001 sec)

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

Query OK, 0 rows affected (0.024 sec)

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

Query OK, 0 rows affected (0.025 sec)

--------------
# removes user from a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.001 sec)

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

Query OK, 0 rows affected (0.021 sec)

--------------
# renames a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.001 sec)

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

Query OK, 0 rows affected (0.024 sec)

--------------
# removes a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.001 sec)

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

Query OK, 0 rows affected (0.035 sec)

Bye
````

### evidence/53-firewall-others.txt
````text
--------------
SELECT COUNT(*) FROM ddv_support.customers
--------------

+----------+
| COUNT(*) |
+----------+
|        6 |
+----------+
1 row in set (0.105 sec)

Bye
--------------
SELECT COUNT(*) FROM ddv_support.customers
--------------

+----------+
| COUNT(*) |
+----------+
|        6 |
+----------+
1 row in set (0.019 sec)

Bye
````

### evidence/53-firewall-protecting.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'PROTECTING')
--------------

Query OK, 0 rows affected (0.106 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------------+-------------+
| NAME     | MODE       | USERHOST    |
+----------+------------+-------------+
| fw_agent | PROTECTING | ddv_agent@% |
+----------+------------+-------------+
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
8 rows in set (0.001 sec)

Bye
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
context written to evidence/21-llm-context.txt
--------------
SELECT * FROM ddv_support.customers
--------------

ERROR 6444 (28000) at line 1: Access denied.
Bye
--------------
SELECT * FROM ddv_support.payments
--------------

ERROR 6444 (28000) at line 1: Access denied.
Bye
--------------
SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
--------------

ERROR 6444 (28000) at line 1: Access denied.
Bye
--------------
SELECT * FROM ddv_support.support_tickets
--------------

ERROR 6444 (28000) at line 1: Access denied.
Bye
--------------
SELECT 1
--------------

ERROR 6444 (28000) at line 1: Access denied.
Bye
````

### evidence/53-firewall-protecting-status.txt
````text
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
SHOW STATUS LIKE '%firewall%'
--------------

+----------------------------------------------------+-------+
| Variable_name                                      | Value |
+----------------------------------------------------+-------+
| firewall_access_denied                             | 10    |
| firewall_access_granted                            | 28    |
| firewall_access_suspicious                         | 0     |
| firewall_cached_entries                            | 8     |
| option_tracker_usage:Enterprise Firewall component | 22    |
+----------------------------------------------------+-------+
5 rows in set (0.006 sec)

Bye
````

### evidence/53-firewall-recording.txt
````text
--------------
GRANT FIREWALL_ADMIN ON *.* TO 'root'@'localhost'
--------------

Query OK, 0 rows affected (0.028 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CALL ddv_sec.sp_set_firewall_group_mode_and_user('fw_agent', 'RECORDING', 'ddv_agent@%')
--------------

+-------------------------------------------------------+
| read_firewall_group_allowlist(arg_group_name,FW.rule) |
+-------------------------------------------------------+
| Rules added: 0, already existed: 0.                   |
+-------------------------------------------------------+
1 row in set (0.037 sec)

Query OK, 0 rows affected (0.054 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

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

Empty set (0.005 sec)

Bye
````

### evidence/53-firewall-recording-run.txt
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
context written to evidence/21-llm-context.txt
````

### evidence/53-firewall-state.txt
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
|            4 |                  4 | file://component_firewall          |
+--------------+--------------------+------------------------------------+
4 rows in set (0.005 sec)

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
4 rows in set (0.124 sec)

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
5 rows in set (0.264 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
| component_firewall.database     | ddv_sec        |
+---------------------------------+----------------+
2 rows in set (0.013 sec)

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
3 rows in set (0.062 sec)

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
7 rows in set (0.156 sec)

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
3 rows in set (0.012 sec)

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
| FLUSH_OPTIMIZER_COSTS           | Server Admin                          |                                                                 |
| AUDIT_ADMIN                     | Server Admin                          |                                                                 |
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
77 rows in set (0.015 sec)

Bye
````

### evidence/53-firewall-uninstall.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'RESET')
--------------

Query OK, 0 rows affected (0.071 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------+-------------+
| NAME     | MODE | USERHOST    |
+----------+------+-------------+
| fw_agent | OFF  | ddv_agent@% |
+----------+------+-------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

Empty set (0.003 sec)

--------------
CALL ddv_sec.sp_firewall_group_remove('fw_agent')
--------------

Query OK, 0 rows affected (0.035 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

Empty set (0.004 sec)

--------------
REVOKE FIREWALL_ADMIN ON *.* FROM 'root'@'localhost'
--------------

Query OK, 0 rows affected (0.029 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
SELECT ID, USER, HOST, DB, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+------+---------+
| ID  | USER            | HOST            | DB   | COMMAND |
+-----+-----------------+-----------------+------+---------+
| 109 | root            | localhost:61650 | NULL | Query   |
|   7 | event_scheduler | localhost       | NULL | Daemon  |
+-----+-----------------+-----------------+------+---------+
2 rows in set, 1 warning (0.010 sec)

Bye
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
# This script uninstalls Enterprise Firewall component
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# and drops its tables and stored procedures.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
#
--------------

Query OK, 0 rows affected (0.001 sec)

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

Query OK, 0 rows affected (0.823 sec)

--------------
DROP PROCEDURE sp_set_firewall_group_mode
--------------

Query OK, 0 rows affected (0.046 sec)

--------------
DROP PROCEDURE sp_set_firewall_group_mode_and_user
--------------

Query OK, 0 rows affected (0.049 sec)

--------------
DROP PROCEDURE sp_reload_firewall_group_rules
--------------

Query OK, 0 rows affected (0.044 sec)

--------------
DROP PROCEDURE sp_firewall_group_enlist
--------------

Query OK, 0 rows affected (0.045 sec)

--------------
DROP PROCEDURE sp_firewall_group_delist
--------------

Query OK, 0 rows affected (0.040 sec)

--------------
DROP PROCEDURE sp_firewall_group_rename
--------------

Query OK, 0 rows affected (0.054 sec)

--------------
DROP PROCEDURE sp_firewall_group_remove
--------------

Query OK, 0 rows affected (0.037 sec)

--------------
DROP TABLE firewall_group_allowlist
--------------

Query OK, 0 rows affected (0.136 sec)

--------------
DROP TABLE firewall_groups
--------------

Query OK, 0 rows affected (0.151 sec)

--------------
DROP TABLE firewall_membership
--------------

Query OK, 0 rows affected (0.110 sec)

Bye
--------------
DROP SCHEMA ddv_sec
--------------

Query OK, 0 rows affected (0.105 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

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
3 rows in set (0.005 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

Empty set (0.029 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
| component_firewall.database     | ddv_sec        |
+---------------------------------+----------------+
2 rows in set (0.004 sec)

Bye
--------------
RESET PERSIST component_firewall.database
--------------

Query OK, 0 rows affected (0.091 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.004 sec)

Bye
````

### evidence/53-fw-llm-context.txt
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

### evidence/53-schema-create.txt
````text
--------------
CREATE SCHEMA ddv_sec
--------------

Query OK, 1 row affected (0.046 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

Bye
````

## Not captured

- The share scripts were run by input redirection from the server share folder; their absolute path is not in the evidence (the scripts are in evidence/45 and evidence/51).
- FIREWALL_ADMIN was granted to root@localhost for the test and revoked at the end; root grants are not part of the baseline snapshot, so the revoke is shown only in evidence/53-firewall-uninstall.txt.
- The firewall error log lines (component_firewall.trace was left OFF) and DETECTING mode were not tested.
- Only one group and one account; statements from the agent's own client startup are counted in the status variables and were not separated.
- Statement fingerprint rules in the allowlist are shown as the server prints them; whether other literal variations would match was not tested.
- The manual quotes (.local/manual-notes-step5.md) are uncommitted and were relayed by web-fetch subagents.
- No restart was performed or needed.

## Observations (Claude Code's reading, not evidence)

- Recording the four scripted questions produced 8 allowlist rules, of which 3 are the driver's own statements (SET NAMES, SET autocommit, SELECT sql_mode).
- In PROTECTING mode the four questions ran again and the five out-of-workflow selects were each denied with ERROR 6444 (28000) Access denied. The manual tutorial quotes a different text (ERROR 1045 Statement was blocked by Firewall).
- ddv_billing and root ran a harmless select unaffected.
- sp_set_firewall_group_mode_and_user created the group with the user but left firewall_membership empty until sp_firewall_group_enlist was called.
- The install persisted component_firewall.database; uninstall left that entry, and RESET PERSIST for that one variable removed it.
- The end state matches the baseline snapshot.
