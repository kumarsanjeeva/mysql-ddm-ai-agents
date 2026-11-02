# REPORT-05: definer, copy-out, indexed-column tests and Audit/Firewall script review

Scratch schema ddv_probe2 and user ddv_owner were created and removed in this step.

## Repeat, stated plainly

- The first agent run (evidence/41-agent-select.txt) failed on `CALL p_owner()` with `ERROR 1370 (42000): execute command denied to user 'ddv_owner'@'%' for routine 'ddv_probe2.p_owner'`.
- The spec had not given ddv_owner EXECUTE on the procedure. After the user approved, EXECUTE was granted as root afterwards (evidence/41-owner-execute-grant.txt), and the whole agent file was re-run (evidence/41-agent-select-rerun.txt).
- Both captures are kept. 41-agent-select.txt was not edited.

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
d28fa19560f278513c0c585946cb8721ef1c069383490a6baa56e69c81babd4f  evidence/40-before.txt
51ae20186405a0dd370198731117964db038e19e9130e992ed73410ab7f0b0a2  evidence/41-agent-select.txt
c9f0146b5ca1937db2f07c3c9524e80de037e1096ec16e0f069fd890ceed55c4  evidence/41-agent-select-rerun.txt
8a5057d62f6c40165a3ae1eccee6c1677bc4dfc736bcbeae5812691b9721236a  evidence/41-owner-execute-grant.txt
afa2d53185dac902a617bc274f3ef354e23170028d94b91a8265f35ce2f8beda  evidence/41-owner-select.txt
0d0212a29e32f6dda8fa35957beeafc90ba85e186084d924e8869f09d50b749e  evidence/41-setup-root.txt
20fab5f98e794a1246a41e448d8d4fefe98d7a6a7d2caded82c3f180f33fbe72  evidence/42-copy-out-1-agent-insert.txt
5bc8e99c2e790a736b5de91e2dee9b1a98b886270ab231ed81e2060503e9ce39  evidence/42-copy-out-2-billing-select.txt
e5448f4d29f908dc841d133600041727ee936512b35938b19babff30d34edaaa  evidence/42-copy-out-3-billing-delete.txt
b026e4dc27d3e50771f7855ebc689ffbf4dcb7d184044f943e6a15f82768dfae  evidence/42-copy-out-4-billing-insert.txt
e5af5a4cdc09c3e76f844946f10b9cd2a8f75e0aad2c55edff41ab19469401b9  evidence/42-copy-out-5-agent-select.txt
f74c6a7407e31905c40201a5ed244ff724a29b0a24ff70c6b78e717578713198  evidence/42-copy-out-setup-root.txt
39ef4525b4872df3a9c32c3af8f93228bbd79890704871cf02ff39246f455cdc  evidence/43-indexed-columns.txt
95cf356446347452f9dba1364075785c70feea64b3223d86d66347c4a53f2d96  evidence/45-component-scripts.txt
544dc985305a5f40311b51c3f8ec5c6fbe937ebf79dbf4cd43f2fad11360377b  evidence/46-cleanup.txt
539c24d9781afb35371f14c526936465a201cacd7223c1b2b4db8e3df89c0330  evidence/47-after.txt
74856b3644a545970127a7a021a07c160a8934ee818652a60bbc7245cda61f7c  evidence/48-compare.txt
7fde7bdbfeba8205cdb5c177d406e5f3448f78209bc39b1f03e8d26c8b7a8be0  sql/40-snapshot.sql
40e923f695052a3988b451fdf1015995258ef7ce44ebea5a7c3723ab7a98b4ea  sql/41-agent-select.sql
e1e30b1f5172a3c5251e1f68a807b77a68b3ad8494e81b1aa7787e17e45c4763  sql/41-create-owner.template.sql
dd3878a819ee84b33fba62c8176f92a39fa3de1be01993b920dc17daae4be31e  sql/41-owner-execute-grant.sql
8ee5f38ad5625d63f1f325c5813208381ee9dff411cebed89ee80c8a501e63a1  sql/41-owner-select.sql
66d49c4ddb74bb68c27443b554034a070144e90518f00aa4d9104bbf4e089bde  sql/41-owner-setup.sql
0053923d5e1f44fa8df08b0bea81c514b9a16769fb2f4d9d94b82ad795d5694b  sql/42-copy-out-1-agent-insert.sql
24b4c2238512cfb774c66d43e50f1b547c0ba10bd32603bd14e6aef753a223dc  sql/42-copy-out-2-billing-select.sql
739a9c47efe534c14177e2e69715f92181e676a91e1d4de0728592dda282d981  sql/42-copy-out-3-billing-delete.sql
71cfb60eda866cccbfd0a20eb00fb4722d03a474c4f52bfa782d1068f6ae50bf  sql/42-copy-out-4-billing-insert.sql
24b4c2238512cfb774c66d43e50f1b547c0ba10bd32603bd14e6aef753a223dc  sql/42-copy-out-5-agent-select.sql
9e4bd9c86f63965fb43f1e909a09a972bc67983734daf17879fc7910c324c38f  sql/42-copy-out-setup.sql
ffc7e196ea33384c8135d7b222c1df68f80c9ec46ef712da4c3e82d7fe51ae8e  sql/43-indexed-columns.sql
8aa78a47407445cddc62eed942c940d7529c4e40ad70d8c153d47fb760194380  sql/46-cleanup.sql
```

## Evidence (verbatim)

### evidence/40-before.txt
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
2 rows in set (0.025 sec)

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
7 rows in set (0.009 sec)

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
6 rows in set (0.004 sec)

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
6 rows in set (0.003 sec)

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
5 rows in set (0.003 sec)

Bye
````

### evidence/41-agent-select.txt
````text
--------------
USE ddv_probe2
--------------

Query OK, 0 rows affected (0.013 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM v_owner_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.011 sec)

--------------
CALL p_owner()
--------------

ERROR 1370 (42000) at line 4: execute command denied to user 'ddv_owner'@'%' for routine 'ddv_probe2.p_owner'
--------------
SELECT notes FROM probe_people
--------------

ERROR 1143 (42000) at line 5: SELECT command denied to user 'ddv_agent'@'localhost' for column 'notes' in table 'probe_people'
--------------
SELECT notes FROM v_owner_definer
--------------

+------------+
| notes      |
+------------+
| note one   |
| note two   |
| note three |
+------------+
3 rows in set (0.003 sec)

Bye
````

### evidence/41-agent-select-rerun.txt
````text
--------------
USE ddv_probe2
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
SELECT * FROM v_owner_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.009 sec)

--------------
CALL p_owner()
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

--------------
SELECT notes FROM probe_people
--------------

ERROR 1143 (42000) at line 5: SELECT command denied to user 'ddv_agent'@'localhost' for column 'notes' in table 'probe_people'
--------------
SELECT notes FROM v_owner_definer
--------------

+------------+
| notes      |
+------------+
| note one   |
| note two   |
| note three |
+------------+
3 rows in set (0.003 sec)

Bye
````

### evidence/41-owner-execute-grant.txt
````text
--------------
GRANT EXECUTE ON PROCEDURE ddv_probe2.p_owner TO 'ddv_owner'@'%'
--------------

Query OK, 0 rows affected (0.196 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
SHOW GRANTS FOR 'ddv_owner'@'%'
--------------

+----------------------------------------------------------------------+
| Grants for ddv_owner@%                                               |
+----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_owner`@`%`                                |
| GRANT SELECT ON `ddv_probe2`.`probe_people` TO `ddv_owner`@`%`       |
| GRANT EXECUTE ON PROCEDURE `ddv_probe2`.`p_owner` TO `ddv_owner`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_owner`@`%`                       |
+----------------------------------------------------------------------+
4 rows in set (0.012 sec)

Bye
````

### evidence/41-owner-select.txt
````text
--------------
USE ddv_probe2
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_owner@%    | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM probe_people
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.008 sec)

Bye
````

### evidence/41-setup-root.txt
````text
--------------
CREATE SCHEMA ddv_probe2
--------------

Query OK, 1 row affected (0.092 sec)

--------------
USE ddv_probe2
--------------

Query OK, 0 rows affected (0.008 sec)

--------------
CREATE TABLE probe_people (
  id INT PRIMARY KEY,
  email VARCHAR(100),
  phone VARCHAR(20),
  notes TEXT
)
--------------

Query OK, 0 rows affected (0.460 sec)

--------------
INSERT INTO probe_people VALUES
  (1, 'mark.zzzz@example.test', '555-0101', 'note one'),
  (2, 'mark.aaaa@example.test', '777-0101', 'note two'),
  (3, 'lena.mmmm@example.test', '555-0303', 'note three')
--------------

Query OK, 3 rows affected (0.044 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
CREATE MASKING POLICY probe_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END
--------------

Query OK, 0 rows affected (0.036 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE MASKING POLICY probe_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.029 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
ALTER TABLE probe_people MODIFY COLUMN email VARCHAR(100) MASKING POLICY probe_mask_email
--------------

Query OK, 0 rows affected (0.094 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE probe_people MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe_mask_phone
--------------

Query OK, 0 rows affected (0.101 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
GRANT 'r_billing_admin'@'%' TO 'ddv_owner'@'%'
--------------

Query OK, 0 rows affected (0.074 sec)

--------------
SET DEFAULT ROLE 'r_billing_admin'@'%' TO 'ddv_owner'@'%'
--------------

Query OK, 0 rows affected (0.063 sec)

--------------
GRANT SELECT ON ddv_probe2.probe_people TO 'ddv_owner'@'%'
--------------

Query OK, 0 rows affected (0.018 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE DEFINER='ddv_owner'@'%' SQL SECURITY DEFINER VIEW v_owner_definer AS SELECT * FROM probe_people
--------------

Query OK, 0 rows affected (0.035 sec)

--------------
CREATE DEFINER='ddv_owner'@'%' PROCEDURE p_owner() SQL SECURITY DEFINER SELECT * FROM probe_people
--------------

Query OK, 0 rows affected (0.059 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
GRANT SELECT (id, email, phone) ON ddv_probe2.probe_people TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.028 sec)

--------------
GRANT SELECT ON ddv_probe2.v_owner_definer TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.025 sec)

--------------
GRANT EXECUTE ON PROCEDURE ddv_probe2.p_owner TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.018 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+-----------------------------------------------------------------------------------------+
| Grants for ddv_agent@%                                                                  |
+-----------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                                                   |
| GRANT SELECT (`email`, `id`, `phone`) ON `ddv_probe2`.`probe_people` TO `ddv_agent`@`%` |
| GRANT SELECT ON `ddv_probe2`.`v_owner_definer` TO `ddv_agent`@`%`                       |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`                            |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`                               |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`                             |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%`                      |
| GRANT EXECUTE ON PROCEDURE `ddv_probe2`.`p_owner` TO `ddv_agent`@`%`                    |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                                          |
+-----------------------------------------------------------------------------------------+
9 rows in set (0.004 sec)

--------------
SHOW GRANTS FOR 'ddv_owner'@'%'
--------------

+----------------------------------------------------------------+
| Grants for ddv_owner@%                                         |
+----------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_owner`@`%`                          |
| GRANT SELECT ON `ddv_probe2`.`probe_people` TO `ddv_owner`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_owner`@`%`                 |
+----------------------------------------------------------------+
3 rows in set (0.003 sec)

--------------
SHOW CREATE VIEW ddv_probe2.v_owner_definer
--------------

+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| View            | Create View                                                                                                                                                                                                                                                    | character_set_client | collation_connection |
+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
| v_owner_definer | CREATE ALGORITHM=UNDEFINED DEFINER=`ddv_owner`@`%` SQL SECURITY DEFINER VIEW `v_owner_definer` AS select `probe_people`.`id` AS `id`,`probe_people`.`email` AS `email`,`probe_people`.`phone` AS `phone`,`probe_people`.`notes` AS `notes` from `probe_people` | utf8mb4              | utf8mb4_0900_ai_ci   |
+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------+----------------------+
1 row in set (0.011 sec)

Bye
````

### evidence/42-copy-out-1-agent-insert.txt
````text
--------------
USE ddv_probe2
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
INSERT INTO probe_sink SELECT id, email, phone FROM probe_people
--------------

Query OK, 3 rows affected (0.068 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SELECT * FROM probe_sink
--------------

+------+------------------------+----------+
| id   | email                  | phone    |
+------+------------------------+----------+
|    1 | m********@example.test | ****0101 |
|    2 | m********@example.test | ****0101 |
|    3 | l********@example.test | ****0303 |
+------+------------------------+----------+
3 rows in set (0.002 sec)

Bye
````

### evidence/42-copy-out-2-billing-select.txt
````text
--------------
USE ddv_probe2
--------------

Query OK, 0 rows affected (0.008 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.005 sec)

--------------
SELECT * FROM probe_sink
--------------

+------+------------------------+----------+
| id   | email                  | phone    |
+------+------------------------+----------+
|    1 | m********@example.test | ****0101 |
|    2 | m********@example.test | ****0101 |
|    3 | l********@example.test | ****0303 |
+------+------------------------+----------+
3 rows in set (0.015 sec)

Bye
````

### evidence/42-copy-out-3-billing-delete.txt
````text
--------------
USE ddv_probe2
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.003 sec)

--------------
DELETE FROM probe_sink
--------------

Query OK, 3 rows affected (0.042 sec)

Bye
````

### evidence/42-copy-out-4-billing-insert.txt
````text
--------------
USE ddv_probe2
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.002 sec)

--------------
INSERT INTO probe_sink SELECT id, email, phone FROM probe_people
--------------

Query OK, 3 rows affected (0.078 sec)
Records: 3  Duplicates: 0  Warnings: 0

Bye
````

### evidence/42-copy-out-5-agent-select.txt
````text
--------------
USE ddv_probe2
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
1 row in set (0.003 sec)

--------------
SELECT * FROM probe_sink
--------------

+------+------------------------+----------+
| id   | email                  | phone    |
+------+------------------------+----------+
|    1 | mark.zzzz@example.test | 555-0101 |
|    2 | mark.aaaa@example.test | 777-0101 |
|    3 | lena.mmmm@example.test | 555-0303 |
+------+------------------------+----------+
3 rows in set (0.004 sec)

Bye
````

### evidence/42-copy-out-setup-root.txt
````text
--------------
CREATE TABLE ddv_probe2.probe_sink (id INT, email VARCHAR(100), phone VARCHAR(20))
--------------

Query OK, 0 rows affected (0.540 sec)

--------------
GRANT SELECT, INSERT, DELETE ON ddv_probe2.probe_sink TO 'ddv_agent'@'%', 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.046 sec)

--------------
GRANT SELECT ON ddv_probe2.probe_people TO 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.031 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+-----------------------------------------------------------------------------------------+
| Grants for ddv_agent@%                                                                  |
+-----------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                                                   |
| GRANT SELECT (`email`, `id`, `phone`) ON `ddv_probe2`.`probe_people` TO `ddv_agent`@`%` |
| GRANT SELECT, INSERT, DELETE ON `ddv_probe2`.`probe_sink` TO `ddv_agent`@`%`            |
| GRANT SELECT ON `ddv_probe2`.`v_owner_definer` TO `ddv_agent`@`%`                       |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`                            |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`                               |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`                             |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%`                      |
| GRANT EXECUTE ON PROCEDURE `ddv_probe2`.`p_owner` TO `ddv_agent`@`%`                    |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                                          |
+-----------------------------------------------------------------------------------------+
10 rows in set (0.002 sec)

--------------
SHOW GRANTS FOR 'ddv_billing'@'%'
--------------

+--------------------------------------------------------------------------------+
| Grants for ddv_billing@%                                                       |
+--------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_billing`@`%`                                        |
| GRANT SELECT ON `ddv_probe2`.`probe_people` TO `ddv_billing`@`%`               |
| GRANT SELECT, INSERT, DELETE ON `ddv_probe2`.`probe_sink` TO `ddv_billing`@`%` |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_billing`@`%`                 |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_billing`@`%`                    |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_billing`@`%`                  |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_billing`@`%`           |
| GRANT `r_billing_admin`@`%` TO `ddv_billing`@`%`                               |
+--------------------------------------------------------------------------------+
8 rows in set (0.001 sec)

