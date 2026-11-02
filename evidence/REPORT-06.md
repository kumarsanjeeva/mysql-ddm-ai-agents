# REPORT-06: Step 4c, definer role isolation

Scratch schema ddv_probe3 and user ddv_owner2 were created and removed. No capture was repeated. The Part 0 baseline (evidence/50-baseline.txt, 51-component-scripts-rest.txt, sql/50-snapshot.sql) is included in this report because it was created in the same run.
The ddv_owner2 password is in gitignored .local files and is not captured.

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
2a98853945f57074a45d4138744e31bcdb5489adad6f5025182e95a0946bd575  evidence/50-baseline.txt
bf060bd6f3e6938afda81552aecc809911196fe3e5d73c68af6c271fbe26a252  evidence/51-component-scripts-rest.txt
caad39c28d2c4e4ea48c07be1562da5e82a353704406930f54150af1eaad18d6  evidence/52-after.txt
439e4e4edee379ab8f9c6776a5fe65d3658a18e50f93009f639b2d1d0f26fd18  evidence/52-cleanup.txt
6dd2fba8f0b1d4c6d9312bb7e8e7c0eb3e836e46102e7a1a4ca9c431b0662024  evidence/52-compare.txt
fa1641b71803b1c9e7364ed6947b81ba1754475ec1321621e5224c1ebf9b2b5d  evidence/52-setup-root.txt
5a082ba90e6c70e852f262d4ca8a5266d06a751c52c08ec37f42ffcb0519c23e  evidence/52-state1-agent.txt
198750f65e58eace9a089bbcc20315004697801e0092a8cae8cac9e3e60084bc  evidence/52-state1-owner.txt
11323919ff5f3b8083be60a55463340cce7f18c95b5070432788884eb51d9442  evidence/52-state1-root.txt
718bf8431e68dcfe7dcf6d0be2d0db65bfea0c609bf003c996ffbfccc3712222  evidence/52-state2-agent.txt
5a87bc3e2f5f4ad11a2f76de2ae9b708737957fef0a46b9b06767c6b92d99179  evidence/52-state2-owner.txt
f14e3a26e57cf1f365f00eb3fe53f767288aad7efde5c5511c1110cf17177278  evidence/52-state2-root.txt
c44edae51f832a3eb6a92651137b7edad51068c3cf524fbcc0ebf94c045e828a  evidence/52-state3-agent.txt
9c47d880bdf71814cfa1650db2e9ef588d847eb557e3127deb86887235d4144b  evidence/52-state3-owner.txt
abc245b318dc253e7c6b137be7a7e78ecbb6649cf879fbcb462b5341ad5533c0  evidence/52-state3-root.txt
997ab9d40e6cfbae2b8b02b7ae518fd468008d27e6139adbdd44f00c1937adc7  evidence/52-state4-agent.txt
764eedc853bfbe33e75d9a9e620d723ee239d7d0718e8ef6159e1bd48efccd67  evidence/52-state4-owner.txt
40655df77aeec5072d51ea71409ef22d010251f0f938f7812d0befd9c483b6f3  evidence/52-state4-root.txt
6e00930c9834a54bdd571c826076d5409774ed7365edc701756891ef5e07393e  sql/50-snapshot.sql
fc6bf0fcd7e92be3461a12bafb568a19dad1aa6768f26bc63b3a29e75c7b017f  sql/52-agent.sql
b0cae2b7a18733aad5119facec54fa8df723e1a2df30a689f0e18d99e25f57a2  sql/52-cleanup.sql
0db2594d9d9fda8c5536a4f343494ea8a4e68d48ef0db799df586585a1df8438  sql/52-create-owner2.template.sql
deed806ecd9af9d8a39d7fa1d34dc4bec0764df0fcfcaf3dbcb8d70d31142eaf  sql/52-owner.sql
52af816435d3bfeeb5007c9a85d2de1e87f144a7dfc376abc8205b7e81696529  sql/52-setup.sql
20e4d35425ac037374f942c0283a67cc5ede6e64fc75bc57d83a6fc245143e65  sql/52-state1-root.sql
8361a4889898f0a30f59a5d06250ebed29dfacd98bbf3938582881293a96d693  sql/52-state2-root.sql
e38fde03abf05fb7dec2897ad3d4e03c626c054b141160160d434eec9451a22c  sql/52-state3-root.sql
f3aece4fb4d47b570fc6fc2ac193739f6b1387a588288f762210994b424b5f25  sql/52-state4-root.sql
```

## Evidence (verbatim)

### evidence/50-baseline.txt
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
2 rows in set (0.030 sec)

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
7 rows in set (0.006 sec)

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
3 rows in set (0.008 sec)

--------------
SELECT PLUGIN_NAME, PLUGIN_STATUS FROM information_schema.PLUGINS WHERE PLUGIN_NAME LIKE '%audit%' OR PLUGIN_NAME LIKE '%firewall%'
--------------

Empty set (0.028 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

Empty set (0.065 sec)

--------------
SHOW VARIABLES LIKE '%audit%'
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
1 row in set (0.068 sec)

Bye
````

### evidence/51-component-scripts-rest.txt
````text
===== share\uninstall_component_firewall.sql (full)
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.

# This script uninstalls Enterprise Firewall component
# and drops its tables and stored procedures.
#
# NOTE: before running the script the following must be assured:
# 1) there is only a single connection (current)
# 2) the current database is @@component_firewall.database

UNINSTALL COMPONENT 'file://component_firewall';

DROP PROCEDURE sp_set_firewall_group_mode;
DROP PROCEDURE sp_set_firewall_group_mode_and_user;
DROP PROCEDURE sp_reload_firewall_group_rules;
DROP PROCEDURE sp_firewall_group_enlist;
DROP PROCEDURE sp_firewall_group_delist;
DROP PROCEDURE sp_firewall_group_rename;
DROP PROCEDURE sp_firewall_group_remove;

DROP TABLE firewall_group_allowlist;
DROP TABLE firewall_groups;
DROP TABLE firewall_membership;

===== share\install_component_firewall.sql (line 81 to end)

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

END //

# switches group operational mode, updates permanent storage accordingly
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

END //

# rebuilds in-memory cache of particular user firewall rules
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

END //

# enlists user to a group, updates permanent storage accordingly
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

END //

# removes user from a group, updates permanent storage accordingly
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

END //

# renames a group, updates permanent storage accordingly
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

END //

# removes a group, updates permanent storage accordingly
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

END //

delimiter ;
````

### evidence/52-after.txt
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
2 rows in set (0.012 sec)

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
5 rows in set (0.006 sec)

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

Empty set (0.005 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

Empty set (0.020 sec)

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
1 row in set (0.002 sec)

Bye
````

### evidence/52-cleanup.txt
````text
--------------
REVOKE SELECT ON ddv_probe3.v_owner2_definer FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.034 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
REVOKE EXECUTE ON PROCEDURE ddv_probe3.p_owner2 FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.023 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
REVOKE SELECT ON ddv_probe3.probe_people FROM 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.013 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
REVOKE EXECUTE ON PROCEDURE ddv_probe3.p_owner2 FROM 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.017 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
DROP SCHEMA ddv_probe3
--------------

Query OK, 2 rows affected (0.092 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
DROP MASKING POLICY IF EXISTS probe3_mask_email
--------------

Query OK, 0 rows affected (0.016 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
DROP MASKING POLICY IF EXISTS probe3_mask_phone
--------------

Query OK, 0 rows affected (0.016 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
DROP USER 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.021 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

Bye
````

### evidence/52-compare.txt
````text
Compare-Object evidence\50-baseline.txt evidence\52-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).
(no differences)
````

### evidence/52-setup-root.txt
````text
--------------
CREATE SCHEMA ddv_probe3
--------------

Query OK, 1 row affected (0.059 sec)

--------------
USE ddv_probe3
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
CREATE TABLE probe_people (
  id INT PRIMARY KEY,
  email VARCHAR(100),
  phone VARCHAR(20),
  notes TEXT
)
--------------

Query OK, 0 rows affected (0.124 sec)

--------------
INSERT INTO probe_people VALUES
  (1, 'mark.zzzz@example.test', '555-0101', 'note one'),
  (2, 'mark.aaaa@example.test', '777-0101', 'note two'),
  (3, 'lena.mmmm@example.test', '555-0303', 'note three')
--------------

Query OK, 3 rows affected (0.040 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE MASKING POLICY probe3_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END
--------------

Query OK, 0 rows affected (0.022 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE MASKING POLICY probe3_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.024 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
ALTER TABLE probe_people MODIFY COLUMN email VARCHAR(100) MASKING POLICY probe3_mask_email
--------------

Query OK, 0 rows affected (0.062 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE probe_people MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe3_mask_phone
--------------

Query OK, 0 rows affected (0.039 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
GRANT SELECT ON ddv_probe3.probe_people TO 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.022 sec)

--------------
CREATE DEFINER='ddv_owner2'@'%' SQL SECURITY DEFINER VIEW v_owner2_definer AS SELECT * FROM probe_people
--------------

Query OK, 0 rows affected (0.025 sec)

--------------
CREATE DEFINER='ddv_owner2'@'%' PROCEDURE p_owner2() SQL SECURITY DEFINER SELECT * FROM probe_people
--------------

Query OK, 0 rows affected (0.026 sec)

--------------
GRANT EXECUTE ON PROCEDURE ddv_probe3.p_owner2 TO 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.017 sec)

--------------
GRANT SELECT ON ddv_probe3.v_owner2_definer TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.015 sec)

--------------
GRANT EXECUTE ON PROCEDURE ddv_probe3.p_owner2 TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.017 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+-----------------------------------------------------------------------+
| Grants for ddv_agent@%                                                |
+-----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                                 |
| GRANT SELECT ON `ddv_probe3`.`v_owner2_definer` TO `ddv_agent`@`%`    |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`          |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`             |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`           |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%`    |
| GRANT EXECUTE ON PROCEDURE `ddv_probe3`.`p_owner2` TO `ddv_agent`@`%` |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                        |
+-----------------------------------------------------------------------+
8 rows in set (0.001 sec)

--------------
SHOW GRANTS FOR 'ddv_owner2'@'%'
--------------

+------------------------------------------------------------------------+
| Grants for ddv_owner2@%                                                |
+------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_owner2`@`%`                                 |
| GRANT SELECT ON `ddv_probe3`.`probe_people` TO `ddv_owner2`@`%`        |
| GRANT EXECUTE ON PROCEDURE `ddv_probe3`.`p_owner2` TO `ddv_owner2`@`%` |
+------------------------------------------------------------------------+
3 rows in set (0.001 sec)

