# REPORT-02

## SHA-256

```
7c593fc87a419e353f7d8775003e9c191cb273a60bf0a527bef3193ee058300a  sql/00-create-users.template.sql
2c8f56b6021fae023b5ef4cc550a67c18e7493ff2a568440d36301bafdc07451  sql/01-feasibility.sql
1178e078947185c05dc048f7304ad953402c3996295bf6c078b3a08daeaa2e24  sql/02-select.sql
78bc77a44ebd262c7a6b56c1124b94c4be45f0045d0e366ee2b4d54e9a2821b5  sql/03-probe-agent.sql
67310845ac516ebc33fca0117767f8af9a428b7e85456ae92f84280008fb3c3f  sql/04-policies.sql
4d5643e8304797401484b2cfb4e8db090f1cdb7033a461a8fc7bfabad88e3509  sql/10-agent-grants-before.sql
f4f0858b9e4beb52b3f8972a87223ba6dc7828261873a2d27dfd96885070e134  sql/11-agent-revoke-ddv-mask.sql
33de3c374de7db00233b72ef8ead0867a1296b3a7c90354e8ba12188d1ca47e2  sql/12-support-schema.sql
e44ed37b5fbfe621662deba1d95336fc5ac7030d2945e12288c49a761f587a86  sql/13-support-policies.sql
6be1703041ae04b0d5db563641efd6ad74fff66736063db24f6c204f797c249e  sql/14-roles-grants.sql
3b307074cbc2844a1380ccd3a744e437e8799b9aee8d608c66779901b86929b8  sql/15-verify-user.sql
bf61c262086054fee3c4f55dab597ecbd4511caf359528634ea400220fa00894  sql/16-verify-billing-set-role-none.sql
68fb0d47dca281700dedc45187e0e8fd18dcf2a8931e70ddaa531666c7878ef0  sql/17-policies-root.sql
a61c2c318e5ba5febcc41703bbeb3c23ed71f6ac4bd89a79b4e0f5591679257c  sql/18-show-grants.sql
493fa9531d5a287e2083bd2939b9b43208869f54587758ff7ad47b154d8545bf  sql/19-show-create-agent.sql
b7add630ecd0aaa7cc10e168f60613f6af2b9c7029c72c49fb4192bd8083f0f8  evidence/01-setup-root.txt
f2614e3b5287daec2b38ba8816afe32f3f7760f5c57365e98709321b15ea1ec9  evidence/02-select-admin.txt
60a760162b929ab6ea85bbf5f46b7661c9e6eabf413d86c0c24e696f2e65b995  evidence/02-select-agent.txt
1d691def000b4762dbf2811e56b23a2458982c50f5d624facbbc6fb119533289  evidence/02-select-root.txt
1a9d2c4b828a05d725dd8f1ae18e1fa41dd72a98e3ccff1e4b9a48ccf42d5edb  evidence/03-probe-agent.txt
80fc1587ebdec0c213ddd310096a936067a66f9e93f99de974c3c5a01db720dc  evidence/04-policies-root.txt
19f36189a09bfcad86f3ee3ab11f1a9f6e1d76cf6c7e01aa85b2c8993fd3e530  evidence/10-agent-grants-before.txt
61dc52b350f957e56a1e19e168ffe9e96018fd074a922978c09fdf3191e61ae9  evidence/11-agent-revoke-ddv-mask.txt
41e6b2bf6cb70d76996ca8fd0d913ea615609ff82bc77670f7bd96cc257e54ae  evidence/12-support-schema.txt
9117342b6fbce8a409ba68754b6fc933776c9e1d97444b0f7b6386156d63fa3c  evidence/13-support-policies.txt
079b94f8bd924a13c69379b8d1710d6dcea70cfab6ca0231a03b7cc3fafdbca0  evidence/14-roles-grants.txt
712c1fbee5b2d717ffa17ba6cce18e0581b4a2fb90a4d705e4e4af2d1029bf6a  evidence/15-verify-agent.txt
df3e074d005a74d20c08124da444252b5fc3440f0cd2faffc802bf5763da040d  evidence/15-verify-norole.txt
aac83efff3d4e67e233bbb933181bae00f430a74f807c69fc8d21bcfee05d543  evidence/16-verify-billing-set-role-none.txt
da39e3f23783881514792936cb5077b933e9f27a9803dc1cf119b76182b110ad  evidence/17-policies-root.txt
7b29dac6971ddf2d337692e715e21fd0dcf9b6589c954799b3219b27126846e4  evidence/18-show-grants.txt
8435f87bd25ee31c5edc462749363d217f04f4cd9990e48f1ed9f604d1ccd794  evidence/19-show-create-agent.txt
780f4baa3e605c90f852e46fa66d5d9aec8ab2e6414146481a0e7895192b5b1b  evidence/REPORT-01.md
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

### evidence/10-agent-grants-before.txt

```
--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+-------------------------------------------------+
| Grants for ddv_agent@%                          |
+-------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`           |
| GRANT SELECT ON `ddv_mask`.* TO `ddv_agent`@`%` |
+-------------------------------------------------+
2 rows in set (0.036 sec)

Bye
```