Bye
````

### evidence/43-indexed-columns.txt
````text
--------------
USE ddv_probe2
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
CREATE TABLE probe_idx (id INT PRIMARY KEY, code VARCHAR(20), KEY k_code (code))
--------------

Query OK, 0 rows affected (0.381 sec)

--------------
INSERT INTO probe_idx VALUES (1, 'code-one')
--------------

Query OK, 1 row affected (0.047 sec)

--------------
ALTER TABLE probe_idx MODIFY COLUMN code VARCHAR(20) MASKING POLICY probe_mask_phone
--------------

ERROR 6572 (42000) at line 4: Column 'code' cannot have a MASKING POLICY and have an index.
--------------
SHOW WARNINGS
--------------

+-------+------+---------------------------------------------------------------+
| Level | Code | Message                                                       |
+-------+------+---------------------------------------------------------------+
| Error | 6572 | Column 'code' cannot have a MASKING POLICY and have an index. |
+-------+------+---------------------------------------------------------------+
1 row in set (0.002 sec)

--------------
CREATE INDEX idx_phone ON probe_people (phone)
--------------

ERROR 6572 (42000) at line 6: Column 'phone' cannot have a MASKING POLICY and have an index.
--------------
SHOW WARNINGS
--------------

+-------+------+----------------------------------------------------------------+
| Level | Code | Message                                                        |
+-------+------+----------------------------------------------------------------+
| Error | 6572 | Column 'phone' cannot have a MASKING POLICY and have an index. |
+-------+------+----------------------------------------------------------------+
1 row in set (0.002 sec)