--------------
SHOW CREATE VIEW ddv_probe3.v_owner2_definer
--------------

+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| View             | Create View                                                                                                                                                                                                                                                      | character_set_client | collation_connection |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| v_owner2_definer | CREATE ALGORITHM=UNDEFINED DEFINER=`ddv_owner2`@`%` SQL SECURITY DEFINER VIEW `v_owner2_definer` AS select `probe_people`.`id` AS `id`,`probe_people`.`email` AS `email`,`probe_people`.`phone` AS `phone`,`probe_people`.`notes` AS `notes` from `probe_people` | utf8mb4              | utf8mb4_0900_ai_ci   |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
1 row in set (0.002 sec)

--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe3%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe3_mask_email |
| probe3_mask_phone |
+-------------------+
2 rows in set (0.004 sec)

Bye
````

### evidence/52-state1-agent.txt
````text
--------------
USE ddv_probe3
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.002 sec)

--------------
SELECT * FROM v_owner2_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.017 sec)

--------------
CALL p_owner2()
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.007 sec)

Query OK, 0 rows affected (0.007 sec)

Bye
````

### evidence/52-state1-owner.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_owner2@%   | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.004 sec)

Bye
````

### evidence/52-state1-root.txt
````text
--------------
GRANT 'r_billing_admin'@'%' TO 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.054 sec)

