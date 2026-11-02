# REPORT-01

## Version line

```
| 9.7.4-commercial |
```

## SHA-256

```
2c8f56b6021fae023b5ef4cc550a67c18e7493ff2a568440d36301bafdc07451  sql/01-feasibility.sql
1178e078947185c05dc048f7304ad953402c3996295bf6c078b3a08daeaa2e24  sql/02-select.sql
78bc77a44ebd262c7a6b56c1124b94c4be45f0045d0e366ee2b4d54e9a2821b5  sql/03-probe-agent.sql
67310845ac516ebc33fca0117767f8af9a428b7e85456ae92f84280008fb3c3f  sql/04-policies.sql
b7add630ecd0aaa7cc10e168f60613f6af2b9c7029c72c49fb4192bd8083f0f8  evidence/01-setup-root.txt
f2614e3b5287daec2b38ba8816afe32f3f7760f5c57365e98709321b15ea1ec9  evidence/02-select-admin.txt
60a760162b929ab6ea85bbf5f46b7661c9e6eabf413d86c0c24e696f2e65b995  evidence/02-select-agent.txt
1d691def000b4762dbf2811e56b23a2458982c50f5d624facbbc6fb119533289  evidence/02-select-root.txt
1a9d2c4b828a05d725dd8f1ae18e1fa41dd72a98e3ccff1e4b9a48ccf42d5edb  evidence/03-probe-agent.txt
80fc1587ebdec0c213ddd310096a936067a66f9e93f99de974c3c5a01db720dc  evidence/04-policies-root.txt
```

## Evidence

### evidence/01-setup-root.txt

```
--------------
SELECT VERSION()
--------------

+------------------+
| VERSION()        |
+------------------+
| 9.7.4-commercial |
+------------------+
1 row in set (0.006 sec)

--------------
SELECT CURRENT_USER()
--------------

+----------------+
| CURRENT_USER() |
+----------------+
| root@localhost |
+----------------+
1 row in set (0.002 sec)

--------------
CREATE SCHEMA ddv_mask
--------------

Query OK, 1 row affected (0.179 sec)

--------------
USE ddv_mask
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
CREATE TABLE customers (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL
)
--------------

Query OK, 0 rows affected (0.145 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
INSERT INTO customers VALUES
  (1, 'Alice Example', '555-0101', 'alice@example.test'),
  (2, 'Bob Sample',    '555-0102', 'bob@example.test'),
  (3, 'Carol Demo',    '555-0103', 'carol@example.test')
--------------

Query OK, 3 rows affected (0.051 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.007 sec)

--------------
CREATE MASKING POLICY mask_phone(phone_column)
CASE WHEN CURRENT_USER_IN('ddv_admin@%')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.032 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
CREATE MASKING POLICY mask_email(email_column)
CASE WHEN CURRENT_USER_IN('ddv_admin@%')
     THEN email_column
     ELSE mask_outer(email_column, 2, 2, '#')
END
--------------

Query OK, 0 rows affected (0.032 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

--------------
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20) NOT NULL MASKING POLICY mask_phone
--------------

Query OK, 0 rows affected (0.087 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
ALTER TABLE customers MODIFY COLUMN email VARCHAR(100) NOT NULL MASKING POLICY mask_email
--------------

Query OK, 0 rows affected (0.067 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
GRANT SELECT ON ddv_mask.* TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.016 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
GRANT SELECT ON ddv_mask.* TO 'ddv_admin'@'%'
--------------

Query OK, 0 rows affected (0.016 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM customers ORDER BY id
--------------

+----+---------------+----------+--------------------+
| id | name          | phone    | email              |
+----+---------------+----------+--------------------+
|  1 | Alice Example | ****0101 | ##ice@example.te## |
|  2 | Bob Sample    | ****0102 | ##b@example.te##   |
|  3 | Carol Demo    | ****0103 | ##rol@example.te## |
+----+---------------+----------+--------------------+
3 rows in set (0.007 sec)

Bye
```

### evidence/02-select-admin.txt

```
--------------
SELECT CURRENT_USER()
--------------

+----------------+
| CURRENT_USER() |
+----------------+
| ddv_admin@%    |
+----------------+
1 row in set (0.003 sec)

--------------
SELECT * FROM ddv_mask.customers ORDER BY id
--------------

+----+---------------+----------+--------------------+
| id | name          | phone    | email              |
+----+---------------+----------+--------------------+
|  1 | Alice Example | 555-0101 | alice@example.test |
|  2 | Bob Sample    | 555-0102 | bob@example.test   |
|  3 | Carol Demo    | 555-0103 | carol@example.test |
+----+---------------+----------+--------------------+
3 rows in set (0.006 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

Bye
```