--------------
SHOW CREATE TABLE probe_idx
--------------

+-----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table     | Create Table                                                                                                                                                                                        |
+-----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_idx | CREATE TABLE `probe_idx` (
  `id` int NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `k_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.003 sec)

--------------
SHOW CREATE TABLE probe_people
--------------

+--------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table        | Create Table                                                                                                                                                                                                                                                                                            |
+--------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_people | CREATE TABLE `probe_people` (
  `id` int NOT NULL,
  `email` varchar(100) MASKING POLICY `probe_mask_email` DEFAULT NULL,
  `phone` varchar(20) MASKING POLICY `probe_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+--------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.002 sec)

Bye
````

### evidence/45-component-scripts.txt
````text
===== share\audit_log_component_filter_install.sql (full)
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.

CREATE TABLE IF NOT EXISTS audit_log_filter(NAME VARCHAR(64) BINARY NOT NULL PRIMARY KEY, FILTER JSON NOT NULL) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci;
CREATE TABLE IF NOT EXISTS audit_log_user(USER VARCHAR(32) BINARY NOT NULL, HOST VARCHAR(255) CHARACTER SET ASCII NOT NULL, FILTERNAME VARCHAR(64) BINARY NOT NULL, PRIMARY KEY (USER, HOST), FOREIGN KEY (FILTERNAME) REFERENCES audit_log_filter(NAME)) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci;