--------------
SET DEFAULT ROLE 'r_billing_admin'@'%' TO 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.022 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SHOW GRANTS FOR 'ddv_owner2'@'%'
--------------

+------------------------------------------------------------------------+
| Grants for ddv_owner2@%                                                |
+------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_owner2`@`%`                                 |
| GRANT SELECT ON `ddv_probe3`.`probe_people` TO `ddv_owner2`@`%`        |
| GRANT EXECUTE ON PROCEDURE `ddv_probe3`.`p_owner2` TO `ddv_owner2`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_owner2`@`%`                        |
+------------------------------------------------------------------------+
4 rows in set (0.002 sec)

Bye
````

### evidence/52-state2-agent.txt
````text
--------------
USE ddv_probe3
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.002 sec)

--------------
SELECT * FROM v_owner2_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | m********@example.test | ****0101 | note one   |
|  2 | m********@example.test | ****0101 | note two   |
|  3 | l********@example.test | ****0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.005 sec)

--------------
CALL p_owner2()
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | m********@example.test | ****0101 | note one   |
|  2 | m********@example.test | ****0101 | note two   |
|  3 | l********@example.test | ****0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.003 sec)

Query OK, 0 rows affected (0.003 sec)

Bye
````

### evidence/52-state2-owner.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_owner2@%   | NONE           |
+----------------+----------------+
1 row in set (0.002 sec)

