# REPORT-12: Step 8b: ALTER and masking-policy attach, with user identity captured

Scope: schema `ddv_probe5`, user `ddv_alterer2`, policies `probe5_*`. No Firewall, no Audit. Every statement file begins with `SELECT CURRENT_USER(), CURRENT_ROLE();`. Runs were captured with stdout and stderr (2>&1) through cmd with `mysql --table -vvv --force`. Nothing pushed, no restarts.

Docs changes in the same commit (docs/FINDINGS.md, not hashed here): F78 reworded (80-a3 ran on a column that already carried the policy; the Step 8 statement files do not print CURRENT_USER(); the clean test is in 91-*), F71 softened (+3 denied in 82-inject-or-status-*; cause of the extra denial unexplained), F93 to F101 and index rows appended, section 7 and F76 extended.

Root restores between steps: none. S1 to S5 ran in order on the same table with no restore.

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
62623ca31315ee782b4c0146db1e2e867303931b0ba80fb193b790d2a7fe726a  evidence/90-baseline.txt
685630efab75e0f64c9ac86e5df6f9805644a46a52b2842215ee7af079af19d6  evidence/90-grants-root.txt
99aca799127d96455f00e31665b0a2b908e86bcb44f6d2dae020c22476cad983  evidence/90-setup-1-root.txt
ce8c75d9662775fa457236d3ce9ebca053bdd62965c1fa7ff01e636b473e435f  evidence/90-setup-2-open-root.txt
8d8331ada57bc7891aa00852b48c7389f0b09b86afa70b060a6a981274865701  evidence/91-s1-root-policies.txt
e7c6c79c5d640e8662eefd94a673560fc316ce76dcb4cecfdd2ef7938e11e2d9  evidence/91-s1-stmt.txt
0f0687b00411b7a9dc3303088d1115091f24237e88eac79aedf40bf0947e8846  evidence/91-s2-root-policies.txt
e8a27cee3656c362698476e377abf2e0ac07893508eaa645a17d7a5d043a1161  evidence/91-s2-stmt.txt
4e8d0a2502b2e7b253cc56fbc7f727f6a3481d4fe104940fcf0f161e470a58d5  evidence/91-s3-root-policies.txt
56d16930b3f9c6ffc6595274e1e82f0a752855f34be25c33679accf4e3666f00  evidence/91-s3-stmt.txt
e3ce95be36234abdc5e2e07b0d935cb0f70547eb06e8be4b8a7633d601434124  evidence/91-s4-root-policies.txt
874c7d59c87cc3a38943381005f2d467c5c293bba17a3b47f6d49928e2c93ac4  evidence/91-s4-stmt.txt
244ed68c69e7053f10957c089e4b23d9f929c248d5fbd372fb175433bbb3e9f0  evidence/91-s5-root-policies.txt
b69ef597d0a3d670eaaf2c040c109f035ba18f661537b92d243572577cc798d1  evidence/91-s5-stmt.txt
dec7fd20e7839d2338fad1210ae2e96421dfeb37afac962115b0baa8ae38c27e  evidence/91-s6a-root-policies.txt
288df590615cf4315659fae975b5f50494e20a4fb859f99490e97be0f2722872  evidence/91-s6a-stmt.txt
dec7fd20e7839d2338fad1210ae2e96421dfeb37afac962115b0baa8ae38c27e  evidence/91-s6b-root-policies.txt
2b5b9218ba041dc14edcfeac1df57c83a986be253df4df1a420529aee813c24d  evidence/91-s6b-stmt.txt
b58ad5e36b64eb59137653dc83e30cdd283b319e65cb77f313bf90015709839b  evidence/91-s7-root-policies.txt
3f8a7ac23f429e35d4d6ad43c5569691dda06db0b395ab95feb322a9e3dc9195  evidence/91-s7-stmt.txt
2a28f83948e75d91d992fde6e5e3796e553250b927cf1038265cc6c9ea646a1c  evidence/92-after.txt
e761ec1c47f29ce5089f229238eba96aee470db482e9e6a07ad46786f4638608  evidence/92-cleanup.txt
29914b38052028673a59a8f255637e41df00c15192ef7e2ead6623eef9b3c679  evidence/92-compare.txt
378803f841c67d1122647bf6b4d7b678bb709b45926829cc9b867a2182fc14fb  sql/90-create-alterer2.template.sql
2b92568962d9d351a700ed8f763aab2f04c5c67fadbcb6c7b4ab97ad1e16be9b  sql/90-grants.sql
14c698f4811d73a2bea38bec922c1755a0a6cd6ee899bbde47663de575b4a5bd  sql/90-setup-1.sql
51cfbdb015ecbec02490692894065c9b09a0cd22ed2880fb7c8c945f2279164f  sql/90-setup-2-open.sql
3c250d8d41229a7cb74c4610503ab745963997f1c9b5c4dd75d933f89e204240  sql/91-root-policies.sql
e4d1a9bb6b9f23ff8298b40c19ff3f88ef55fa364dc31323b56e58fedadffe8f  sql/91-s1-stmt.sql
9bb587e8412d78833744be5e672690900c7e878a8ee5ad099c5f1c0487dd6808  sql/91-s2-stmt.sql
e4d1a9bb6b9f23ff8298b40c19ff3f88ef55fa364dc31323b56e58fedadffe8f  sql/91-s3-stmt.sql
07f522b6874069ce6213b883005b510c5a3838569953ef3e898f7cf6cdaf7e99  sql/91-s4-stmt.sql
9bb587e8412d78833744be5e672690900c7e878a8ee5ad099c5f1c0487dd6808  sql/91-s5-stmt.sql
8a4ed44b23f187a9ac3d9c67ce739fc9142f2c9c31146aef2b244591b8c382dd  sql/91-s6a-stmt.sql
0ce550e5ad3e807fd4bc1cb15fa34666841764445d56b1ec04997b3473524dad  sql/91-s6b-stmt.sql
d1f8ddd823591ba660928548e3eb813ac360a7352c9bd94bed8b782790eda4d6  sql/91-s7-stmt.sql
a801b7657f6f7b7315ef06f3058c5be43b77931b4189bb5534a6ae8eeffbbc6b  sql/92-cleanup.sql
```

## Evidence (verbatim)

### evidence/90-baseline.txt
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
3 rows in set (0.104 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.333 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.328 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.034 sec)

--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
| 377 | root            | localhost:51515 | Query   |
|   7 | event_scheduler | localhost       | Daemon  |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.089 sec)

Bye
````

### evidence/90-grants-root.txt
````text
--------------
SHOW GRANTS FOR 'ddv_alterer2'@'%'
--------------

+-----------------------------------------------------------------------------------------+
| Grants for ddv_alterer2@%                                                               |
+-----------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_alterer2`@`%`                                                |
| GRANT SELECT, INSERT, UPDATE, ALTER ON `ddv_probe5`.`probe_alter` TO `ddv_alterer2`@`%` |
+-----------------------------------------------------------------------------------------+
2 rows in set (0.002 sec)

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

