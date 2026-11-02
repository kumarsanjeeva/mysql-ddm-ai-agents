# FINDINGS: handoff for the blog session

This file lists what was captured, what was only observed, and what was not tested.
Evidence file names are in `evidence/`.

## 1. Labels used

- **captured test**: a command was run and its output saved in a repo evidence file.
- **live observation**: the author saw it in a live session; not in repo evidence.
- **manual-documented**: taken from the MySQL manual; not tested here.
- **reasoning**: an inference drawn from captured output; not tested.
- **not tested**: nothing was run.

## 2. Environment

- MySQL Enterprise Edition 9.7.4 (9.7.4-commercial, MySQL Enterprise Server - Commercial), run on a Windows laptop. (captured test, evidence/01-setup-root.txt)
- One line for the post: "Downloaded trial version", from Oracle Software Delivery Cloud. No licensing commentary.
- **Install gotcha** (live observation, not in repo evidence): the server MSI treated 9.7.4 Enterprise as an in-place upgrade of an existing 9.7.2 Community install on the same data directory. The configurator showed "Upgrade 9.7.2 -> 9.7.4" and a red cross on "Starting the server and upgrading system tables", yet the server error log shows the upgrade from 90702 to 90704 started and completed, and the server then ran as 9.7.4 commercial. Existing databases were still listed. Lesson for readers: don't run the Enterprise MSI on a machine holding a Community install you want to keep.
- **Components were not installed by default** (live observation): `mysql.component` was empty until `masking_functions_install.sql` and `install_component_object_policy.sql` were run from the share folder, in the `mysql` schema. After that, `mysql.component` listed `component_masking`, `component_masking_functions` and `component_object_policy`; 24 masking and generator functions existed; the privileges `MANAGE_DATA_MASKING_POLICY` and `MASKING_DICTIONARIES_ADMIN` appeared in `SHOW PRIVILEGES`. (captured in the author's interactive session, not in evidence/)
- `masking_functions_install.sql` creates `masking_dictionaries` with no schema qualifier, so it lands in the current database. The manual runs it against `mysql`. (captured script text, manual-documented)
- `install_component_object_policy.sql` printed "2 warnings" whose text was not captured. (not captured)

## 3. Manual-documented syntax

Source pages (fetched 2026-11-01):

- https://dev.mysql.com/doc/refman/9.7/en/gatekeeper-functions.html
- https://dev.mysql.com/doc/refman/9.7/en/create-masking-policy.html
- https://dev.mysql.com/doc/refman/9.7/en/drop-masking-policy.html
- https://dev.mysql.com/doc/refman/9.7/en/data-masking-policy-usage.html
- https://dev.mysql.com/doc/refman/9.7/en/data-masking-component-functions.html
- https://dev.mysql.com/doc/refman/9.7/en/roles.html
- https://dev.mysql.com/doc/refman/26.7/en/gatekeeper-functions.html

Entries:

- `CREATE MASKING POLICY name (param) CASE WHEN <gatekeeper> THEN param ELSE masking_expr(param) END`. One WHEN and one ELSE. Multiple WHEN branches are not documented.
- Gatekeepers: `CURRENT_USER_IN(list)` and `CURRENT_ROLE_IN(list)`. `CURRENT_ROLE_IN` checks active roles. Behaviour for a granted but inactive role is not documented. Roles activate through `SET DEFAULT ROLE`, `activate_all_roles_on_login` (off by default) or `SET ROLE`.
- Creating and dropping a policy needs `MANAGE_DATA_MASKING_POLICY`. `ALTER MASKING POLICY` and the privilege needed to attach a policy to a column are not documented.
- Attach with `ALTER TABLE ... MODIFY COLUMN ... MASKING POLICY name`.
- Documented functions used: `mask_inner(str, m1, m2 [, c])`, `mask_outer(str, m1, m2 [, c])`.
- Reported by Claude Code, not independently compared: the 9.7 and 26.7 gatekeeper pages have identical syntax and role behaviour.

## 4. Findings

All are captured tests unless stated.

- **F1.** `ddv_agent` sees masked values; `ddv_admin` (user-list gatekeeper, Step 1) sees real values; root also sees masked values because it isn't in the list. (02-select-agent.txt, 02-select-admin.txt, 02-select-root.txt)
- **F2.** `WHERE phone='555-0101'` and `WHERE email LIKE 'alice%'` returned empty sets for the agent, so filters run on the masked value. Two queries only. (03-probe-agent.txt)
- **F3.** `SHOW CREATE TABLE` shows the `MASKING POLICY` clauses to the agent, so policy names and masked columns are visible to it. (03-probe-agent.txt)
- **F4.** Role-gated policies, `ddv_support` schema (4 tables, 6 customers, 10 orders, 10 payments, 5 tickets, all fake). `ddv_agent` (role `r_support_agent` active) sees masked phone, email, tax id, card and UPI; names, order status, totals and dates are readable. (15-verify-agent.txt)
- **F5.** `ddv_norole` (`CURRENT_ROLE()` NONE) sees the same masked output, with no error. (15-verify-norole.txt)
- **F6.** `ddv_billing` with `r_billing_admin` active sees everything unmasked, including full card numbers. After `SET ROLE NONE` the customers select returned masked values. Only customers was re-queried after the switch. (16-verify-billing-set-role-none.txt)
- **F7.** Grants: `ddv_agent` finally holds SELECT on the four `ddv_support` tables plus role `r_support_agent`; the earlier `ddv_mask` grant was revoked, and `SHOW GRANTS` was captured before and after. Both roles hold only USAGE. (10-agent-grants-before.txt, 11-agent-revoke-ddv-mask.txt, 18-show-grants.txt)
- **F8.** Free text bypasses column masking. Ticket 3's note holds a full test card number and an email, visible to agent, norole and billing, while the same card is masked in payments. (15-verify-agent.txt, 15-verify-norole.txt, 16-verify-billing-set-role-none.txt)
- **F9.** Of four scripted questions, only question 3's context contained an unmasked email and a 13 to 19 digit run, both from ticket 3's note (line 39 of the context file). The scan checks three patterns only. (21-llm-context.txt, 22-context-scan.txt)
- **F10.** `verify_last4` returned `matches=1` for Asha with 0101. It works because the mask keeps the last four digits. (21-agent-run.txt; the "because" part is reasoning)
- **F11.** Tampering as `ddv_agent`: `ALTER TABLE ... MODIFY COLUMN` denied (1142), `DROP MASKING POLICY` denied (1227, needs `MANAGE_DATA_MASKING_POLICY`), `CREATE TABLE AS SELECT` denied (1142), `CREATE VIEW` denied (1142). `information_schema` afterwards showed only the four base tables. (24-tampering.txt and the author's check; the `information_schema` check is not in repo evidence)
- **F12.** `SHOW CREATE TABLE`, policies and grants are unchanged before versus after the unexpected-query run. (23-before.txt, 25-after.txt)

## 5. Limits and cautions

- The email mask `mask_outer(email, 2, 2, '#')` (Step 1) and the Step 2 mask both leak shape. In Step 2 the output shows the first letter, the length of the local part and the whole domain. All six fake local parts follow firstname.lastname, so length plus first letter narrows a guess. (captured output; the inference is reasoning)
- The phone and card masks keep the last four digits, a real disclosure.
- Tampering was stopped by ordinary privileges, not by masking. That is the point that database controls, privileges and masking are separate layers.
- Roles carry no privileges here: SELECT is granted to each user directly, so roles act only as gatekeeper tokens. Least privilege through roles is not demonstrated.
- "Fails closed" holds for this policy design, where the mask is the ELSE branch. A policy written the other way round is not tested.
- Only two inference attempts and four tampering statements were run. Aggregates, joins, subqueries, stored routines and `INSERT ... SELECT` are not tested.
- The root gatekeeper result says nothing about root's power. Root created and dropped policies earlier.
- The agent is scripted, with no LLM. Question 3 rests on ticket text, and no payment in the seed is "failed".
- Seed note: ticket 3 originally quoted another customer's card; fixed in `sql/20-fix-ticket-card.sql` (evidence/20-fix-ticket-card.txt).

## 6. Process notes (for a "what went wrong" box)

- `--tee` writes nothing when SQL is piped in batch mode, so evidence is captured by redirecting the client's output instead.
- The CREATE USER sessions ran from a generated gitignored file so passwords stay out of evidence. Not captured.
- An earlier manual run of Step 1 by the author is kept privately and is not used.
- `evidence/24-tampering.txt` was cleaned: empty exit-code lines were removed and a first run with PowerShell wrapper text was discarded. The ERROR lines are intact.
- The Python driver was installed by Claude Code, at the author's request. Session history: Claude Code reported that no MySQL driver was installed and asked which to install (`mysql-connector-python` or `pymysql`); the author replied "install mysql-connector-python". `pip show mysql-connector-python` reported Name: mysql-connector-python, Version: 26.10.0, Author: Oracle and/or its affiliates, License: GNU GPLv2 (with FOSS License Exception). The install output was "Using cached mysql_connector_python-26.10.0-cp313-cp313-win_amd64.whl"; it did not name the package index, so the index is not recorded. (live observation, not in repo evidence)

## 7. Not tested

- MySQL Enterprise Audit.
- MySQL Enterprise Firewall.
- Encryption.
- MySQL REST Service.
- A real LLM run.
- Whether `ALTER TABLE ... MODIFY COLUMN` without a `MASKING POLICY` clause strips masking for a user who holds ALTER.

## 8. UNREVIEWED

From Claude Code's reading; not yet checked by the author's planning assistant. Quoted verbatim from evidence/24-unexpected-queries.txt, with that file's line numbers.

### Shape probes (lines 89-135)
````text
89: --------------
90: SELECT id, LENGTH(email), LEFT(email,1) FROM ddv_support.customers
91: --------------
92: 
93: +----+---------------+---------------+
94: | id | LENGTH(email) | LEFT(email,1) |
95: +----+---------------+---------------+
96: |  1 |            25 | a             |
97: |  2 |            25 | b             |
98: |  3 |            22 | c             |
99: |  4 |            29 | d             |
100: |  5 |            27 | e             |
101: |  6 |            23 | f             |
102: +----+---------------+---------------+
103: 6 rows in set (0.015 sec)
104: 
105: --------------
106: SELECT phone, COUNT(*) FROM ddv_support.customers GROUP BY phone
107: --------------
108: 
109: +----------+----------+
110: | phone    | COUNT(*) |
111: +----------+----------+
112: | ****0101 |        1 |
113: | ****0102 |        1 |
114: | ****0103 |        1 |
115: | ****0104 |        1 |
116: | ****0105 |        1 |
117: | ****0106 |        1 |
118: +----------+----------+
119: 6 rows in set, 1 warning (0.041 sec)
120: 
121: --------------
122: SELECT id FROM ddv_support.customers ORDER BY email
123: --------------
124: 
125: +----+
126: | id |
127: +----+
128: |  1 |
129: |  2 |
130: |  3 |
131: |  4 |
132: |  5 |
133: |  6 |
134: +----+
135: 6 rows in set (0.013 sec)
````

### SET ROLE ALL and later statements (lines 148-164)
````text
148: --------------
149: SET ROLE ALL
150: --------------
151: 
152: Query OK, 0 rows affected (0.004 sec)
153: 
154: --------------
155: SELECT * FROM mysql.column_masking_policies
156: --------------
157: 
158: ERROR 1142 (42000) at line 16: SELECT command denied to user 'ddv_agent'@'localhost' for table 'column_masking_policies'
159: --------------
160: SELECT * FROM ddv_mask.customers
161: --------------
162: 
163: ERROR 1142 (42000) at line 17: SELECT command denied to user 'ddv_agent'@'localhost' for table 'customers'
164: Bye
````

### mysql.column_masking_policies, fresh query as root (2026-11-03, not saved as a separate evidence file)
````text
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
7 rows in set (0.004 sec)

Bye
````

## 9. Wording for the blog

Safe:

- "masked for this user in these queries"
- "in this demo"
- "with this policy design"
- "tested on MySQL Enterprise 9.7.4"

Avoid:

- "secure"
- "prevents leaks"
- "cannot be bypassed"
- "fails closed" without the policy-design condition
- "protects emails" for the demo mask
- any claim about Audit or Firewall

## 10. Evidence index

SHA-256 of every file in sql/, agent/, docs/ and evidence/, except this file. Step = the commit that first added it; Step 3 = added in the Step 3 commit.

| File | Step | SHA-256 |
|---|---|---|
| agent/scan_context.py | Step 3 | 7b8b23ade79c1eb8362115111d3a1d6ce92544729e40e4a417ee9e23025f4b39 |
| agent/support_agent.py | Step 3 | 9983eeae3822c83a6eea097d7cf8404c9e8b5abd30fe67e38af757fa181c47f1 |
| docs/agent-walkthrough.md | Step 3 | 42ceeb6f3edfb50f291b98ac1876ec7afe75ced5e3688de8bf7c43a95fd2d661 |
| evidence/01-setup-root.txt | Step 1 | b7add630ecd0aaa7cc10e168f60613f6af2b9c7029c72c49fb4192bd8083f0f8 |
| evidence/02-select-admin.txt | Step 1 | f2614e3b5287daec2b38ba8816afe32f3f7760f5c57365e98709321b15ea1ec9 |
| evidence/02-select-agent.txt | Step 1 | 60a760162b929ab6ea85bbf5f46b7661c9e6eabf413d86c0c24e696f2e65b995 |
| evidence/02-select-root.txt | Step 1 | 1d691def000b4762dbf2811e56b23a2458982c50f5d624facbbc6fb119533289 |
| evidence/03-probe-agent.txt | Step 1 | 1a9d2c4b828a05d725dd8f1ae18e1fa41dd72a98e3ccff1e4b9a48ccf42d5edb |
| evidence/04-policies-root.txt | Step 1 | 80fc1587ebdec0c213ddd310096a936067a66f9e93f99de974c3c5a01db720dc |
| evidence/10-agent-grants-before.txt | Step 2 | 19f36189a09bfcad86f3ee3ab11f1a9f6e1d76cf6c7e01aa85b2c8993fd3e530 |
| evidence/11-agent-revoke-ddv-mask.txt | Step 2 | 61dc52b350f957e56a1e19e168ffe9e96018fd074a922978c09fdf3191e61ae9 |
| evidence/12-support-schema.txt | Step 2 | 41e6b2bf6cb70d76996ca8fd0d913ea615609ff82bc77670f7bd96cc257e54ae |
| evidence/13-support-policies.txt | Step 2 | 9117342b6fbce8a409ba68754b6fc933776c9e1d97444b0f7b6386156d63fa3c |
| evidence/14-roles-grants.txt | Step 2 | 079b94f8bd924a13c69379b8d1710d6dcea70cfab6ca0231a03b7cc3fafdbca0 |
| evidence/15-verify-agent.txt | Step 2 | 712c1fbee5b2d717ffa17ba6cce18e0581b4a2fb90a4d705e4e4af2d1029bf6a |
| evidence/15-verify-norole.txt | Step 2 | df3e074d005a74d20c08124da444252b5fc3440f0cd2faffc802bf5763da040d |
| evidence/16-verify-billing-set-role-none.txt | Step 2 | aac83efff3d4e67e233bbb933181bae00f430a74f807c69fc8d21bcfee05d543 |
| evidence/17-policies-root.txt | Step 2 | da39e3f23783881514792936cb5077b933e9f27a9803dc1cf119b76182b110ad |
| evidence/18-show-grants.txt | Step 2 | 7b29dac6971ddf2d337692e715e21fd0dcf9b6589c954799b3219b27126846e4 |
| evidence/19-show-create-agent.txt | Step 2 | 8435f87bd25ee31c5edc462749363d217f04f4cd9990e48f1ed9f604d1ccd794 |
| evidence/20-fix-ticket-card.txt | Step 3 | c9e5ad7f0e0fd48357ff931851af43e0eea58c1c3f904e04ee28cb3b4e14b2ea |
| evidence/21-agent-run.txt | Step 3 | bff4c95ae6660c9ee9d0ef4262bd0b5e70c3cf90b9848d5b374ab9b21c242c67 |
| evidence/21-llm-context.txt | Step 3 | faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671 |
| evidence/22-context-scan.txt | Step 3 | bcd323f8e79a218c399a13186005ef65af2c11bdb8b46a6b24692435420b6911 |
| evidence/23-before.txt | Step 3 | 68207468560d4014696a7d06ef5f1a26725caf742a085775378053518c592ed2 |
| evidence/24-tampering.txt | Step 3 | 64fca2520bd608a4cd2d064aee575779db870b658a5dd3d5dcfb00b98c824616 |
| evidence/24-unexpected-queries.txt | Step 3 | 66452c7e77773f279a55b753c8cdc965857561fe3fee0423169b9104babe27df |
| evidence/25-after.txt | Step 3 | 644c04921d69d06a8c7fcc8b5140d33bb954a525746f80292c72baee37340e09 |
| evidence/REPORT-01.md | Step 1 | 780f4baa3e605c90f852e46fa66d5d9aec8ab2e6414146481a0e7895192b5b1b |
| evidence/REPORT-02.md | Step 2 | aad9e793a459d055a9de77883caa008b88409d095fe4cd0a2f835539320b14d0 |
| evidence/REPORT-03.md | Step 3 | 2144262edd1d315d24820bb9e36b85232fd9ae4b6a1908a25c616d8b8ead269c |
| sql/00-create-users.template.sql | Step 2 | 7c593fc87a419e353f7d8775003e9c191cb273a60bf0a527bef3193ee058300a |
| sql/01-feasibility.sql | Step 1 | 2c8f56b6021fae023b5ef4cc550a67c18e7493ff2a568440d36301bafdc07451 |
| sql/02-select.sql | Step 1 | 1178e078947185c05dc048f7304ad953402c3996295bf6c078b3a08daeaa2e24 |
| sql/03-probe-agent.sql | Step 1 | 78bc77a44ebd262c7a6b56c1124b94c4be45f0045d0e366ee2b4d54e9a2821b5 |
| sql/04-policies.sql | Step 1 | 67310845ac516ebc33fca0117767f8af9a428b7e85456ae92f84280008fb3c3f |
| sql/10-agent-grants-before.sql | Step 2 | 4d5643e8304797401484b2cfb4e8db090f1cdb7033a461a8fc7bfabad88e3509 |
| sql/11-agent-revoke-ddv-mask.sql | Step 2 | f4f0858b9e4beb52b3f8972a87223ba6dc7828261873a2d27dfd96885070e134 |
| sql/12-support-schema.sql | Step 2 | 33de3c374de7db00233b72ef8ead0867a1296b3a7c90354e8ba12188d1ca47e2 |
| sql/13-support-policies.sql | Step 2 | e44ed37b5fbfe621662deba1d95336fc5ac7030d2945e12288c49a761f587a86 |
| sql/14-roles-grants.sql | Step 2 | 6be1703041ae04b0d5db563641efd6ad74fff66736063db24f6c204f797c249e |
| sql/15-verify-user.sql | Step 2 | 3b307074cbc2844a1380ccd3a744e437e8799b9aee8d608c66779901b86929b8 |
| sql/16-verify-billing-set-role-none.sql | Step 2 | bf61c262086054fee3c4f55dab597ecbd4511caf359528634ea400220fa00894 |
| sql/17-policies-root.sql | Step 2 | 68fb0d47dca281700dedc45187e0e8fd18dcf2a8931e70ddaa531666c7878ef0 |
| sql/18-show-grants.sql | Step 2 | a61c2c318e5ba5febcc41703bbeb3c23ed71f6ac4bd89a79b4e0f5591679257c |
| sql/19-show-create-agent.sql | Step 2 | 493fa9531d5a287e2083bd2939b9b43208869f54587758ff7ad47b154d8545bf |
| sql/20-fix-ticket-card.sql | Step 3 | 489731801b1da672280f9371f5c9cb5ab69ec26d8dc200aee9c21cd0ab5fe57a |
| sql/23-snapshot.sql | Step 3 | 107750fe9546a320126e00442091a88e2ad3450e767dedab45c35bb3ea659c12 |
| sql/24-unexpected-queries.sql | Step 3 | 3d6adb951ed7704952b531fc30639efd4e2136516bdfd77cf6cb092f38802be7 |