### evidence/02-select-agent.txt

```
--------------
SELECT CURRENT_USER()
--------------

+----------------+
| CURRENT_USER() |
+----------------+
| ddv_agent@%    |
+----------------+
1 row in set (0.002 sec)

--------------
SELECT * FROM ddv_mask.customers ORDER BY id
--------------

+----+---------------+----------+--------------------+
| id | name          | phone    | email              |
+----+---------------+----------+--------------------+
|  1 | Alice Example | ****0101 | ##ice@example.te## |
|  2 | Bob Sample    | ****0102 | ##b@example.te##   |
|  3 | Carol Demo    | ****0103 | ##rol@example.te## |
+----+---------------+----------+--------------------+
3 rows in set (0.004 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

Bye
```

### evidence/02-select-root.txt

```
--------------
SELECT CURRENT_USER()
--------------

+----------------+
| CURRENT_USER() |
+----------------+
| root@localhost |
+----------------+
1 row in set (0.003 sec)

--------------
SELECT * FROM ddv_mask.customers ORDER BY id
--------------

+----+---------------+----------+--------------------+
| id | name          | phone    | email              |
+----+---------------+----------+--------------------+
|  1 | Alice Example | ****0101 | ##ice@example.te## |
|  2 | Bob Sample    | ****0102 | ##b@example.te##   |
|  3 | Carol Demo    | ****0103 | ##rol@example.te## |
+----+---------------+----------+--------------------+
3 rows in set (0.005 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

Bye
```

### evidence/03-probe-agent.txt

```
--------------
SHOW CREATE TABLE ddv_mask.customers
--------------

+-----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table     | Create Table                                                                                                                                                                                                                                                                                     |
+-----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| customers | CREATE TABLE `customers` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) MASKING POLICY `mask_phone` NOT NULL,
  `email` varchar(100) MASKING POLICY `mask_email` NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.142 sec)

--------------
SELECT id, phone, email FROM ddv_mask.customers
--------------

+----+----------+--------------------+
| id | phone    | email              |
+----+----------+--------------------+
|  1 | ****0101 | ##ice@example.te## |
|  2 | ****0102 | ##b@example.te##   |
|  3 | ****0103 | ##rol@example.te## |
+----+----------+--------------------+
3 rows in set (0.005 sec)

--------------
SELECT id FROM ddv_mask.customers WHERE phone='555-0101'
--------------

Empty set (0.008 sec)

--------------
SELECT id FROM ddv_mask.customers WHERE email LIKE 'alice%'
--------------

Empty set (0.004 sec)

--------------
SHOW GRANTS
--------------

+-------------------------------------------------+
| Grants for ddv_agent@%                          |
+-------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`           |
| GRANT SELECT ON `ddv_mask`.* TO `ddv_agent`@`%` |
+-------------------------------------------------+
2 rows in set (0.027 sec)

Bye
```

### evidence/04-policies-root.txt

```
--------------
SELECT * FROM mysql.column_masking_policies
--------------

+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+----------------+
| policy_name | expression                                                                                                                                                          | argument     | extra_info | schema_version |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+----------------+
| mask_email  | (case when current_user_in(_utf8mb4'ddv_admin@%') then `email_column` else mask_outer(`email_column` AS `email_column`,2 AS `2`,2 AS `2`,_utf8mb4'#' AS `'#'`) end) | email_column | []         |              1 |
| mask_phone  | (case when current_user_in(_utf8mb4'ddv_admin@%') then `phone_column` else mask_inner(`phone_column` AS `phone_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end) | phone_column | []         |              1 |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+----------------+
2 rows in set (0.004 sec)

Bye
```

## Not captured

- (a) The CREATE USER statements for ddv_agent and ddv_admin ran in a separate session to keep passwords out of transcripts.
- (b) The component install script ran in the author's own interactive session and printed "2 warnings" whose text was not captured.
- (c) An earlier manual run by the author, kept privately and not used here.

## Observations

Claude Code's reading of the files above. This is not evidence.

- Every statement in 01-setup-root.txt completed without error and every SHOW WARNINGS returned an empty set.
- ddv_agent and root both received masked phone and email values; ddv_admin received the unmasked values. Root is not in the CURRENT_USER_IN list.
- ddv_admin holds only the grants given in the script (SELECT on ddv_mask.*). No separate unmask privilege was granted. SHOW GRANTS was captured for ddv_agent only.
- For ddv_agent, the equality predicate on the raw phone and the LIKE predicate on the raw email prefix each returned an empty set.
- SHOW CREATE TABLE as ddv_agent displays the MASKING POLICY clauses on phone and email.
- Both policies appear in mysql.column_masking_policies with schema_version 1.