Bye
````

### evidence/90-setup-1-root.txt
````text
--------------
CREATE SCHEMA ddv_probe5
--------------

Query OK, 1 row affected (0.193 sec)

--------------
USE ddv_probe5
--------------

Query OK, 0 rows affected (0.007 sec)

--------------
CREATE TABLE probe_alter (
  id INT PRIMARY KEY,
  phone VARCHAR(20),
  notes TEXT
)
--------------

Query OK, 0 rows affected (0.270 sec)

--------------
INSERT INTO probe_alter VALUES
  (1, '555-0101', 'note one'),
  (2, '777-0101', 'note two'),
  (3, '555-0303', 'note three')
--------------

Query OK, 3 rows affected (0.054 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
CREATE MASKING POLICY probe5_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.058 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe5_mask_phone
--------------

Query OK, 0 rows affected (0.073 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe5_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.003 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.003 sec)

Bye
````

### evidence/90-setup-2-open-root.txt
````text
--------------
CREATE MASKING POLICY probe5_open(phone_column)
CASE WHEN CURRENT_USER_IN('nobody@nowhere')
     THEN phone_column
     ELSE phone_column
END
--------------

Query OK, 0 rows affected (0.034 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.007 sec)

Bye
````

### evidence/91-s1-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.028 sec)

Bye
````

### evidence/91-s1-stmt.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_alterer2@% | NONE           |
+----------------+----------------+
1 row in set (0.010 sec)

--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20)
--------------

Query OK, 0 rows affected (0.195 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                  |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.006 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | 555-0101 | note one   |
|  2 | 777-0101 | note two   |
|  3 | 555-0303 | note three |
+----+----------+------------+
3 rows in set (0.004 sec)

Bye
````

### evidence/91-s2-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.020 sec)

Bye
````

### evidence/91-s2-stmt.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_alterer2@% | NONE           |
+----------------+----------------+
1 row in set (0.004 sec)

--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe5_mask_phone
--------------

Query OK, 0 rows affected (0.150 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe5_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.006 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.005 sec)

Bye
````

### evidence/91-s3-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.007 sec)

Bye
````

### evidence/91-s3-stmt.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_alterer2@% | NONE           |
+----------------+----------------+
1 row in set (0.003 sec)

--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20)
--------------