### evidence/11-agent-revoke-ddv-mask.txt

```
--------------
REVOKE SELECT ON ddv_mask.* FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.212 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+---------------------------------------+
| Grants for ddv_agent@%                |
+---------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%` |
+---------------------------------------+
1 row in set (0.008 sec)

Bye
```

### evidence/12-support-schema.txt

```
--------------
CREATE SCHEMA ddv_support
--------------

Query OK, 1 row affected (0.121 sec)

--------------
USE ddv_support
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
CREATE TABLE customers (
  id INT NOT NULL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  tax_id VARCHAR(20) NOT NULL
)
--------------

Query OK, 0 rows affected (0.392 sec)

--------------
CREATE TABLE orders (
  id INT NOT NULL PRIMARY KEY,
  customer_id INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers (id)
)
--------------

Query OK, 0 rows affected (0.326 sec)

--------------
CREATE TABLE payments (
  id INT NOT NULL PRIMARY KEY,
  order_id INT NOT NULL,
  method VARCHAR(10) NOT NULL,
  card_number VARCHAR(19) NULL,
  upi_id VARCHAR(50) NULL,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders (id)
)
--------------

Query OK, 0 rows affected (0.314 sec)

--------------
CREATE TABLE support_tickets (
  id INT NOT NULL PRIMARY KEY,
  customer_id INT NOT NULL,
  subject VARCHAR(200) NOT NULL,
  notes TEXT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers (id)
)
--------------