INSTALL COMPONENT "file://component_audit_log";

===== share\audit_log_component_filter_uninstall.sql (full)
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.

-- Audit Log Uninstallation script
-- 1. Drops the functions.
-- 2. Drops the tables.
-- 3. Uninstalls the component.

-- Note: Please specify the schema name before
-- running the script using either -D or --database.

-- Uninstall the component.
UNINSTALL COMPONENT "file://component_audit_log";

-- Drop the tables.
DROP TABLE IF EXISTS audit_log_user;
DROP TABLE IF EXISTS audit_log_filter;

===== share\install_component_firewall.sql (first 80 lines of 9779 bytes)
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.

# This script installs Enterprise Firewall component
# altogether with needed tables and stored procedures.
#
# The tables and procedures will be located in the current database.
# @@component_firewall.database will be set to the current database
# and persisted.

# Create tables
CREATE TABLE IF NOT EXISTS firewall_group_allowlist(
  NAME VARCHAR(288) NOT NULL,
  RULE text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
) engine=InnoDB;

CREATE TABLE IF NOT EXISTS firewall_groups(
  NAME VARCHAR(288) PRIMARY KEY,
  MODE ENUM ('OFF', 'RECORDING', 'PROTECTING', 'DETECTING') NOT NULL DEFAULT 'OFF',
  USERHOST VARCHAR(288)
) engine=InnoDB;