Bye
````

### evidence/52-state2-root.txt
````text
--------------
SET DEFAULT ROLE NONE TO 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.089 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SHOW GRANTS FOR 'ddv_owner2'@'%'
--------------

+------------------------------------------------------------------------+
| Grants for ddv_owner2@%                                                |
+------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_owner2`@`%`                                 |
| GRANT SELECT ON `ddv_probe3`.`probe_people` TO `ddv_owner2`@`%`        |
| GRANT EXECUTE ON PROCEDURE `ddv_probe3`.`p_owner2` TO `ddv_owner2`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_owner2`@`%`                        |
+------------------------------------------------------------------------+
4 rows in set (0.002 sec)

Bye
````

### evidence/52-state3-agent.txt
````text
--------------
USE ddv_probe3
--------------

Query OK, 0 rows affected (0.009 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.003 sec)

--------------
SELECT * FROM v_owner2_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | m********@example.test | ****0101 | note one   |
|  2 | m********@example.test | ****0101 | note two   |
|  3 | l********@example.test | ****0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.010 sec)

--------------
CALL p_owner2()
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | m********@example.test | ****0101 | note one   |
|  2 | m********@example.test | ****0101 | note two   |
|  3 | l********@example.test | ****0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.006 sec)

Query OK, 0 rows affected (0.006 sec)

Bye
````

### evidence/52-state3-owner.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_owner2@%   | NONE           |
+----------------+----------------+
1 row in set (0.001 sec)

Bye
````

### evidence/52-state3-root.txt
````text
--------------
REVOKE 'r_billing_admin'@'%' FROM 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.058 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SHOW GRANTS FOR 'ddv_owner2'@'%'
--------------

+------------------------------------------------------------------------+
| Grants for ddv_owner2@%                                                |
+------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_owner2`@`%`                                 |
| GRANT SELECT ON `ddv_probe3`.`probe_people` TO `ddv_owner2`@`%`        |
| GRANT EXECUTE ON PROCEDURE `ddv_probe3`.`p_owner2` TO `ddv_owner2`@`%` |
+------------------------------------------------------------------------+
3 rows in set (0.001 sec)

Bye
````

### evidence/52-state4-agent.txt
````text
--------------
USE ddv_probe3
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.007 sec)

--------------
SELECT * FROM v_owner2_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.004 sec)

--------------
CALL p_owner2()
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.003 sec)

Query OK, 0 rows affected (0.003 sec)

Bye
````

### evidence/52-state4-owner.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_owner2@%   | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.002 sec)

Bye
````

### evidence/52-state4-root.txt
````text
--------------
GRANT 'r_billing_admin'@'%' TO 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.036 sec)

--------------
SET DEFAULT ROLE ALL TO 'ddv_owner2'@'%'
--------------

Query OK, 0 rows affected (0.019 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SHOW GRANTS FOR 'ddv_owner2'@'%'
--------------

+------------------------------------------------------------------------+
| Grants for ddv_owner2@%                                                |
+------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_owner2`@`%`                                 |
| GRANT SELECT ON `ddv_probe3`.`probe_people` TO `ddv_owner2`@`%`        |
| GRANT EXECUTE ON PROCEDURE `ddv_probe3`.`p_owner2` TO `ddv_owner2`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_owner2`@`%`                        |
+------------------------------------------------------------------------+
4 rows in set (0.001 sec)

Bye
````

## Not captured

- Manual notes (.local/manual-notes-step5.md) are uncommitted; quotes were relayed by web-fetch subagents.
- Only one definer account design was tested (ddv_owner2, default roles changed four ways); other roles, activate_all_roles_on_login and mandatory_roles were not tested.
- Each state was run once with 3 rows.
- The owner and agent connections in each state were new connections; sessions that stayed open across a role change were not tested.
- The compare strips (n.nnn sec) timings only.

## Observations (Claude Code's reading, not evidence)

- In states 1 and 4 (billing role active as the definer's default role) the agent got real email, phone and notes from the definer view and procedure. In states 2 and 3 (role granted but default NONE; role revoked) the agent got masked rows from both.
- That reads as the definer's active (default) roles deciding the result, not the invoker's role and not mere possession of the role grant.
- State 4 returned to the state 1 result.
- The agent held no privilege on the base table in any state.
