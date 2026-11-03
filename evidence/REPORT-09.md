# REPORT-09: Step 6, Enterprise Audit component, documented route

Step 6, the Enterprise Audit component by the documented route: `audit_log_component_filter_install.sql` run with `-D mysql` (authorised by the author), a filter `agent_log` (`{ "filter": { "log": true } }`) assigned to `ddv_agent@%` only, the scripted agent plus five out-of-workflow selects and four tampering statements run as `ddv_agent`, the log read with `audit_log_read` as root, then filter and user removed and the documented uninstall script run with `-D mysql`.

Run order: 60 baseline, install, state, filter, status for three accounts; 61 agent runs; 62 log read; 63 removal, uninstall, after-snapshot, compare. Every capture is `mysql --table -vvv --force` through cmd, with `--show-warnings` for the install, state and filter runs.

`evidence/62-audit-read.txt` is the first read and is incomplete (89 events); `evidence/62-audit-read-complete.txt` is the paged read (98 events). Both are kept. The raw JSON is not in the repo.

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
047409996fd282b1bbeb372b1bd117f69d99dea38ebecdb62f5504be31d7a59b  agent/support_agent_audit.py
27289edeeb32d8c23c406aec7628b63c6fdb5a353c7ddba2822a662f2e81e57f  evidence/60-audit-filter.txt
57271be0c7bb7260bfa1001abbb7a92b004144b7205678ca923e3cb5d1d7550c  evidence/60-audit-install.txt
ec1a8d4b162ca6ca2ca3a49369645e61341131d6e6991b5ba8ba9d3a750dee07  evidence/60-audit-state.txt
2f707d43a6a80607c6e673e660e5566e3f47380e3021027511b5c5d0e44ad0e7  evidence/60-baseline.txt
a3cb5f5a5724b30c00dd58a03e9dc8db2ae940c9d561d5acd01ddc735ebda9d2  evidence/60-status-agent.txt
f2481e3a1b33aa63a43f28720595ba1e6f7da52ae0192ecfd7bfdc4ec0434a7a  evidence/60-status-billing.txt
9c2a890ac015486c8d3e6e4f6e17b9ce42ee1167af7e06e5b3a88b2dde9661f8  evidence/60-status-root.txt
08da560a2e3fe1b94691e241a583f958361fcf304b26c75820531a6f230a4c0e  evidence/61-audit-agent-run.txt
faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671  evidence/61-audit-llm-context.txt
51dbf1f2cb7c3ded83234e0c1d36e9c2b465c18855bee38d1ff98fa45618173b  evidence/61-outofworkflow-1.txt
d031e753ab38afd3a673fde7ed3f46d08da1a109c5544f85bb561a1ebe03d0bd  evidence/61-outofworkflow-2.txt
025bcaa5e3cced372165c3ed74a9aa6b2539ad33b1d6a88cb189db7e0c56dbd1  evidence/61-outofworkflow-3.txt
0f2c93162e01eb0c7e2987aeac8afeddf4391416eccdc616edba15a679ddca0f  evidence/61-outofworkflow-4.txt
813a3fc6395ff1c6dd5f47433c3f1676f1c6f8eb72e7e9d6717b0180faca7c38  evidence/61-outofworkflow-5.txt
f915dc319e5c36b2906dce3e64e6795ced82c502c366de61c64c44cd45c794af  evidence/61-tampering-1.txt
b92b96a5c6b0b995a3329cdb922561929be901eeb0e5c6bf16204c8351bd6469  evidence/61-tampering-2.txt
e9b2651a6c5e28eba0ded3741d332a3b8fec1e96a729e6ca11b275a5b9ed9899  evidence/61-tampering-3.txt
7d860a2274d11565ee92babbdbac9eedaa59cceb03ed09ac332da96ad68301d5  evidence/61-tampering-4.txt
ecd24b23c262507ba657e2ef5a694db3f887c38f38e66bdb340bb204a6af761a  evidence/62-audit-read.txt
462f0328bd02585a71a65b252cf9c9f3db1ef482a1b274ae9896e5e13120989e  evidence/62-audit-read-complete.txt
58e6a199e7e971156de5498322e56f264f095141daf252596de48569642f67b5  evidence/63-after.txt
9a6064c3a83d1bc14f69fc209694531dd6a01a8f2b8ade6ff5a6d472e44a445f  evidence/63-audit-remove.txt
85432a1150ccb236401ed1fc32cdaab0a72bc62fc2f8dd45657a91340c6e2574  evidence/63-audit-uninstall.txt
ce030da78fdf204f968ceed9b58eb28a069bb598bf76890f91679ce81874dea5  evidence/63-compare.txt
c44ce8387e426f6d173ec555c561d89a4216d19d39bac33025c5ac4f7b8852ac  sql/60-audit-filter.sql
a202e97f6516b18e2245d206f90fe3039b74af594bba38cfd69ca885c796d8e5  sql/60-audit-state.sql
cebd34c8a4ffa9ff1c48251aa5626c374cab120a79498134192e2b27cad1a037  sql/60-audit-status.sql
c7994aef37cefeae28c36fc3b2531ac8a7e6894ad767a2cf7491ed62de2201d2  sql/60-snapshot.sql
07a020ad02a6c4beaefd30cce44dec18335d4ce2509bd142cb38cbb1a57644b9  sql/61-outofworkflow-1.sql
7a67024e80a7b525508f884e3a680edb7a225dd11afbe50d3703caa3e3c29e22  sql/61-outofworkflow-2.sql
c261a3937d5c4f6cfd29c52029781c060bf2e9e7689c35b9750081d174ca9d9d  sql/61-outofworkflow-3.sql
4cf2e6d757174c0589fcbae1ba031ea07ce30e7b8ebaa8a2ca8e2301dfe5e520  sql/61-outofworkflow-4.sql
d3cd5042f97738960d802ad6b3a548dfa18152215118ba18f04493bc6944b0e4  sql/61-outofworkflow-5.sql
1c02af14065b1db3f01361def465d86e616c6aa45debde2c807a38ef669def9f  sql/61-tampering-1.sql
2680c150fbd857741504abe90fcbd5a74f2e9a3482750de11863220d68d612bd  sql/61-tampering-2.sql
df1666896c6a13f988e7fcc9336f0db7b5294b4af34d5729197565086666f74a  sql/61-tampering-3.sql
38378804d62846ed3ef75f36731c907698b39100ec0f9a0df1829a784d01f5d3  sql/61-tampering-4.sql
30d54ff3fec2c3c28e99c27ce4b8ac2d5721764ae808ec767473fc008b8afa83  sql/63-audit-remove.sql
```

## Evidence (verbatim)

### evidence/60-audit-filter.txt
````text
--------------
SELECT audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }')
--------------

+---------------------------------------------------------------------------+
| audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }') |
+---------------------------------------------------------------------------+
| OK                                                                        |
+---------------------------------------------------------------------------+
1 row in set (0.050 sec)

--------------
SELECT audit_log_filter_set_user('ddv_agent@%', 'agent_log')
--------------

+-------------------------------------------------------+
| audit_log_filter_set_user('ddv_agent@%', 'agent_log') |
+-------------------------------------------------------+
| OK                                                    |
+-------------------------------------------------------+
1 row in set (0.044 sec)

--------------
SELECT * FROM mysql.audit_log_filter
--------------

+-----------+---------------------------+
| NAME      | FILTER                    |
+-----------+---------------------------+
| agent_log | {"filter": {"log": true}} |
+-----------+---------------------------+
1 row in set (0.008 sec)

--------------
SELECT * FROM mysql.audit_log_user
--------------

+-----------+------+------------+
| USER      | HOST | FILTERNAME |
+-----------+------+------------+
| ddv_agent | %    | agent_log  |
+-----------+------+------------+
1 row in set (0.008 sec)

Bye
````

### evidence/60-audit-install.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
CREATE TABLE IF NOT EXISTS audit_log_filter(NAME VARCHAR(64) BINARY NOT NULL PRIMARY KEY, FILTER JSON NOT NULL) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 1 warning (0.297 sec)

Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
--------------
CREATE TABLE IF NOT EXISTS audit_log_user(USER VARCHAR(32) BINARY NOT NULL, HOST VARCHAR(255) CHARACTER SET ASCII NOT NULL, FILTERNAME VARCHAR(64) BINARY NOT NULL, PRIMARY KEY (USER, HOST), FOREIGN KEY (FILTERNAME) REFERENCES audit_log_filter(NAME)) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 2 warnings (0.416 sec)

Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
--------------
INSTALL COMPONENT "file://component_audit_log"
--------------

Query OK, 0 rows affected (0.289 sec)

Bye
````

### evidence/60-audit-state.txt
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
|            6 |                  6 | file://component_audit_log         |
+--------------+--------------------+------------------------------------+
4 rows in set (0.008 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

+--------------------------+
| Tables_in_mysql (audit%) |
+--------------------------+
| audit_log_filter         |
| audit_log_user           |
+--------------------------+
2 rows in set (0.051 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

+--------------------------------------+------------------------------------+
| Variable_name                        | Value                              |
+--------------------------------------+------------------------------------+
| audit_log.buffer_size                | 1048576                            |
| audit_log.compression                | NONE                               |
| audit_log.database                   | mysql                              |
| audit_log.disable                    | OFF                                |
| audit_log.encryption                 | NONE                               |
| audit_log.file                       | audit.log                          |
| audit_log.filter_recovery_mode       | LOG_ALL_IF_INVALID_FILTER_DETECTED |
| audit_log.flush_interval_seconds     | 0                                  |
| audit_log.format_unix_timestamp      | OFF                                |
| audit_log.max_size                   | 0                                  |
| audit_log.password_history_keep_days | 0                                  |
| audit_log.prune_seconds              | 0                                  |
| audit_log.read_buffer_size           | 32768                              |
| audit_log.rotate_on_size             | 0                                  |
| audit_log.rotate_on_time             | 0                                  |
| audit_log.rotate_threshold           | 10                                 |
| audit_log.strategy                   | ASYNCHRONOUS                       |
+--------------------------------------+------------------------------------+
17 rows in set (0.079 sec)

--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 477   |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 23    |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 1     |
| audit_log.file_count           | 1     |
| audit_log.filter_id            | 0     |
| audit_log.total_size           | 477   |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.035 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.016 sec)

--------------
SELECT UDF_NAME FROM performance_schema.user_defined_functions WHERE UDF_NAME LIKE 'audit_log%' ORDER BY 1
--------------

+-----------------------------------+
| UDF_NAME                          |
+-----------------------------------+
| audit_log_encryption_password_get |
| audit_log_encryption_password_set |
| audit_log_filter_flush            |
| audit_log_filter_remove_filter    |
| audit_log_filter_remove_user      |
| audit_log_filter_set_filter       |
| audit_log_filter_set_user         |
| audit_log_read                    |
| audit_log_read_bookmark           |
| audit_log_rotate                  |
+-----------------------------------+
10 rows in set (0.076 sec)

--------------
SELECT * FROM mysql.audit_log_filter
--------------

Empty set (0.007 sec)

--------------
SELECT * FROM mysql.audit_log_user
--------------

Empty set (0.004 sec)

Bye
````

### evidence/60-baseline.txt
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
3 rows in set (0.007 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.062 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.046 sec)

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

### evidence/60-status-agent.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 1712  |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 88    |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 4     |
| audit_log.file_count           | 1     |
| audit_log.filter_id            | 1     |
| audit_log.total_size           | 1712  |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.021 sec)

Bye
````

### evidence/60-status-billing.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 2379  |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 101   |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 6     |
| audit_log.file_count           | 1     |
| audit_log.filter_id            | 0     |
| audit_log.total_size           | 2379  |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.022 sec)

Bye
````

### evidence/60-status-root.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 477   |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 74    |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 1     |
| audit_log.file_count           | 1     |
| audit_log.filter_id            | 0     |
| audit_log.total_size           | 477   |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.009 sec)

Bye
````

### evidence/61-audit-agent-run.txt
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
context written to evidence/61-audit-llm-context.txt
````

### evidence/61-audit-llm-context.txt
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

### evidence/61-outofworkflow-1.txt
````text
--------------
SELECT * FROM ddv_support.customers
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
6 rows in set (0.006 sec)

Bye
````

### evidence/61-outofworkflow-2.txt
````text
--------------
SELECT * FROM ddv_support.payments
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
10 rows in set (0.007 sec)

Bye
````

### evidence/61-outofworkflow-3.txt
````text
--------------
SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
--------------

+--------------+
| full_name    |
+--------------+
| Asha Example |
+--------------+
1 row in set (0.008 sec)

Bye
````

### evidence/61-outofworkflow-4.txt
````text
--------------
SELECT * FROM ddv_support.support_tickets
--------------

+----+-------------+---------------------------------+---------------------------------------------------------------------------------------------------------------------+
| id | customer_id | subject                         | notes                                                                                                               |
+----+-------------+---------------------------------+---------------------------------------------------------------------------------------------------------------------+
|  1 |           1 | Where is my order 102?          | Customer asked for tracking. Shipped 2026-09-20.                                                                    |
|  2 |           2 | Refund for order 104            | Refund issued to original payment method.                                                                           |
|  3 |           3 | Charge failed, please call back | Customer typed: my card is 378282246310005 and you can reach me at chen.demo@example.test, please retry the charge. |
|  4 |           5 | Change delivery address         | Address change requested before shipment.                                                                           |
|  5 |           6 | Order 110 still pending         | Customer asked why payment is pending; UPI collect request sent.                                                    |
+----+-------------+---------------------------------+---------------------------------------------------------------------------------------------------------------------+
5 rows in set (0.006 sec)

Bye
````

### evidence/61-outofworkflow-5.txt
````text
--------------
SELECT 1
--------------

+---+
| 1 |
+---+
| 1 |
+---+
1 row in set (0.002 sec)

Bye
````

### evidence/61-tampering-1.txt
````text
--------------
ALTER TABLE ddv_support.customers MODIFY COLUMN phone VARCHAR(20) NOT NULL
--------------

Bye
````

### evidence/61-tampering-2.txt
````text
--------------
DROP MASKING POLICY sup_mask_phone
--------------

Bye
````

### evidence/61-tampering-3.txt
````text
--------------
CREATE TABLE ddv_support.copy_customers AS SELECT * FROM ddv_support.customers
--------------

Bye
````

### evidence/61-tampering-4.txt
````text
--------------
CREATE VIEW ddv_support.v_leak AS SELECT * FROM ddv_support.customers
--------------

Bye
````

### evidence/62-audit-read.txt
````text
Extract of audit_log_read output (89 events). Raw JSON not saved: it contained a local path, the machine name and the OS user. Kept per event: event class, account, command class, status, statement text. Timestamps, ids, IP, OS user and connection attributes are omitted.
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
51 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
52 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
53 | table_access/read | ddv_agent@localhost | select |  | SELECT * FROM ddv_support.customers
54 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT * FROM ddv_support.customers
55 | connection/disconnect | ddv_agent@localhost | ssl |  | 
56 | connection/connect | ddv_agent@localhost | ssl | 0 | 
57 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
58 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
59 | table_access/read | ddv_agent@localhost | select |  | SELECT * FROM ddv_support.payments
60 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT * FROM ddv_support.payments
61 | connection/disconnect | ddv_agent@localhost | ssl |  | 
62 | connection/connect | ddv_agent@localhost | ssl | 0 | 
63 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
64 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
65 | table_access/read | ddv_agent@localhost | select |  | SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
66 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
67 | connection/disconnect | ddv_agent@localhost | ssl |  | 
68 | connection/connect | ddv_agent@localhost | ssl | 0 | 
69 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
70 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
71 | table_access/read | ddv_agent@localhost | select |  | SELECT * FROM ddv_support.support_tickets
72 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT * FROM ddv_support.support_tickets
73 | connection/disconnect | ddv_agent@localhost | ssl |  | 
74 | connection/connect | ddv_agent@localhost | ssl | 0 | 
75 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
76 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
77 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT 1
78 | connection/disconnect | ddv_agent@localhost | ssl |  | 
79 | connection/connect | ddv_agent@localhost | ssl | 0 | 
80 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
81 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
82 | general/status | ddv_agent@localhost | Query/alter_table | 1142 | ALTER TABLE ddv_support.customers MODIFY COLUMN phone VARCHAR(20) NOT NULL
83 | connection/disconnect | ddv_agent@localhost | ssl |  | 
84 | connection/connect | ddv_agent@localhost | ssl | 0 | 
85 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
86 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
87 | general/status | ddv_agent@localhost | Query/drop_masking_policy | 1227 | DROP MASKING POLICY sup_mask_phone
88 | connection/disconnect | ddv_agent@localhost | ssl |  | 
89 | connection/connect | ddv_agent@localhost | ssl | 0 | 
````

### evidence/62-audit-read-complete.txt
````text
Extract of audit_log_read output (98 events, read in pages of 40; the array ended with a null end marker, not counted). Raw JSON not saved: it contained a local path, the machine name and the OS user. Kept per event: event class, account, command class, status, statement text. Timestamps, ids, IP, OS user and connection attributes are omitted.
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
51 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
52 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
53 | table_access/read | ddv_agent@localhost | select |  | SELECT * FROM ddv_support.customers
54 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT * FROM ddv_support.customers
55 | connection/disconnect | ddv_agent@localhost | ssl |  | 
56 | connection/connect | ddv_agent@localhost | ssl | 0 | 
57 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
58 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
59 | table_access/read | ddv_agent@localhost | select |  | SELECT * FROM ddv_support.payments
60 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT * FROM ddv_support.payments
61 | connection/disconnect | ddv_agent@localhost | ssl |  | 
62 | connection/connect | ddv_agent@localhost | ssl | 0 | 
63 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
64 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
65 | table_access/read | ddv_agent@localhost | select |  | SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
66 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
67 | connection/disconnect | ddv_agent@localhost | ssl |  | 
68 | connection/connect | ddv_agent@localhost | ssl | 0 | 
69 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
70 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
71 | table_access/read | ddv_agent@localhost | select |  | SELECT * FROM ddv_support.support_tickets
72 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT * FROM ddv_support.support_tickets
73 | connection/disconnect | ddv_agent@localhost | ssl |  | 
74 | connection/connect | ddv_agent@localhost | ssl | 0 | 
75 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
76 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
77 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT 1
78 | connection/disconnect | ddv_agent@localhost | ssl |  | 
79 | connection/connect | ddv_agent@localhost | ssl | 0 | 
80 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
81 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
82 | general/status | ddv_agent@localhost | Query/alter_table | 1142 | ALTER TABLE ddv_support.customers MODIFY COLUMN phone VARCHAR(20) NOT NULL
83 | connection/disconnect | ddv_agent@localhost | ssl |  | 
84 | connection/connect | ddv_agent@localhost | ssl | 0 | 
85 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
86 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
87 | general/status | ddv_agent@localhost | Query/drop_masking_policy | 1227 | DROP MASKING POLICY sup_mask_phone
88 | connection/disconnect | ddv_agent@localhost | ssl |  | 
89 | connection/connect | ddv_agent@localhost | ssl | 0 | 
90 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
91 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
92 | general/status | ddv_agent@localhost | Query/create_table | 1142 | CREATE TABLE ddv_support.copy_customers AS SELECT * FROM ddv_support.customers
93 | connection/disconnect | ddv_agent@localhost | ssl |  | 
94 | connection/connect | ddv_agent@localhost | ssl | 0 | 
95 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
96 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
97 | general/status | ddv_agent@localhost | Query/create_view | 1142 | CREATE VIEW ddv_support.v_leak AS SELECT * FROM ddv_support.customers
98 | connection/disconnect | ddv_agent@localhost | ssl |  | 
````

### evidence/63-after.txt
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
3 rows in set (0.009 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.075 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.027 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.003 sec)

Bye
````

### evidence/63-audit-remove.txt
````text
--------------
SELECT audit_log_filter_remove_user('ddv_agent@%')
--------------

+---------------------------------------------+
| audit_log_filter_remove_user('ddv_agent@%') |
+---------------------------------------------+
| OK                                          |
+---------------------------------------------+
1 row in set (0.046 sec)

--------------
SELECT audit_log_filter_remove_filter('agent_log')
--------------

+---------------------------------------------+
| audit_log_filter_remove_filter('agent_log') |
+---------------------------------------------+
| OK                                          |
+---------------------------------------------+
1 row in set (0.046 sec)

--------------
SELECT * FROM mysql.audit_log_filter
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM mysql.audit_log_user
--------------

Empty set (0.002 sec)

--------------
SHOW STATUS LIKE 'audit_log.events%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.events               | 528   |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 98    |
+--------------------------------+-------+
6 rows in set (0.008 sec)

--------------
SELECT ID, USER, HOST, DB, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+------+---------+
| ID  | USER            | HOST            | DB   | COMMAND |
+-----+-----------------+-----------------+------+---------+
| 156 | root            | localhost:54667 | NULL | Query   |
|   7 | event_scheduler | localhost       | NULL | Daemon  |
+-----+-----------------+-----------------+------+---------+
2 rows in set, 1 warning (0.006 sec)

Warning (Code 1287): 'INFORMATION_SCHEMA.PROCESSLIST' is deprecated and will be removed in a future release. Please use performance_schema.processlist instead
Bye
````

### evidence/63-audit-uninstall.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
-- Audit Log Uninstallation script
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
-- 1. Drops the functions.
--------------

Query OK, 0 rows affected (0.000 sec)

--------------
-- 2. Drops the tables.
--------------

Query OK, 0 rows affected (0.000 sec)

--------------
-- 3. Uninstalls the component.
--------------

Query OK, 0 rows affected (0.002 sec)

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

Query OK, 0 rows affected (0.536 sec)

--------------
-- Drop the tables.
--------------

Query OK, 0 rows affected (0.018 sec)

--------------
DROP TABLE IF EXISTS audit_log_user
--------------

Query OK, 0 rows affected (0.210 sec)

--------------
DROP TABLE IF EXISTS audit_log_filter
--------------

Query OK, 0 rows affected (0.216 sec)

Bye
````

### evidence/63-compare.txt
````text
Compare-Object evidence\60-baseline.txt evidence\63-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).
(no differences)
````

## Not captured

- The raw `audit_log_read` JSON: it held a local path, the machine name and the OS user name, so only an extract (event class, account, command class, status, statement text) is saved.
- Timestamps, event ids, IP, OS user and connection attributes of the log events (omitted from the extract).
- Contents of the audit log file in the Data folder: access was denied, so file names and sizes were "not checked"; the file is presumably left behind after uninstall (not verified).
- Any statement containing a password while the component was loaded (deliberately none run).
- mysql client exit codes: all runs returned 0 because of `--force`, including the runs that printed ERROR lines.
- Why the first `audit_log_read` returned 89 of 98 events (its output was 32634 bytes against `audit_log.read_buffer_size` 32768; reasoning, not tested).

## Observations (Claude Code's reading, not evidence)

- The install against schema `mysql` succeeded: component_id 6 for `file://component_audit_log`, tables `audit_log_filter` and `audit_log_user` in `mysql`, no ERROR lines. In Step 5 the same script against `ddv_sec` failed with ERROR 3536. This supports, but does not prove, that the earlier failure came from the schema choice.
- The three warnings are code 1287, "BINARY as attribute of a type is deprecated"; they answer the uncaptured warnings noted in Step 5.
- Both filter functions returned OK. `audit_log.filter_id` was 1 for ddv_agent and 0 for root and ddv_billing.
- Only ddv_agent sessions are in the log (97 events) plus one server startup event under root. Root and billing sessions ran while the filter was active and were not logged.
- Denied statements are logged: ALTER (1142), DROP MASKING POLICY (1227), CREATE TABLE ... AS SELECT (1142) and CREATE VIEW (1142) appear as general/status events with those error codes; there is no table_access event for them.
- Selects appear twice (a table_access read event and a general/status event) and carry statement text with literals, such as the customer name and the LIKE pattern. Query results, such as the ticket 3 note, are not in the log.
- Each mysql client run also logged `select @@version_comment limit 1` and `select $$` (status 1064); the source is the client (reasoning). The Python driver logged Ping events.
- `audit_log.events_written` was 98 after the read, equal to the 98 events read.
- After removal and uninstall the snapshot equals the baseline (63-compare.txt).