Query OK, 0 rows affected (0.269 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
INSERT INTO customers VALUES
  (1, 'Asha Example',   '555-0101', 'asha.example@example.test',   'TEST-0001'),
  (2, 'Bilal Sample',   '555-0102', 'bilal.sample@example.test',   'TEST-0002'),
  (3, 'Chen Demo',      '555-0103', 'chen.demo@example.test',      'TEST-0003'),
  (4, 'Dana Placeholder','555-0104', 'dana.placeholder@example.test','TEST-0004'),
  (5, 'Elif Fictional', '555-0105', 'elif.fictional@example.test', 'TEST-0005'),
  (6, 'Farid Mock',     '555-0106', 'farid.mock@example.test',     'TEST-0006')
--------------

Query OK, 6 rows affected (0.042 sec)
Records: 6  Duplicates: 0  Warnings: 0

--------------
INSERT INTO orders VALUES
  (101, 1, 'delivered', 1250.00, '2026-09-01 10:15:00'),
  (102, 1, 'shipped',    349.50, '2026-09-20 14:02:00'),
  (103, 2, 'delivered',  899.99, '2026-09-03 09:40:00'),
  (104, 2, 'refunded',   120.00, '2026-09-11 16:25:00'),
  (105, 3, 'pending',    45.00,  '2026-10-02 11:05:00'),
  (106, 3, 'delivered',  310.75, '2026-09-28 18:30:00'),
  (107, 4, 'cancelled',  75.25,  '2026-09-15 08:55:00'),
  (108, 5, 'shipped',    560.00, '2026-10-05 13:45:00'),
  (109, 6, 'delivered',  99.99,  '2026-10-10 17:10:00'),
  (110, 6, 'pending',    210.40, '2026-10-12 12:00:00')
--------------

Query OK, 10 rows affected (0.042 sec)
Records: 10  Duplicates: 0  Warnings: 0

--------------
INSERT INTO payments VALUES
  (1001, 101, 'card', '4111111111111111', NULL,            'captured'),
  (1002, 102, 'upi',  NULL,               'asha@testbank', 'captured'),
  (1003, 103, 'card', '5555555555554444', NULL,            'captured'),
  (1004, 104, 'card', '5555555555554444', NULL,            'refunded'),
  (1005, 105, 'upi',  NULL,               'chen@testbank', 'pending'),
  (1006, 106, 'card', '378282246310005',  NULL,            'captured'),
  (1007, 107, 'card', '6011111111111117', NULL,            'voided'),
  (1008, 108, 'upi',  NULL,               'elif@testbank', 'captured'),
  (1009, 109, 'card', '4242424242424242', NULL,            'captured'),
  (1010, 110, 'upi',  NULL,               'farid@testbank','pending')
--------------

Query OK, 10 rows affected (0.046 sec)
Records: 10  Duplicates: 0  Warnings: 0

--------------
INSERT INTO support_tickets VALUES
  (1, 1, 'Where is my order 102?',            'Customer asked for tracking. Shipped 2026-09-20.'),
  (2, 2, 'Refund for order 104',              'Refund issued to original payment method.'),
  (3, 3, 'Charge failed, please call back',   'Customer typed: my card is 5555555555554444 and you can reach me at chen.demo@example.test, please retry the charge.'),
  (4, 5, 'Change delivery address',           'Address change requested before shipment.'),
  (5, 6, 'Order 110 still pending',           'Customer asked why payment is pending; UPI collect request sent.')
--------------

Query OK, 5 rows affected (0.030 sec)
Records: 5  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
SELECT COUNT(*) AS customers FROM customers
--------------

+-----------+
| customers |
+-----------+
|         6 |
+-----------+
1 row in set (0.048 sec)

--------------
SELECT COUNT(*) AS orders FROM orders
--------------

+--------+
| orders |
+--------+
|     10 |
+--------+
1 row in set (0.003 sec)

--------------
SELECT COUNT(*) AS payments FROM payments
--------------

+----------+
| payments |
+----------+
|       10 |
+----------+
1 row in set (0.003 sec)

--------------
SELECT COUNT(*) AS tickets FROM support_tickets
--------------

+---------+
| tickets |
+---------+
|       5 |
+---------+
1 row in set (0.002 sec)

Bye
```

### evidence/13-support-policies.txt

```
--------------
USE ddv_support
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
CREATE MASKING POLICY sup_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.078 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE MASKING POLICY sup_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END
--------------

Query OK, 0 rows affected (0.017 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE MASKING POLICY sup_mask_tax_id(tax_id_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN tax_id_column
     ELSE mask_inner(tax_id_column, 0, 0, '*')
END
--------------

Query OK, 0 rows affected (0.026 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
CREATE MASKING POLICY sup_mask_card(card_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN card_column
     ELSE mask_inner(card_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.021 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
CREATE MASKING POLICY sup_mask_upi(upi_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN upi_column
     ELSE mask_inner(upi_column, 1, 0, '*')
END
--------------

Query OK, 0 rows affected (0.034 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20) NOT NULL MASKING POLICY sup_mask_phone
--------------

Query OK, 0 rows affected (0.116 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE customers MODIFY COLUMN email VARCHAR(100) NOT NULL MASKING POLICY sup_mask_email
--------------

Query OK, 0 rows affected (0.122 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE customers MODIFY COLUMN tax_id VARCHAR(20) NOT NULL MASKING POLICY sup_mask_tax_id
--------------

Query OK, 0 rows affected (0.071 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE payments MODIFY COLUMN card_number VARCHAR(19) NULL MASKING POLICY sup_mask_card
--------------

Query OK, 0 rows affected (0.043 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE payments MODIFY COLUMN upi_id VARCHAR(50) NULL MASKING POLICY sup_mask_upi
--------------

Query OK, 0 rows affected (0.067 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
SELECT * FROM mysql.column_masking_policies
--------------

+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+----------------+
| policy_name     | expression                                                                                                                                                                 | argument      | extra_info | schema_version |
+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+----------------+
| mask_email      | (case when current_user_in(_utf8mb4'ddv_admin@%') then `email_column` else mask_outer(`email_column` AS `email_column`,2 AS `2`,2 AS `2`,_utf8mb4'#' AS `'#'`) end)        | email_column  | []         |              1 |
| mask_phone      | (case when current_user_in(_utf8mb4'ddv_admin@%') then `phone_column` else mask_inner(`phone_column` AS `phone_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end)        | phone_column  | []         |              1 |
| sup_mask_card   | (case when current_role_in(_utf8mb4'r_billing_admin') then `card_column` else mask_inner(`card_column` AS `card_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end)       | card_column   | []         |              1 |
| sup_mask_email  | (case when current_role_in(_utf8mb4'r_billing_admin') then `email_column` else mask_inner(`email_column` AS `email_column`,1 AS `1`,13 AS `13`,_utf8mb4'*' AS `'*'`) end)  | email_column  | []         |              1 |
| sup_mask_phone  | (case when current_role_in(_utf8mb4'r_billing_admin') then `phone_column` else mask_inner(`phone_column` AS `phone_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end)    | phone_column  | []         |              1 |
| sup_mask_tax_id | (case when current_role_in(_utf8mb4'r_billing_admin') then `tax_id_column` else mask_inner(`tax_id_column` AS `tax_id_column`,0 AS `0`,0 AS `0`,_utf8mb4'*' AS `'*'`) end) | tax_id_column | []         |              1 |
| sup_mask_upi    | (case when current_role_in(_utf8mb4'r_billing_admin') then `upi_column` else mask_inner(`upi_column` AS `upi_column`,1 AS `1`,0 AS `0`,_utf8mb4'*' AS `'*'`) end)          | upi_column    | []         |              1 |
+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+----------------+
7 rows in set (0.005 sec)

Bye
```

### evidence/14-roles-grants.txt

```
--------------
CREATE ROLE 'r_support_agent', 'r_billing_admin'
--------------

Query OK, 0 rows affected (0.046 sec)

--------------
GRANT 'r_support_agent' TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.041 sec)

--------------
GRANT 'r_billing_admin' TO 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.029 sec)

--------------
SET DEFAULT ROLE 'r_support_agent' TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.036 sec)

--------------
SET DEFAULT ROLE 'r_billing_admin' TO 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.017 sec)

--------------
GRANT SELECT ON ddv_support.customers       TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%'
--------------

Query OK, 0 rows affected (0.029 sec)

--------------
GRANT SELECT ON ddv_support.orders          TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%'
--------------

Query OK, 0 rows affected (0.028 sec)

--------------
GRANT SELECT ON ddv_support.payments        TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%'
--------------

Query OK, 0 rows affected (0.031 sec)

--------------
GRANT SELECT ON ddv_support.support_tickets TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%'
--------------

Query OK, 0 rows affected (0.040 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

Bye
```

### evidence/15-verify-agent.txt

```
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
SELECT * FROM ddv_support.customers ORDER BY id
--------------

+----+------------------+----------+-------------------------------+-----------+
| id | full_name        | phone    | email                         | tax_id    |
+----+------------------+----------+-------------------------------+-----------+
|  1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|  2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|  3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|  4 | Dana Placeholder | ****0104 | d***************@example.test | ********* |
|  5 | Elif Fictional   | ****0105 | e*************@example.test   | ********* |
|  6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
+----+------------------+----------+-------------------------------+-----------+
6 rows in set (0.019 sec)

--------------
SELECT o.id AS order_id, o.status, o.total_amount, o.created_at, c.id AS customer_id, c.full_name, c.phone, c.email, c.tax_id
  FROM ddv_support.orders o JOIN ddv_support.customers c ON c.id = o.customer_id ORDER BY o.id
--------------

+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
| order_id | status    | total_amount | created_at          | customer_id | full_name        | phone    | email                         | tax_id    |
+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
|      101 | delivered |      1250.00 | 2026-09-01 10:15:00 |           1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|      102 | shipped   |       349.50 | 2026-09-20 14:02:00 |           1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|      103 | delivered |       899.99 | 2026-09-03 09:40:00 |           2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|      104 | refunded  |       120.00 | 2026-09-11 16:25:00 |           2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|      105 | pending   |        45.00 | 2026-10-02 11:05:00 |           3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|      106 | delivered |       310.75 | 2026-09-28 18:30:00 |           3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|      107 | cancelled |        75.25 | 2026-09-15 08:55:00 |           4 | Dana Placeholder | ****0104 | d***************@example.test | ********* |
|      108 | shipped   |       560.00 | 2026-10-05 13:45:00 |           5 | Elif Fictional   | ****0105 | e*************@example.test   | ********* |
|      109 | delivered |        99.99 | 2026-10-10 17:10:00 |           6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
|      110 | pending   |       210.40 | 2026-10-12 12:00:00 |           6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
10 rows in set (0.011 sec)

--------------
SELECT * FROM ddv_support.payments ORDER BY id
--------------

+------+----------+--------+------------------+----------------+----------+
| id   | order_id | method | card_number      | upi_id         | status   |
+------+----------+--------+------------------+----------------+----------+
| 1001 |      101 | card   | ************1111 | NULL           | captured |
| 1002 |      102 | upi    | NULL             | a************  | captured |
| 1003 |      103 | card   | ************4444 | NULL           | captured |
| 1004 |      104 | card   | ************4444 | NULL           | refunded |
| 1005 |      105 | upi    | NULL             | c************  | pending  |
| 1006 |      106 | card   | ***********0005  | NULL           | captured |
| 1007 |      107 | card   | ************1117 | NULL           | voided   |
| 1008 |      108 | upi    | NULL             | e************  | captured |
| 1009 |      109 | card   | ************4242 | NULL           | captured |
| 1010 |      110 | upi    | NULL             | f************* | pending  |
+------+----------+--------+------------------+----------------+----------+
10 rows in set (0.003 sec)

--------------
SELECT * FROM ddv_support.support_tickets ORDER BY id
--------------

+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
| id | customer_id | subject                         | notes                                                                                                                |
+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
|  1 |           1 | Where is my order 102?          | Customer asked for tracking. Shipped 2026-09-20.                                                                     |
|  2 |           2 | Refund for order 104            | Refund issued to original payment method.                                                                            |
|  3 |           3 | Charge failed, please call back | Customer typed: my card is 5555555555554444 and you can reach me at chen.demo@example.test, please retry the charge. |
|  4 |           5 | Change delivery address         | Address change requested before shipment.                                                                            |
|  5 |           6 | Order 110 still pending         | Customer asked why payment is pending; UPI collect request sent.                                                     |
+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
5 rows in set (0.004 sec)

Bye
```

### evidence/15-verify-norole.txt

```
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_norole@%   | NONE           |
+----------------+----------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM ddv_support.customers ORDER BY id
--------------

+----+------------------+----------+-------------------------------+-----------+
| id | full_name        | phone    | email                         | tax_id    |
+----+------------------+----------+-------------------------------+-----------+
|  1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|  2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|  3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|  4 | Dana Placeholder | ****0104 | d***************@example.test | ********* |
|  5 | Elif Fictional   | ****0105 | e*************@example.test   | ********* |
|  6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
+----+------------------+----------+-------------------------------+-----------+
6 rows in set (0.009 sec)

--------------
SELECT o.id AS order_id, o.status, o.total_amount, o.created_at, c.id AS customer_id, c.full_name, c.phone, c.email, c.tax_id
  FROM ddv_support.orders o JOIN ddv_support.customers c ON c.id = o.customer_id ORDER BY o.id
--------------

+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
| order_id | status    | total_amount | created_at          | customer_id | full_name        | phone    | email                         | tax_id    |
+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
|      101 | delivered |      1250.00 | 2026-09-01 10:15:00 |           1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|      102 | shipped   |       349.50 | 2026-09-20 14:02:00 |           1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|      103 | delivered |       899.99 | 2026-09-03 09:40:00 |           2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|      104 | refunded  |       120.00 | 2026-09-11 16:25:00 |           2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|      105 | pending   |        45.00 | 2026-10-02 11:05:00 |           3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|      106 | delivered |       310.75 | 2026-09-28 18:30:00 |           3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|      107 | cancelled |        75.25 | 2026-09-15 08:55:00 |           4 | Dana Placeholder | ****0104 | d***************@example.test | ********* |
|      108 | shipped   |       560.00 | 2026-10-05 13:45:00 |           5 | Elif Fictional   | ****0105 | e*************@example.test   | ********* |
|      109 | delivered |        99.99 | 2026-10-10 17:10:00 |           6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
|      110 | pending   |       210.40 | 2026-10-12 12:00:00 |           6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
10 rows in set (0.016 sec)

--------------
SELECT * FROM ddv_support.payments ORDER BY id
--------------

+------+----------+--------+------------------+----------------+----------+
| id   | order_id | method | card_number      | upi_id         | status   |
+------+----------+--------+------------------+----------------+----------+
| 1001 |      101 | card   | ************1111 | NULL           | captured |
| 1002 |      102 | upi    | NULL             | a************  | captured |
| 1003 |      103 | card   | ************4444 | NULL           | captured |
| 1004 |      104 | card   | ************4444 | NULL           | refunded |
| 1005 |      105 | upi    | NULL             | c************  | pending  |
| 1006 |      106 | card   | ***********0005  | NULL           | captured |
| 1007 |      107 | card   | ************1117 | NULL           | voided   |
| 1008 |      108 | upi    | NULL             | e************  | captured |
| 1009 |      109 | card   | ************4242 | NULL           | captured |
| 1010 |      110 | upi    | NULL             | f************* | pending  |
+------+----------+--------+------------------+----------------+----------+
10 rows in set (0.004 sec)

--------------
SELECT * FROM ddv_support.support_tickets ORDER BY id
--------------

+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
| id | customer_id | subject                         | notes                                                                                                                |
+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
|  1 |           1 | Where is my order 102?          | Customer asked for tracking. Shipped 2026-09-20.                                                                     |
|  2 |           2 | Refund for order 104            | Refund issued to original payment method.                                                                            |
|  3 |           3 | Charge failed, please call back | Customer typed: my card is 5555555555554444 and you can reach me at chen.demo@example.test, please retry the charge. |
|  4 |           5 | Change delivery address         | Address change requested before shipment.                                                                            |
|  5 |           6 | Order 110 still pending         | Customer asked why payment is pending; UPI collect request sent.                                                     |
+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
5 rows in set (0.005 sec)

Bye
```

### evidence/16-verify-billing-set-role-none.txt

```
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
SELECT * FROM ddv_support.customers ORDER BY id
--------------

+----+------------------+----------+-------------------------------+-----------+
| id | full_name        | phone    | email                         | tax_id    |
+----+------------------+----------+-------------------------------+-----------+
|  1 | Asha Example     | 555-0101 | asha.example@example.test     | TEST-0001 |
|  2 | Bilal Sample     | 555-0102 | bilal.sample@example.test     | TEST-0002 |
|  3 | Chen Demo        | 555-0103 | chen.demo@example.test        | TEST-0003 |
|  4 | Dana Placeholder | 555-0104 | dana.placeholder@example.test | TEST-0004 |
|  5 | Elif Fictional   | 555-0105 | elif.fictional@example.test   | TEST-0005 |
|  6 | Farid Mock       | 555-0106 | farid.mock@example.test       | TEST-0006 |
+----+------------------+----------+-------------------------------+-----------+
6 rows in set (0.023 sec)

--------------
SELECT o.id AS order_id, o.status, o.total_amount, o.created_at, c.id AS customer_id, c.full_name, c.phone, c.email, c.tax_id
  FROM ddv_support.orders o JOIN ddv_support.customers c ON c.id = o.customer_id ORDER BY o.id
--------------

+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
| order_id | status    | total_amount | created_at          | customer_id | full_name        | phone    | email                         | tax_id    |
+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
|      101 | delivered |      1250.00 | 2026-09-01 10:15:00 |           1 | Asha Example     | 555-0101 | asha.example@example.test     | TEST-0001 |
|      102 | shipped   |       349.50 | 2026-09-20 14:02:00 |           1 | Asha Example     | 555-0101 | asha.example@example.test     | TEST-0001 |
|      103 | delivered |       899.99 | 2026-09-03 09:40:00 |           2 | Bilal Sample     | 555-0102 | bilal.sample@example.test     | TEST-0002 |
|      104 | refunded  |       120.00 | 2026-09-11 16:25:00 |           2 | Bilal Sample     | 555-0102 | bilal.sample@example.test     | TEST-0002 |
|      105 | pending   |        45.00 | 2026-10-02 11:05:00 |           3 | Chen Demo        | 555-0103 | chen.demo@example.test        | TEST-0003 |
|      106 | delivered |       310.75 | 2026-09-28 18:30:00 |           3 | Chen Demo        | 555-0103 | chen.demo@example.test        | TEST-0003 |
|      107 | cancelled |        75.25 | 2026-09-15 08:55:00 |           4 | Dana Placeholder | 555-0104 | dana.placeholder@example.test | TEST-0004 |
|      108 | shipped   |       560.00 | 2026-10-05 13:45:00 |           5 | Elif Fictional   | 555-0105 | elif.fictional@example.test   | TEST-0005 |
|      109 | delivered |        99.99 | 2026-10-10 17:10:00 |           6 | Farid Mock       | 555-0106 | farid.mock@example.test       | TEST-0006 |
|      110 | pending   |       210.40 | 2026-10-12 12:00:00 |           6 | Farid Mock       | 555-0106 | farid.mock@example.test       | TEST-0006 |
+----------+-----------+--------------+---------------------+-------------+------------------+----------+-------------------------------+-----------+
10 rows in set (0.009 sec)

--------------
SELECT * FROM ddv_support.payments ORDER BY id
--------------

+------+----------+--------+------------------+----------------+----------+
| id   | order_id | method | card_number      | upi_id         | status   |
+------+----------+--------+------------------+----------------+----------+
| 1001 |      101 | card   | 4111111111111111 | NULL           | captured |
| 1002 |      102 | upi    | NULL             | asha@testbank  | captured |
| 1003 |      103 | card   | 5555555555554444 | NULL           | captured |
| 1004 |      104 | card   | 5555555555554444 | NULL           | refunded |
| 1005 |      105 | upi    | NULL             | chen@testbank  | pending  |
| 1006 |      106 | card   | 378282246310005  | NULL           | captured |
| 1007 |      107 | card   | 6011111111111117 | NULL           | voided   |
| 1008 |      108 | upi    | NULL             | elif@testbank  | captured |
| 1009 |      109 | card   | 4242424242424242 | NULL           | captured |
| 1010 |      110 | upi    | NULL             | farid@testbank | pending  |
+------+----------+--------+------------------+----------------+----------+
10 rows in set (0.011 sec)

--------------
SELECT * FROM ddv_support.support_tickets ORDER BY id
--------------

+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
| id | customer_id | subject                         | notes                                                                                                                |
+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
|  1 |           1 | Where is my order 102?          | Customer asked for tracking. Shipped 2026-09-20.                                                                     |
|  2 |           2 | Refund for order 104            | Refund issued to original payment method.                                                                            |
|  3 |           3 | Charge failed, please call back | Customer typed: my card is 5555555555554444 and you can reach me at chen.demo@example.test, please retry the charge. |
|  4 |           5 | Change delivery address         | Address change requested before shipment.                                                                            |
|  5 |           6 | Order 110 still pending         | Customer asked why payment is pending; UPI collect request sent.                                                     |
+----+-------------+---------------------------------+----------------------------------------------------------------------------------------------------------------------+
5 rows in set (0.005 sec)

--------------
SET ROLE NONE
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+----------------+
| CURRENT_USER() | CURRENT_ROLE() |
+----------------+----------------+
| ddv_billing@%  | NONE           |
+----------------+----------------+
1 row in set (0.001 sec)

--------------
SELECT * FROM ddv_support.customers ORDER BY id
--------------

+----+------------------+----------+-------------------------------+-----------+
| id | full_name        | phone    | email                         | tax_id    |
+----+------------------+----------+-------------------------------+-----------+
|  1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|  2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|  3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|  4 | Dana Placeholder | ****0104 | d***************@example.test | ********* |
|  5 | Elif Fictional   | ****0105 | e*************@example.test   | ********* |
|  6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
+----+------------------+----------+-------------------------------+-----------+
6 rows in set (0.003 sec)

Bye
```

### evidence/17-policies-root.txt

```
--------------
SELECT * FROM mysql.column_masking_policies
--------------

+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+----------------+
| policy_name     | expression                                                                                                                                                                 | argument      | extra_info | schema_version |
+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+----------------+
| mask_email      | (case when current_user_in(_utf8mb4'ddv_admin@%') then `email_column` else mask_outer(`email_column` AS `email_column`,2 AS `2`,2 AS `2`,_utf8mb4'#' AS `'#'`) end)        | email_column  | []         |              1 |
| mask_phone      | (case when current_user_in(_utf8mb4'ddv_admin@%') then `phone_column` else mask_inner(`phone_column` AS `phone_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end)        | phone_column  | []         |              1 |
| sup_mask_card   | (case when current_role_in(_utf8mb4'r_billing_admin') then `card_column` else mask_inner(`card_column` AS `card_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end)       | card_column   | []         |              1 |
| sup_mask_email  | (case when current_role_in(_utf8mb4'r_billing_admin') then `email_column` else mask_inner(`email_column` AS `email_column`,1 AS `1`,13 AS `13`,_utf8mb4'*' AS `'*'`) end)  | email_column  | []         |              1 |
| sup_mask_phone  | (case when current_role_in(_utf8mb4'r_billing_admin') then `phone_column` else mask_inner(`phone_column` AS `phone_column`,0 AS `0`,4 AS `4`,_utf8mb4'*' AS `'*'`) end)    | phone_column  | []         |              1 |
| sup_mask_tax_id | (case when current_role_in(_utf8mb4'r_billing_admin') then `tax_id_column` else mask_inner(`tax_id_column` AS `tax_id_column`,0 AS `0`,0 AS `0`,_utf8mb4'*' AS `'*'`) end) | tax_id_column | []         |              1 |
| sup_mask_upi    | (case when current_role_in(_utf8mb4'r_billing_admin') then `upi_column` else mask_inner(`upi_column` AS `upi_column`,1 AS `1`,0 AS `0`,_utf8mb4'*' AS `'*'`) end)          | upi_column    | []         |              1 |
+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+----------------+
7 rows in set (0.011 sec)

Bye
```

### evidence/18-show-grants.txt

```
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
SHOW GRANTS FOR 'r_support_agent'@'%'
--------------

+---------------------------------------------+
| Grants for r_support_agent@%                |
+---------------------------------------------+
| GRANT USAGE ON *.* TO `r_support_agent`@`%` |
+---------------------------------------------+
1 row in set (0.001 sec)

--------------
SHOW GRANTS FOR 'r_billing_admin'@'%'
--------------

+---------------------------------------------+
| Grants for r_billing_admin@%                |
+---------------------------------------------+
| GRANT USAGE ON *.* TO `r_billing_admin`@`%` |
+---------------------------------------------+
1 row in set (0.001 sec)

Bye
```

### evidence/19-show-create-agent.txt

```
--------------
SHOW CREATE TABLE ddv_support.customers
--------------

+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table     | Create Table                                                                                                                                                                                                                                                                                                                                                                    |
+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| customers | CREATE TABLE `customers` (
  `id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) MASKING POLICY `sup_mask_phone` NOT NULL,
  `email` varchar(100) MASKING POLICY `sup_mask_email` NOT NULL,
  `tax_id` varchar(20) MASKING POLICY `sup_mask_tax_id` NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.032 sec)

--------------
SHOW CREATE TABLE ddv_support.orders
--------------

+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table  | Create Table                                                                                                                                                                                                                                                                                                                                                                                                |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| orders | CREATE TABLE `orders` (
  `id` int NOT NULL,
  `customer_id` int NOT NULL,
  `status` varchar(20) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.010 sec)

--------------
SHOW CREATE TABLE ddv_support.payments
--------------

+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table    | Create Table                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| payments | CREATE TABLE `payments` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `method` varchar(10) NOT NULL,
  `card_number` varchar(19) MASKING POLICY `sup_mask_card` DEFAULT NULL,
  `upi_id` varchar(50) MASKING POLICY `sup_mask_upi` DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.011 sec)

--------------
SHOW CREATE TABLE ddv_support.support_tickets
--------------

+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table           | Create Table                                                                                                                                                                                                                                                                                                                                                                  |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| support_tickets | CREATE TABLE `support_tickets` (
  `id` int NOT NULL,
  `customer_id` int NOT NULL,
  `subject` varchar(200) NOT NULL,
  `notes` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.006 sec)

Bye
```

## Not captured

- The creation of ddv_billing and ddv_norole ran from a generated, gitignored file containing real random passwords, executed without -v so nothing was echoed. It is not in evidence/. sql/00-create-users.template.sql is a redacted template only.
- ddv_agent already existed from Step 1; its password was not changed or captured.
- The earlier component install printed 2 warnings that were never captured.
- An initial root connectivity check (users, schemas, role variables, existing policy names) was run on the command line and its output was not saved to evidence/.
- sql/15-verify-user.sql was run twice, as ddv_agent and as ddv_norole, giving 15-verify-agent.txt and 15-verify-norole.txt.
- The root connection used --defaults-extra-file with a credentials file outside the repository; it was not read or copied.

## Observations

Claude Code's reading of the files above. This is not evidence.

- 10 and 11: ddv_agent held SELECT on ddv_mask.* before the revoke and only USAGE on *.* afterwards.
- 18: ddv_agent, ddv_billing and ddv_norole each hold SELECT on the four ddv_support tables directly; the two roles hold only USAGE. ddv_norole has no role granted.
- Fail-safe: ddv_norole (no role) and ddv_billing after SET ROLE NONE both received masked values with no error. ddv_billing with r_billing_admin active received unmasked values.
- Agent usefulness: ddv_agent could read all orders, statuses, totals and dates, the unmasked full_name and customer id, the last four of phone and card, and the first character plus domain of email. Last-four values are not unique across customers (e.g. cards 1003 and 1004 both end 4444, belonging to the same customer here).
- Email masking leaves the number of asterisks equal to the local-part length, so local-part length is visible.
- Free text: support_tickets.notes row 3 shows a full test card number and an email address unmasked to ddv_agent, ddv_norole and ddv_billing alike. The same card number appears masked in payments for the agent. Column masking did not reach the free-text column.
- 17: five sup_mask_* policies are present in mysql.column_masking_policies.

## git status --short

(see command output; report is not committed)