CREATE TABLE IF NOT EXISTS firewall_membership(
  GROUP_ID VARCHAR(288),
  MEMBER_ID VARCHAR(288),
  PRIMARY KEY(GROUP_ID, MEMBER_ID)
) engine=InnoDB;

# install the component
INSTALL COMPONENT 'file://component_firewall' SET
  PERSIST component_firewall.database = DATABASE();

# Create procedures
delimiter //

# switches group operational mode, updates permanent storage accordingly
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
````

### evidence/46-cleanup.txt
````text
--------------
REVOKE SELECT (id, email, phone) ON ddv_probe2.probe_people FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.052 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
REVOKE SELECT ON ddv_probe2.v_owner_definer FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.021 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
REVOKE EXECUTE ON PROCEDURE ddv_probe2.p_owner FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.024 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
REVOKE SELECT, INSERT, DELETE ON ddv_probe2.probe_sink FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.026 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
REVOKE SELECT ON ddv_probe2.probe_people FROM 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.023 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
REVOKE SELECT, INSERT, DELETE ON ddv_probe2.probe_sink FROM 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.024 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
REVOKE SELECT ON ddv_probe2.probe_people FROM 'ddv_owner'@'%'
--------------

Query OK, 0 rows affected (0.022 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
REVOKE EXECUTE ON PROCEDURE ddv_probe2.p_owner FROM 'ddv_owner'@'%'
--------------

Query OK, 0 rows affected (0.021 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
DROP SCHEMA ddv_probe2
--------------

Query OK, 4 rows affected (0.374 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
DROP MASKING POLICY IF EXISTS probe_mask_email
--------------

Query OK, 0 rows affected (0.031 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
DROP MASKING POLICY IF EXISTS probe_mask_phone
--------------

Query OK, 0 rows affected (0.022 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
DROP USER 'ddv_owner'@'%'
--------------

Query OK, 0 rows affected (0.046 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

Bye
````

### evidence/47-after.txt
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
2 rows in set (0.024 sec)

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
7 rows in set (0.005 sec)

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

Bye
````

### evidence/48-compare.txt
````text
Compare-Object evidence\40-before.txt evidence\47-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).
(no differences)
````

## Plain-words list: what the component scripts would add (nothing was run)

Source: evidence/45-component-scripts.txt (audit scripts in full, firewall script first 80 lines of 9779 bytes).

### Audit component (audit_log_component_filter_install.sql)
- Tables: audit_log_filter, audit_log_user (in the database the script is run against).
- Components: file://component_audit_log (INSTALL COMPONENT).
- Variables: none set in the script text.
- Privileges: none granted or created in the script text.
- Not shown by the script: the component's own system variables, privileges, functions and log files; where the log is written; whether a restart is needed.
- Uninstall script: uninstalls the component and drops audit_log_user and audit_log_filter.

### Firewall component (install_component_firewall.sql, first 80 lines)
- Tables: firewall_group_allowlist, firewall_groups, firewall_membership (current database). Further tables, if any, are past line 80 and were not read.
- Components: file://component_firewall (INSTALL COMPONENT).
- Variables: component_firewall.database is set to the current database and persisted (SET PERSIST).
- Privileges: none shown in the first 80 lines.
- Also: stored procedures are created (sp_set_firewall_group_mode is visible; others are past line 80). The script uses performance_schema.firewall_groups and functions such as set_firewall_group_mode.
- Not shown by the script text read: the remaining procedures, any privileges, any other variables, whether a restart is needed, and the uninstall behaviour (uninstall_component_firewall.sql, 790 bytes, was not read).

## Not captured

- The ddv_owner password and the files holding it (.local/owner.cnf, .local/create-owner.sql, gitignored) are not captured; the user was created from a file that was run without echo.
- Part 1 manual notes (.local/manual-notes-step4b.md) are uncommitted; quotes were relayed by a web-fetch subagent.
- evidence/42-copy-out-*.txt are one file per step as specified, plus 42-copy-out-setup-root.txt for the root setup.
- Only the first 80 lines of install_component_firewall.sql were read; uninstall_component_firewall.sql was not read.
- Nothing from Audit or Firewall was installed or run.
- A definer without the billing role was tested only with root as definer (Step 4, schema ddv_probe); no definer account other than ddv_owner was tested in this step.
- Three rows; each result seen once.
- The compare in evidence/48-compare.txt strips (n.nnn sec) timings only.
- Process note: during this step Claude Code ran a command that included a read of a .local password file; the permission classifier blocked it, nothing was read or printed, and it was not re-run.
- docs/FINDINGS.md was updated (F21 onward, evidence index additions) in the same commit; its hash is not listed here.

## Observations (Claude Code's reading, not evidence)

- With definer root (no role), the Step 4 definer view and procedure returned masked rows. With definer ddv_owner (billing role as default role), v_owner_definer and p_owner returned real email, phone and notes to the agent. That reads as the masking gatekeeper being evaluated for the definer's roles inside a definer-context object.
- On that reading, a definer view or procedure owned by an account with the unmasking role gives an agent the real values, and the agent's column grant on the base table did not limit what the view returned (notes were readable through the view, denied on the table).
- The copy-out chain read as: masked values copied into an unmasked table stay masked, but anyone with the billing role can overwrite the table with real values and the agent then reads them. Table privileges on a scratch table became the unmasking path.
- ERROR 6572 shows a masked column cannot also carry an index, in both directions (attach policy to indexed column; index a masked column). That limits masking a searchable column.
- The audit and firewall component scripts differ from the plugin scripts: they install components, the firewall one persists a variable.
- Three rows only; no repetition.
