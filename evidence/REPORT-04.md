# REPORT-04: discriminating probes, views, copy-out, column grant, Audit and Firewall check

Scratch schema ddv_probe was created and dropped in this step. Nothing was repeated; no captured file was edited.

## SHA-256 (full), new files in sql/ and evidence/

```
39cdf2fae5ff07cfd318e8bcae7beb9b0167f3560290362d704895b60b1a396c  evidence/30-before.txt
e53b6ac05ae0b6a56b11b460d33d7032ec704b4950822a956d24a14a8cf40b58  evidence/31-probe-setup.txt
ab4c7e02faebe5a4534e889fccf5ee128d8231c1eb9b0c91a1b253fa0adc758c  evidence/32-probes-agent.txt
00097ae3ab8d377cc6ef518d9b74993dbfe7cbb573d6bef1455a27b5cf13a163  evidence/32-probes-billing.txt
2d794efb62f5a30e1629722f83a5e679de6c4d8f8593b2b29d459fee1dbbb1cd  evidence/33-regrant-root.txt
aaa6c1e2d76c46bedccf707f49dddbc34a3aa2373dc71fd66206ce790294570d  evidence/33-views-routines-agent.txt
f6372009aab57d5f50780622f3d44cae7f66658a105525d5f1d426aaa35e2a42  evidence/33-views-routines-billing.txt
2628ddaeabbbc26885c23aa514b3167cbd979c1bd735247a8034039d487cd34f  evidence/33-views-setup-root.txt
f63e0d28a16e0b7ce393eb9cdba34f34b4741a3bbce2933c76c1ab54648c3530  evidence/34-copy-out.txt
f2011f0e2760552498137dc0990021f2f944764691133a5daeefdaf246f6a24d  evidence/35-column-grant.txt
cf36bfb2a81575c2a6cc7042159225c2ea6ad6f4e35340a2b61d5380686f4689  evidence/36-audit-firewall-check.txt
1680f1626311a5c308d44253761c4f3d70718bccecb141a74bc3b94c12ba2921  evidence/36-share-plugin-listing.txt
40228a9820c598d1c99de171b5f0e777c04c23009344f7a5222c84a98eec25e4  evidence/37-cleanup.txt
f73704d7a77d5b71b39fb2454dc92cf8527f01ae9f5f3c11aa7a90c782766839  evidence/38-after.txt
f0276fc5d87f10542bb5a5606a4c291592d84901cc98cac494a29890f8fdb3d9  sql/30-snapshot.sql
e2717cfc6fa4ac777bc341a1ee27f38f9d7ea077340d7e855fbfe297ba60012f  sql/31-probe-setup.sql
357828a70dc99ccbb6cc58a741ba0f672c28436e74a6fc076dd0abb9936a3cdc  sql/32-probes.sql
cce2baf7f1df55716f71eebb4c5030a42f793e5544b00e04307fc56977811296  sql/33-regrant.sql
bd2a988f4962983fdf6eef436135e20f0d33e344bab4079c0ab0540c2c3dd696  sql/33-views-probes.sql
1b56cf3bc4a2c05ebc079cc4d77a4e4badc4f593dacf4f5f412a2fb913cfbf29  sql/33-views-setup.sql
6e0c3ac264eea8a8385c1ada24866702ae47c13d87dcdb306ad717a16fbbe124  sql/34-sink-agent.sql
f7b772f01130f293645d731d6a39cfd585be0d51221231a1c07268b4e92acaaa  sql/34-sink-billing.sql
d6e5786f218c22507ae44baecdeac2309a2a4d08726c5c22299cc04070b3141d  sql/34-sink-setup.sql
cbe942e3154f25009e7d235f8b9ff7f55012ef04249788ff37055f97e50d254c  sql/35-column-grant-agent.sql
a1f54479401814eda818b4ee44bea4e971a0b9d6b515ea158ae48363bf610e7d  sql/35-column-grant-setup.sql
091b8d1dfd3b679c49eed4c8fda8219e425bf3c7185779633bc347d0223be481  sql/36-audit-firewall-check.sql
a112d6935909d848339b7c9b5a4b0717f0f99c2efef0e697a9f1db96a21b5e28  sql/37-cleanup.sql
```