Query OK, 0 rows affected (0.164 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                  |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.010 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | 555-0101 | note one   |
|  2 | 777-0101 | note two   |
|  3 | 555-0303 | note three |
+----+----------+------------+
3 rows in set (0.003 sec)

Bye
````

### evidence/91-s4-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.032 sec)

Bye
````

### evidence/91-s4-stmt.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_alterer2@% | NONE           |
+----------------+----------------+
1 row in set (0.004 sec)

--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe5_open
--------------

Query OK, 0 rows affected (0.199 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                               |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe5_open` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.007 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | 555-0101 | note one   |
|  2 | 777-0101 | note two   |
|  3 | 555-0303 | note three |
+----+----------+------------+
3 rows in set (0.006 sec)

Bye
````

### evidence/91-s5-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.008 sec)

Bye
````

### evidence/91-s5-stmt.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_alterer2@% | NONE           |
+----------------+----------------+
1 row in set (0.004 sec)

--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe5_mask_phone
--------------

Query OK, 0 rows affected (0.153 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe5_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.005 sec)

Bye
````

### evidence/91-s6a-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.005 sec)

Bye
````

### evidence/91-s6a-stmt.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_alterer2@% | NONE           |
+----------------+----------------+
1 row in set (0.004 sec)

--------------
CREATE MASKING POLICY probe5_try(c) CASE WHEN CURRENT_ROLE_IN('x') THEN c ELSE mask_inner(c, 0, 4, '*') END
--------------

ERROR 1227 (42000) at line 2: Access denied; you need (at least one of) the MANAGE_DATA_MASKING_POLICY privilege(s) for this operation
--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe5_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.007 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.004 sec)

Bye
````

### evidence/91-s6b-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.005 sec)

Bye
````

### evidence/91-s6b-stmt.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_alterer2@% | NONE           |
+----------------+----------------+
1 row in set (0.004 sec)

--------------
DROP MASKING POLICY probe5_mask_phone
--------------

ERROR 1227 (42000) at line 2: Access denied; you need (at least one of) the MANAGE_DATA_MASKING_POLICY privilege(s) for this operation
--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe5_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.013 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.007 sec)

Bye
````

### evidence/91-s7-root-policies.txt
````text
--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe5_mask_phone |
| probe5_open       |
+-------------------+
2 rows in set (0.015 sec)

Bye
````

### evidence/91-s7-stmt.txt
````text
--------------
SELECT CURRENT_USER()
--------------

+----------------+
| CURRENT_USER() |
+----------------+
| ddv_agent@%    |
+----------------+
1 row in set (0.004 sec)

--------------
ALTER TABLE ddv_probe5.probe_alter MODIFY COLUMN phone VARCHAR(20)
--------------

ERROR 1142 (42000) at line 2: ALTER command denied to user 'ddv_agent'@'localhost' for table 'probe_alter'
--------------
SHOW GRANTS
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
6 rows in set (0.003 sec)

Bye
````

### evidence/92-after.txt
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
3 rows in set (0.032 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.039 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.065 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.009 sec)

--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
| 404 | root            | localhost:53065 | Query   |
|   7 | event_scheduler | localhost       | Daemon  |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.016 sec)

Bye
````

### evidence/92-cleanup.txt
````text
--------------
REVOKE SELECT, INSERT, UPDATE, ALTER ON ddv_probe5.probe_alter FROM 'ddv_alterer2'@'%'
--------------

Query OK, 0 rows affected (0.105 sec)

--------------
DROP SCHEMA IF EXISTS ddv_probe5
--------------

Query OK, 1 row affected (0.312 sec)

--------------
DROP MASKING POLICY IF EXISTS probe5_mask_phone
--------------

Query OK, 0 rows affected (0.037 sec)

--------------
DROP MASKING POLICY IF EXISTS probe5_open
--------------

Query OK, 0 rows affected (0.101 sec)

--------------
DROP MASKING POLICY IF EXISTS probe5_try
--------------

Query OK, 0 rows affected, 1 warning (0.090 sec)

--------------
DROP USER IF EXISTS 'ddv_alterer2'@'%'
--------------

Query OK, 0 rows affected (0.195 sec)

--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%'
--------------

Empty set (0.009 sec)

--------------
SHOW DATABASES LIKE 'ddv_probe5'
--------------

Empty set (0.047 sec)

--------------
SELECT user FROM mysql.user WHERE user LIKE 'ddv_alterer%'
--------------

Empty set (0.015 sec)

Bye
````

### evidence/92-compare.txt
````text
Compare-Object evidence\90-baseline.txt evidence\92-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).

InputObject                                           SideIndicator
-----------                                           -------------
| 404 | root            | localhost:53065 | Query   | =>           
| 377 | root            | localhost:51515 | Query   | <=
````

## Not captured

- The creation of `ddv_alterer2` (CREATE USER with a password and the GRANT) ran with the client echo off; only the template sql/90-create-alterer2.template.sql is in the repo, and the SHOW GRANTS capture is in evidence/90-grants-root.txt.
- The text of the one warning returned by `DROP MASKING POLICY IF EXISTS probe5_try` in 92-cleanup.txt (SHOW WARNINGS was not run).
- The password of `ddv_alterer2` and the client configuration file (both in .local, gitignored).
- No test of `ALTER COLUMN ... DROP MASKING POLICY`, column drops, or reads of `probe5_open` by other accounts.

## Observations (Claude Code's reading, not evidence)

- S2 and S5 are attach runs by `ddv_alterer2@%` with no role; S6 shows the same account refused with ERROR 1227 on CREATE and DROP MASKING POLICY. These are the output of the captured files; the privilege model behind them is not documented, so no conclusion about it is drawn here.
- S3 and S1 show the clause-less MODIFY removing the policy, as in Step 8 (F77), now with the account printed.
- S4 shows the server accepted `probe5_open` and the attach; the 90-setup-2 file shows no warning for it.