## Evidence (verbatim)

### evidence/30-before.txt
````text
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
7 rows in set (0.004 sec)

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
6 rows in set (0.010 sec)

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

Bye
````

### evidence/31-probe-setup.txt
````text
--------------
CREATE SCHEMA ddv_probe
--------------

Query OK, 1 row affected (0.138 sec)

--------------
USE ddv_probe
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

Query OK, 0 rows affected (0.159 sec)

--------------
INSERT INTO probe_people VALUES
  (1, 'mark.zzzz@example.test', '555-0101', 'note one'),
  (2, 'mark.aaaa@example.test', '777-0101', 'note two'),
  (3, 'lena.mmmm@example.test', '555-0303', 'note three')
--------------

Query OK, 3 rows affected (0.027 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE MASKING POLICY probe_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END
--------------

Query OK, 0 rows affected (0.019 sec)

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

Query OK, 0 rows affected (0.022 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
ALTER TABLE probe_people MODIFY COLUMN email VARCHAR(100) MASKING POLICY probe_mask_email
--------------

Query OK, 0 rows affected (0.053 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE probe_people MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe_mask_phone
--------------

Query OK, 0 rows affected (0.042 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
GRANT SELECT ON ddv_probe.probe_people TO 'ddv_agent'@'%', 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.030 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SELECT * FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe%'
--------------

+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+----------------+
| policy_name      | expression                                                                                                                                                                | argument     | extra_info | schema_version |
+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+----------------+
| probe_mask_email | (case when current_role_in(_utf8mb4'r_billing_admin') then `email_column` else mask_inner(`email_column` AS `email_column`,1 AS `1`,13 AS `13`,_utf8mb4'*' AS `'*'`) end) | email_column | []         |              1 |
| probe_mask_phone | (case when current_role_in(_utf8mb4'r_billing_admin') then `phone_column` else mask_inner(`phone_column` AS `phone_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end)   | phone_column | []         |              1 |
+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+----------------+
2 rows in set (0.005 sec)

--------------
SHOW CREATE TABLE ddv_probe.probe_people
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
1 row in set (0.003 sec)

Bye
````

### evidence/32-probes-agent.txt
````text
--------------
USE ddv_probe
--------------

Query OK, 0 rows affected (0.004 sec)

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
SELECT id, email FROM probe_people ORDER BY email
--------------

+----+------------------------+
| id | email                  |
+----+------------------------+
|  3 | l********@example.test |
|  1 | m********@example.test |
|  2 | m********@example.test |
+----+------------------------+
3 rows in set (0.005 sec)

--------------
SELECT phone, COUNT(*) FROM probe_people GROUP BY phone
--------------

+----------+----------+
| phone    | COUNT(*) |
+----------+----------+
| ****0101 |        2 |
| ****0303 |        1 |
+----------+----------+
2 rows in set, 1 warning (0.003 sec)

--------------
SHOW WARNINGS
--------------

+---------+------+------------------------------------------------+
| Level   | Code | Message                                        |
+---------+------+------------------------------------------------+
| Warning | 1052 | Column 'phone' in group statement is ambiguous |
+---------+------+------------------------------------------------+
1 row in set (0.001 sec)

--------------
SELECT COUNT(DISTINCT phone) FROM probe_people
--------------

+-----------------------+
| COUNT(DISTINCT phone) |
+-----------------------+
|                     2 |
+-----------------------+
1 row in set (0.002 sec)

--------------
SELECT MIN(email), MAX(email) FROM probe_people
--------------

+------------------------+------------------------+
| MIN(email)             | MAX(email)             |
+------------------------+------------------------+
| l********@example.test | m********@example.test |
+------------------------+------------------------+
1 row in set (0.002 sec)

--------------
SELECT a.id, b.id FROM probe_people a JOIN probe_people b ON a.phone = b.phone ORDER BY a.id, b.id
--------------

+----+----+
| id | id |
+----+----+
|  1 |  1 |
|  1 |  2 |
|  2 |  1 |
|  2 |  2 |
|  3 |  3 |
+----+----+
5 rows in set (0.003 sec)

--------------
SELECT id FROM probe_people WHERE phone = '777-0101'
--------------

Empty set (0.007 sec)

--------------
SELECT id FROM probe_people WHERE email LIKE 'mark.a%'
--------------

Empty set (0.006 sec)

--------------
SELECT id, LENGTH(email), LEFT(email, 6) FROM probe_people
--------------

+----+---------------+----------------+
| id | LENGTH(email) | LEFT(email, 6) |
+----+---------------+----------------+
|  1 |            22 | m*****         |
|  2 |            22 | m*****         |
|  3 |            22 | l*****         |
+----+---------------+----------------+
3 rows in set (0.002 sec)

Bye
````

### evidence/32-probes-billing.txt
````text
--------------
USE ddv_probe
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
SELECT id, email FROM probe_people ORDER BY email
--------------

+----+------------------------+
| id | email                  |
+----+------------------------+
|  3 | lena.mmmm@example.test |
|  2 | mark.aaaa@example.test |
|  1 | mark.zzzz@example.test |
+----+------------------------+
3 rows in set (0.004 sec)

--------------
SELECT phone, COUNT(*) FROM probe_people GROUP BY phone
--------------

+----------+----------+
| phone    | COUNT(*) |
+----------+----------+
| 555-0101 |        1 |
| 777-0101 |        1 |
| 555-0303 |        1 |
+----------+----------+
3 rows in set, 1 warning (0.002 sec)

--------------
SHOW WARNINGS
--------------

+---------+------+------------------------------------------------+
| Level   | Code | Message                                        |
+---------+------+------------------------------------------------+
| Warning | 1052 | Column 'phone' in group statement is ambiguous |
+---------+------+------------------------------------------------+
1 row in set (0.001 sec)

--------------
SELECT COUNT(DISTINCT phone) FROM probe_people
--------------

+-----------------------+
| COUNT(DISTINCT phone) |
+-----------------------+
|                     3 |
+-----------------------+
1 row in set (0.002 sec)

--------------
SELECT MIN(email), MAX(email) FROM probe_people
--------------

+------------------------+------------------------+
| MIN(email)             | MAX(email)             |
+------------------------+------------------------+
| lena.mmmm@example.test | mark.zzzz@example.test |
+------------------------+------------------------+
1 row in set (0.001 sec)

--------------
SELECT a.id, b.id FROM probe_people a JOIN probe_people b ON a.phone = b.phone ORDER BY a.id, b.id
--------------

+----+----+
| id | id |
+----+----+
|  1 |  1 |
|  2 |  2 |
|  3 |  3 |
+----+----+
3 rows in set (0.020 sec)

--------------
SELECT id FROM probe_people WHERE phone = '777-0101'
--------------

+----+
| id |
+----+
|  2 |
+----+
1 row in set (0.007 sec)

--------------
SELECT id FROM probe_people WHERE email LIKE 'mark.a%'
--------------

+----+
| id |
+----+
|  2 |
+----+
1 row in set (0.007 sec)

--------------
SELECT id, LENGTH(email), LEFT(email, 6) FROM probe_people
--------------

+----+---------------+----------------+
| id | LENGTH(email) | LEFT(email, 6) |
+----+---------------+----------------+
|  1 |            22 | mark.z         |
|  2 |            22 | mark.a         |
|  3 |            22 | lena.m         |
+----+---------------+----------------+
3 rows in set (0.003 sec)

Bye
````

### evidence/33-regrant-root.txt
````text
--------------
GRANT SELECT ON ddv_probe.probe_people TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.047 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+----------------------------------------------------------------------+
| Grants for ddv_agent@%                                               |
+----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                                |
| GRANT SELECT ON `ddv_probe`.`probe_people` TO `ddv_agent`@`%`        |
| GRANT SELECT ON `ddv_probe`.`v_people_definer` TO `ddv_agent`@`%`    |
| GRANT SELECT ON `ddv_probe`.`v_people_invoker` TO `ddv_agent`@`%`    |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`         |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`            |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`          |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%`   |
| GRANT EXECUTE ON PROCEDURE `ddv_probe`.`p_people` TO `ddv_agent`@`%` |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                       |
+----------------------------------------------------------------------+
10 rows in set (0.004 sec)

--------------
SHOW GRANTS FOR 'ddv_billing'@'%'
--------------

+------------------------------------------------------------------------+
| Grants for ddv_billing@%                                               |
+------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_billing`@`%`                                |
| GRANT SELECT ON `ddv_probe`.`probe_people` TO `ddv_billing`@`%`        |
| GRANT SELECT ON `ddv_probe`.`v_people_definer` TO `ddv_billing`@`%`    |
| GRANT SELECT ON `ddv_probe`.`v_people_invoker` TO `ddv_billing`@`%`    |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_billing`@`%`         |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_billing`@`%`            |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_billing`@`%`          |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_billing`@`%`   |
| GRANT EXECUTE ON PROCEDURE `ddv_probe`.`p_people` TO `ddv_billing`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_billing`@`%`                       |
+------------------------------------------------------------------------+
10 rows in set (0.002 sec)

Bye
````

### evidence/33-views-routines-agent.txt
````text
--------------
USE ddv_probe
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
1 row in set (0.001 sec)

--------------
SELECT * FROM v_people_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | m********@example.test | ****0101 | note one   |
|  2 | m********@example.test | ****0101 | note two   |
|  3 | l********@example.test | ****0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.020 sec)

--------------
SELECT * FROM v_people_invoker
--------------

ERROR 1356 (HY000) at line 4: View 'ddv_probe.v_people_invoker' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them
--------------
CALL p_people()
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | m********@example.test | ****0101 | note one   |
|  2 | m********@example.test | ****0101 | note two   |
|  3 | l********@example.test | ****0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.015 sec)

Query OK, 0 rows affected (0.023 sec)

--------------
SELECT * FROM probe_people
--------------

ERROR 1142 (42000) at line 6: SELECT command denied to user 'ddv_agent'@'localhost' for table 'probe_people'
Bye
````

### evidence/33-views-routines-billing.txt
````text
--------------
USE ddv_probe
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
1 row in set (0.001 sec)

--------------
SELECT * FROM v_people_definer
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | m********@example.test | ****0101 | note one   |
|  2 | m********@example.test | ****0101 | note two   |
|  3 | l********@example.test | ****0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.011 sec)

--------------
SELECT * FROM v_people_invoker
--------------

+----+------------------------+----------+------------+
| id | email                  | phone    | notes      |
+----+------------------------+----------+------------+
|  1 | mark.zzzz@example.test | 555-0101 | note one   |
|  2 | mark.aaaa@example.test | 777-0101 | note two   |
|  3 | lena.mmmm@example.test | 555-0303 | note three |
+----+------------------------+----------+------------+
3 rows in set (0.003 sec)

--------------
CALL p_people()
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
3 rows in set (0.002 sec)

Bye
````

### evidence/33-views-setup-root.txt
````text
--------------
USE ddv_probe
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
REVOKE SELECT ON ddv_probe.probe_people FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.039 sec)

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
CREATE DEFINER=root@localhost SQL SECURITY DEFINER VIEW v_people_definer AS SELECT * FROM probe_people
--------------

Query OK, 0 rows affected (0.040 sec)

--------------
CREATE DEFINER=root@localhost SQL SECURITY INVOKER VIEW v_people_invoker AS SELECT * FROM probe_people
--------------

Query OK, 0 rows affected (0.027 sec)

--------------
CREATE DEFINER=root@localhost PROCEDURE p_people() SQL SECURITY DEFINER SELECT * FROM probe_people
--------------

Query OK, 0 rows affected (0.076 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
GRANT SELECT ON ddv_probe.v_people_definer TO 'ddv_agent'@'%', 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.016 sec)

--------------
GRANT SELECT ON ddv_probe.v_people_invoker TO 'ddv_agent'@'%', 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.018 sec)

--------------
GRANT EXECUTE ON PROCEDURE ddv_probe.p_people TO 'ddv_agent'@'%', 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.019 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+----------------------------------------------------------------------+
| Grants for ddv_agent@%                                               |
+----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                                |
| GRANT SELECT ON `ddv_probe`.`v_people_definer` TO `ddv_agent`@`%`    |
| GRANT SELECT ON `ddv_probe`.`v_people_invoker` TO `ddv_agent`@`%`    |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`         |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`            |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`          |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%`   |
| GRANT EXECUTE ON PROCEDURE `ddv_probe`.`p_people` TO `ddv_agent`@`%` |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                       |
+----------------------------------------------------------------------+
9 rows in set (0.001 sec)

--------------
SHOW GRANTS FOR 'ddv_billing'@'%'
--------------

+------------------------------------------------------------------------+
| Grants for ddv_billing@%                                               |
+------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_billing`@`%`                                |
| GRANT SELECT ON `ddv_probe`.`probe_people` TO `ddv_billing`@`%`        |
| GRANT SELECT ON `ddv_probe`.`v_people_definer` TO `ddv_billing`@`%`    |
| GRANT SELECT ON `ddv_probe`.`v_people_invoker` TO `ddv_billing`@`%`    |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_billing`@`%`         |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_billing`@`%`            |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_billing`@`%`          |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_billing`@`%`   |
| GRANT EXECUTE ON PROCEDURE `ddv_probe`.`p_people` TO `ddv_billing`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_billing`@`%`                       |
+------------------------------------------------------------------------+
10 rows in set (0.001 sec)

Bye
````

### evidence/34-copy-out.txt
````text
--------------
CREATE TABLE ddv_probe.probe_sink (id INT, email VARCHAR(100), phone VARCHAR(20))
--------------

Query OK, 0 rows affected (0.289 sec)

--------------
GRANT INSERT, SELECT ON ddv_probe.probe_sink TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.074 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+----------------------------------------------------------------------+
| Grants for ddv_agent@%                                               |
+----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                                |
| GRANT SELECT ON `ddv_probe`.`probe_people` TO `ddv_agent`@`%`        |
| GRANT SELECT, INSERT ON `ddv_probe`.`probe_sink` TO `ddv_agent`@`%`  |
| GRANT SELECT ON `ddv_probe`.`v_people_definer` TO `ddv_agent`@`%`    |
| GRANT SELECT ON `ddv_probe`.`v_people_invoker` TO `ddv_agent`@`%`    |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`         |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`            |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`          |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%`   |
| GRANT EXECUTE ON PROCEDURE `ddv_probe`.`p_people` TO `ddv_agent`@`%` |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                       |
+----------------------------------------------------------------------+
11 rows in set (0.004 sec)

Bye
--------------
USE ddv_probe
--------------

Query OK, 0 rows affected (0.006 sec)

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

Query OK, 3 rows affected (0.037 sec)
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
3 rows in set (0.006 sec)

Bye
--------------
USE ddv_probe
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
SELECT * FROM probe_sink
--------------

ERROR 1142 (42000) at line 3: SELECT command denied to user 'ddv_billing'@'localhost' for table 'probe_sink'
Bye
````

### evidence/35-column-grant.txt
````text
--------------
REVOKE SELECT ON ddv_probe.probe_people FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.063 sec)

--------------
GRANT SELECT (id, email, phone) ON ddv_probe.probe_people TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.034 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+----------------------------------------------------------------------------------------+
| Grants for ddv_agent@%                                                                 |
+----------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                                                  |
| GRANT SELECT (`email`, `id`, `phone`) ON `ddv_probe`.`probe_people` TO `ddv_agent`@`%` |
| GRANT SELECT, INSERT ON `ddv_probe`.`probe_sink` TO `ddv_agent`@`%`                    |
| GRANT SELECT ON `ddv_probe`.`v_people_definer` TO `ddv_agent`@`%`                      |
| GRANT SELECT ON `ddv_probe`.`v_people_invoker` TO `ddv_agent`@`%`                      |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`                           |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`                              |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`                            |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%`                     |
| GRANT EXECUTE ON PROCEDURE `ddv_probe`.`p_people` TO `ddv_agent`@`%`                   |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                                         |
+----------------------------------------------------------------------------------------+
11 rows in set (0.003 sec)

Bye
--------------
USE ddv_probe
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
1 row in set (0.001 sec)

--------------
SELECT id, email, phone FROM probe_people
--------------

+----+------------------------+----------+
| id | email                  | phone    |
+----+------------------------+----------+
|  1 | m********@example.test | ****0101 |
|  2 | m********@example.test | ****0101 |
|  3 | l********@example.test | ****0303 |
+----+------------------------+----------+
3 rows in set (0.003 sec)

--------------
SELECT notes FROM probe_people
--------------

ERROR 1143 (42000) at line 4: SELECT command denied to user 'ddv_agent'@'localhost' for column 'notes' in table 'probe_people'
--------------
SELECT * FROM probe_people
--------------

ERROR 1142 (42000) at line 5: SELECT command denied to user 'ddv_agent'@'localhost' for table 'probe_people'
Bye
````

### evidence/36-audit-firewall-check.txt
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
3 rows in set (0.020 sec)

--------------
SELECT PLUGIN_NAME, PLUGIN_STATUS FROM information_schema.PLUGINS WHERE PLUGIN_NAME LIKE '%audit%' OR PLUGIN_NAME LIKE '%firewall%'
--------------

Empty set (0.058 sec)

--------------
SHOW VARIABLES LIKE '%audit%'
--------------

Empty set (0.344 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

Empty set (0.049 sec)

Bye
````

### evidence/36-share-plugin-listing.txt
````text
--- share (matching *audit* / *firewall*): name  bytes
share\audit_log_component_filter_install.sql  600
share\audit_log_component_filter_uninstall.sql  454
share\audit_log_filter_uninstall.sql  961
share\audit_log_filter_win_install.sql  1460
share\firewall_component_to_plugin.sql  2446
share\firewall_plugin_to_component.sql  14002
share\firewall_profile_migration.sql  2372
share\install_component_firewall.sql  9779
share\uninstall_component_firewall.sql  790
share\uninstall_firewall.sql  1062
share\win_install_firewall.sql  12608
--- lib\plugin (matching *audit* / *firewall*): name  bytes
lib\plugin\audit_log.dll  819840
lib\plugin\component_audit_api_message_emit.dll  36528
lib\plugin\component_audit_log.dll  782488
lib\plugin\component_firewall.dll  345240
lib\plugin\firewall.dll  433792

===== share\audit_log_filter_win_install.sql (first 40 lines)
# Copyright (c) 2016, 2026, Oracle and/or its affiliates.

CREATE TABLE IF NOT EXISTS audit_log_filter(NAME VARCHAR(64) BINARY NOT NULL PRIMARY KEY, FILTER JSON NOT NULL) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci;
CREATE TABLE IF NOT EXISTS audit_log_user(USER VARCHAR(32) BINARY NOT NULL, HOST VARCHAR(255) CHARACTER SET ASCII NOT NULL, FILTERNAME VARCHAR(64) BINARY NOT NULL, PRIMARY KEY (USER, HOST), FOREIGN KEY (FILTERNAME) REFERENCES audit_log_filter(NAME)) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci;

INSTALL PLUGIN audit_log SONAME 'audit_log.dll';

CREATE FUNCTION audit_log_filter_set_filter RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_filter_remove_filter RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_filter_set_user RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_filter_remove_user RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_filter_flush RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_read_bookmark RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_read RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_encryption_password_set RETURNS INTEGER SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_encryption_password_get RETURNS STRING SONAME 'audit_log.dll';
CREATE FUNCTION audit_log_rotate RETURNS STRING SONAME 'audit_log.dll';

SELECT audit_log_filter_flush() AS 'Result';

===== share\win_install_firewall.sql (first 40 lines)
# Copyright (c) 2015, 2026, Oracle and/or its affiliates.

# Note : If this file is being modified, please also modify
# the file(s) present in the src/scripts/firewall folder as needed.

# WARNING: If the .sql files are changed in a patch release, then it is
# possible that the Firewall plugin, after a downgrade, will not work as intended.
# Please try to avoid changes in patch releases.

/* =================== MYSQL FIREWALL INSTALLATION SCRIPT =================== */

/* queries allowed for particular userhost */
CREATE TABLE IF NOT EXISTS
firewall_whitelist(
	USERHOST VARCHAR(288) NOT NULL,
	RULE text NOT NULL,
	ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
) engine= InnoDB;

/* queries allowed for particular usergroup */
CREATE TABLE IF NOT EXISTS
firewall_group_allowlist(
	NAME VARCHAR(288) NOT NULL,
	RULE text NOT NULL,
	ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
) engine= InnoDB;

/* info on users registered in firewall */
CREATE TABLE IF NOT EXISTS
firewall_users(
USERHOST VARCHAR(288) PRIMARY KEY,
MODE ENUM ('OFF', 'RECORDING', 'PROTECTING', 'RESET', 'DETECTING') DEFAULT 'OFF'
) engine= InnoDB;

/* info on groups registered in firewall */
CREATE TABLE IF NOT EXISTS
firewall_groups(
NAME VARCHAR(288) PRIMARY KEY,
MODE ENUM ('OFF', 'RECORDING', 'PROTECTING', 'DETECTING') DEFAULT 'OFF',
USERHOST VARCHAR(288)
````

### evidence/37-cleanup.txt
````text
--------------
REVOKE SELECT (id, email, phone) ON ddv_probe.probe_people FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.029 sec)

--------------
REVOKE SELECT, INSERT ON ddv_probe.probe_sink FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.022 sec)

--------------
REVOKE SELECT ON ddv_probe.v_people_definer FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.029 sec)

--------------
REVOKE SELECT ON ddv_probe.v_people_invoker FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.015 sec)

--------------
REVOKE EXECUTE ON PROCEDURE ddv_probe.p_people FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.014 sec)

--------------
REVOKE SELECT ON ddv_probe.probe_people FROM 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.014 sec)

--------------
REVOKE SELECT ON ddv_probe.v_people_definer FROM 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.016 sec)

--------------
REVOKE SELECT ON ddv_probe.v_people_invoker FROM 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.017 sec)

--------------
REVOKE EXECUTE ON PROCEDURE ddv_probe.p_people FROM 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.014 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
DROP SCHEMA ddv_probe
--------------

Query OK, 4 rows affected (0.206 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
DROP MASKING POLICY IF EXISTS probe_mask_email
--------------

Query OK, 0 rows affected (0.030 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
DROP MASKING POLICY IF EXISTS probe_mask_phone
--------------

Query OK, 0 rows affected (0.023 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

Bye
````

### evidence/38-after.txt
````text
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
7 rows in set (0.003 sec)

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
6 rows in set (0.002 sec)

Bye
````

### fc evidence\30-before.txt evidence\38-after.txt (console output, not saved as a file)
````text
Comparing files EVIDENCE\30-before.txt and EVIDENCE\38-AFTER.TXT
***** EVIDENCE\30-before.txt
+-----------------+
7 rows in set (0.004 sec)

***** EVIDENCE\38-AFTER.TXT
+-----------------+
7 rows in set (0.003 sec)

*****

***** EVIDENCE\30-before.txt
+--------------------------------------------------------------------+
6 rows in set (0.010 sec)

***** EVIDENCE\38-AFTER.TXT
+--------------------------------------------------------------------+
6 rows in set (0.001 sec)

*****

````

## What installing Audit and Firewall would change (from the manual pages in Part 1 and the script text; no recommendation)

Nothing was installed or run. Sources: .local/manual-notes-step4.md (uncommitted) and the first 40 lines of each script in evidence/36-share-plugin-listing.txt.

### Enterprise Audit (audit_log_filter_win_install.sql, the whole script is under 40 lines)
- Files written: none by the script; plugin file lib\plugin\audit_log.dll already exists in the install (listed in evidence/36-share-plugin-listing.txt). The manual says the library must be in plugin_dir. Whether and where audit log files get written: not documented on the page fetched.
- Database objects: creates tables audit_log_filter and audit_log_user in the database the script is run against (manual example uses -D mysql; a custom database is possible), runs INSTALL PLUGIN audit_log, creates 10 loadable functions (audit_log_filter_set_filter, ..._remove_filter, ..._set_user, ..._remove_user, ..._flush, audit_log_read_bookmark, audit_log_read, audit_log_encryption_password_set, ..._get, audit_log_rotate) and calls audit_log_filter_flush().
- Settings: no restart required per the manual. Optional option-file line audit-log=FORCE_PLUS_PERMANENT in [mysqld]; with FORCE values the server fails to start if the plugin does not initialise.
- Privileges: not documented on the page fetched.
- Uninstall: audit_log_filter_uninstall.sql exists in share; restart after uninstall not documented.
- Other variants present in share but not read: audit_log_component_filter_install.sql, audit_log_component_filter_uninstall.sql; lib\plugin has component_audit_log.dll.

### Enterprise Firewall (win_install_firewall.sql, 12608 bytes; only the first 40 lines were read)
- Files written: none by the script; lib\plugin\firewall.dll already exists.
- Database objects: per the manual, stored procedures and tables in the firewall database (mysql by default, or a custom schema); the first 40 lines show tables firewall_whitelist, firewall_group_allowlist, firewall_users, firewall_groups. Plugin installation uses INSTALL PLUGIN statements (not replicated). The rest of the script was not read.
- Settings: after install the manual says mysql_firewall_mode should be ON. A custom schema needs --loose-mysql-firewall-database=name at server startup. Restart needed only if an older version is present. The fetched page was labelled 8.4 although served under the 9.7 path.
- Privileges: not documented on the page fetched.
- Uninstall: uninstall_firewall.sql exists in share; restart after uninstall not documented.
- Other variants present in share but not read: install_component_firewall.sql, uninstall_component_firewall.sql, firewall_component_to_plugin.sql, firewall_plugin_to_component.sql, firewall_profile_migration.sql; lib\plugin has component_firewall.dll.

## Not captured

- The Part 1 manual notes (.local/manual-notes-step4.md) are uncommitted; quotes were relayed by a web-fetch subagent and were not re-checked by hand. The firewall page was labelled 8.4.
- Part 4: the spec said to grant ddv_agent view and EXECUTE privileges. Claude Code also granted the same to ddv_billing, which kept its base-table SELECT. Setup, re-grant and the two grant listings are in extra files 33-views-setup-root.txt and 33-regrant-root.txt.
- Part 5: the spec granted INSERT and SELECT on probe_sink to ddv_agent only. ddv_billing had no grant, so its SELECT on probe_sink was denied (ERROR 1142); this does not show what billing would see.
- Files 34-copy-out.txt and 35-column-grant.txt are several client runs appended in one file; the root part comes first.
- Part 7: file names are listed with paths relative to the server folder, without the absolute install path. Only the first 40 lines of the two Windows install scripts were read; the component install scripts were not read.
- No audit log or firewall behaviour was tested. Nothing was installed.
- Only 3 rows of probe data; no indexes on masked columns (the manual forbids masking indexed columns).
- Whether a DEFINER view or routine sees masked or real values for a definer who holds the unmasking role was not tested (root holds no role).
- DROP SCHEMA removed the objects; table-level grants were revoked first one by one. Leftover rows in mysql grant tables were checked only through the SHOW GRANTS comparison in 38-after.txt.
- fc output: differences are query timings only; it was not saved as a file.

## Observations (Claude Code's reading, not evidence)

- On this data, the agent's ORDER BY email returned ids 3,1,2 while billing's returned 3,2,1, GROUP BY phone gave 2 groups against billing's 3, COUNT(DISTINCT phone) gave 2 against 3, the self-join gave 5 rows against 3, and WHERE phone='777-0101' and email LIKE 'mark.a%' returned nothing for the agent. That reads as sorting, grouping, joining and filtering all running on the masked value for the agent.
- MIN/MAX(email) and LEFT(email,6) for the agent showed masked text, which also fits masked evaluation.
- The DEFINER view and the DEFINER procedure returned masked rows to both ddv_agent and ddv_billing, while billing's INVOKER view and direct select returned real values. That fits the gatekeeper being evaluated for the definer (root holds no role) in definer context. This is reasoning from one definer; the manual is silent on it.
- The INVOKER view failed for the agent with ERROR 1356 once the agent lost base-table SELECT.
- INSERT ... SELECT by the agent wrote masked values into an unmasked table; the sink then held only the placeholders, not the real data.
- A column-level SELECT grant without notes made SELECT notes fail with ERROR 1143 and SELECT * fail with ERROR 1142, while the three granted columns still came back masked.
- Neither Audit nor Firewall is installed or active on this server; mysql.component lists only the three masking and policy components.
- Three rows is a small sample; each result was seen once.
