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
- Joins, stored routines, `INSERT ... SELECT` and views were tested later: see F21 to F42.
- The root gatekeeper result says nothing about root's power. Root created and dropped policies earlier.
- The agent is scripted, with no LLM. Question 3 rests on ticket text, and no payment in the seed is "failed".
- Seed note: ticket 3 originally quoted another customer's card; fixed in `sql/20-fix-ticket-card.sql` (evidence/20-fix-ticket-card.txt).
- The shape probes (`LENGTH`, `LEFT`) and `ORDER BY` can't discriminate between masked and real values on this data. Step 4 repeats them on purpose-built data. (reasoning)
- The agent tools select columns they don't need, so masked placeholders enter the model context. (reasoning)
- Free-text notes need a column-level grant or an application-side redaction step. (reasoning, untested)

## 6. Process notes (for a "what went wrong" box)

- `--tee` writes nothing when SQL is piped in batch mode, so evidence is captured by redirecting the client's output instead.
- The CREATE USER sessions ran from a generated gitignored file so passwords stay out of evidence. Not captured.
- An earlier manual run of Step 1 by the author is kept privately and is not used.
- `evidence/24-tampering.txt` was cleaned: empty exit-code lines were removed and a first run with PowerShell wrapper text was discarded. The ERROR lines are intact.
- (a) Driver: mysql-connector-python 26.10.0, GPLv2 with FOSS exception, installed by Claude Code at the author's request. Exchange: Claude Code reported that no MySQL driver was installed and asked "Which should I install? `mysql-connector-python` (Oracle's driver) or `pymysql` (pure Python)"; the author replied "install mysql-connector-python". `pip show` reported Version: 26.10.0, Author: Oracle and/or its affiliates, License: GNU GPLv2 (with FOSS License Exception). The install output said "Using cached mysql_connector_python-26.10.0-cp313-cp313-win_amd64.whl" and did not name the package index. (live observation, not in repo evidence)
- (b) evidence/22-context-scan.txt was saved through PowerShell redirection and begins with a UTF-8 BOM. agent/scan_context.py reproduces it apart from the BOM and line endings.
- (c) The Step 1 and 2 files were first committed with CRLF converted to LF because core.autocrlf=true and .gitattributes did not exist yet. Commit 3054d77 re-stored them as captured. A fresh clone verifies all three reports (10, 33 and 47 hashes, 0 mismatches).
- (d) FIREWALL_ADMIN was granted to root@localhost for the Firewall test and revoked afterwards. (F46; 53-firewall-uninstall.txt)
- (e) The Audit install script was run against `ddv_sec`, while the manual's example uses `-D mysql`, so the Audit failure (F54 to F56) may come from that choice.
- (f) CREATE TABLE printed warnings during the Audit attempt (1 and 2) that were not captured. (not captured; the Step 6 install against `mysql` printed the same warnings, code 1287, see F58)
- (g) The Firewall install script's `CREATE TABLE IF NOT EXISTS firewall_group_allowlist` also printed "2 warnings" whose text was not captured. (53-firewall-install.txt)

## 7. Not tested

- MySQL Enterprise Audit: the Step 5 install into `ddv_sec` failed (F54 to F57); the Step 6 install into `mysql` worked (F58 to F65). Still not tested: statements containing passwords, log rotation, pruning, encryption, compression, other filter definitions, other accounts' filters, the audit log file itself.
- Encryption.
- MySQL REST Service.
- A real LLM run (the agent is scripted).
- Whether `ALTER TABLE ... MODIFY COLUMN` without a `MASKING POLICY` clause strips masking for an account holding ALTER.
- Enumeration of customers through an allowed Firewall shape.
- Firewall DETECTING mode.
- Other clients' session statements under the Firewall.
- Aggregates and subqueries beyond F21 to F26.

## 8. Review of unexpected-query evidence

All are captured tests. Source: evidence/24-unexpected-queries.txt unless stated.

- **F13.** (captured) `SELECT *` on customers and payments as `ddv_agent` returned masked values only. (24-unexpected-queries.txt)
- **F14.** (captured) `tax_id='TEST-0001'` and `email='asha.example@example.test'` returned empty sets, so filters ran on the masked value. With Step 1's two probes that is four attempts. (24-unexpected-queries.txt, 03-probe-agent.txt)
- **F15.** (captured, weak) `phone LIKE '%0101'` and `email LIKE 'a%'` returned one row each. Both patterns match what the mask shows, so they say nothing about which value was evaluated. (24-unexpected-queries.txt)
- **F16.** (captured, non-diagnostic) `LENGTH(email)` and `LEFT(email,1)` returned values equal to what the masked display shows. Whether they ran on masked or real values can't be told from this data. (24-unexpected-queries.txt)
- **F17.** (captured) `GROUP BY phone` returned six groups of one, with 1 warning. A re-run with `SHOW WARNINGS` returned: `Warning | 1052 | Column 'phone' in group statement is ambiguous`. The re-run is not the original capture. (24-unexpected-queries.txt; 26-group-by-warning.txt, re-run)
- **F18.** (captured, non-diagnostic) `ORDER BY email` returned ids 1 to 6. The seed is alphabetical by id, so masked and real order coincide. (24-unexpected-queries.txt)
- **F19.** (captured) `SET ROLE r_billing_admin` gave ERROR 3530 (not granted). `SET ROLE ALL` succeeded. Then `mysql.column_masking_policies` and `ddv_mask.customers` were denied with ERROR 1142. (24-unexpected-queries.txt)
- **F20.** (captured) After tampering, 7 policies remain: mask_email, mask_phone, sup_mask_card, sup_mask_email, sup_mask_phone, sup_mask_tax_id, sup_mask_upi. (25-after.txt)
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
- any claim about Audit, and any Firewall claim beyond F45 to F53

Safe wording for Audit and Firewall:

- "for this account and this workflow"
- "in these runs"

## 10. Evidence index

SHA-256 of every file in sql/, agent/, docs/ and evidence/, except this file. Step = the commit that first added it; Step 3 = added in the Step 3 work.

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
| evidence/26-group-by-warning.txt | Step 3 (re-run of the GROUP BY probe, not the original capture) | ecef18726e4a1a7c03143e59504eeb3b42f3ad6cab29bf161680bfa2ce6b3679 |
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

## 11. Step 4 and 4b findings (F21 onward)

Added after the earlier sections; earlier entries are unchanged. All are captured unless stated. Step 4 files are 30-38, Step 4b files are 40-48.

- **F21.** (captured) ORDER BY email returned ids 3,1,2 for the agent and 3,2,1 for billing. (32-probes-agent.txt, 32-probes-billing.txt)
- **F22.** (captured) GROUP BY phone gave 2 groups for the agent and 3 for billing; COUNT(DISTINCT phone) 2 against 3. (32-probes-agent.txt, 32-probes-billing.txt)
- **F23.** (captured) The self-join on phone gave 5 rows for the agent, including the pairs (1,2) and (2,1), and 3 rows for billing. (32-probes-agent.txt, 32-probes-billing.txt)
- **F24.** (captured) MIN/MAX(email) and LEFT(email,6) returned masked text for the agent. (32-probes-agent.txt)
- **F25.** (captured) WHERE phone='777-0101' and email LIKE 'mark.a%' returned nothing for the agent and id 2 for billing. (32-probes-agent.txt, 32-probes-billing.txt)
- **F26.** (captured) Warning 1052 Column 'phone' in group statement is ambiguous appears for both agent and billing on the GROUP BY probe. The cause is undetermined (reasoning: the policy expression). (32-probes-agent.txt, 32-probes-billing.txt)
- **F27.** (captured) A DEFINER view and procedure with definer root (no role) returned masked rows to both agent and billing. The INVOKER view gave billing real values and the agent error 1356. The agent read notes through the definer view and the procedure without base-table SELECT. (33-views-routines-agent.txt, 33-views-routines-billing.txt)
- **F28.** (captured) The agent's INSERT ... SELECT into an unmasked table stored masked values. Billing had no grant on that sink. (34-copy-out.txt)
- **F29.** (captured) With SELECT (id, email, phone), SELECT notes gave 1143 and SELECT * gave 1142. (35-column-grant.txt)
- **F30.** (captured) Audit and Firewall are not installed. DLLs and install scripts exist. Before Step 4b only the plugin-style scripts had been read. (36-audit-firewall-check.txt, 36-share-plugin-listing.txt)
- **F31.** (captured) ddv_owner (holding role r_billing_admin as default role, SELECT on the table) selecting probe_people in ddv_probe2 returned real email, phone and notes. (41-owner-select.txt, 41-setup-root.txt)
- **F32.** (captured) The agent's first CALL p_owner() failed with ERROR 1370 (execute command denied to user 'ddv_owner'@'%' for routine 'ddv_probe2.p_owner'). The EXECUTE grant to ddv_owner was added afterwards and the whole agent file was re-run. Both captures are kept. (41-agent-select.txt, 41-owner-execute-grant.txt, 41-agent-select-rerun.txt)
- **F33.** (captured) With definer ddv_owner, v_owner_definer returned real email, phone and notes to the agent, who held only SELECT (id, email, phone) on the base table and SELECT on the view. After the EXECUTE grant, CALL p_owner() also returned real values. (41-agent-select.txt, 41-agent-select-rerun.txt)
- **F34.** (captured) As the agent, SELECT notes FROM probe_people gave ERROR 1143 and SELECT notes FROM v_owner_definer returned the three notes, in both captures. (41-agent-select.txt, 41-agent-select-rerun.txt)
- **F35.** (captured) Copy-out chain in ddv_probe2: the agent's INSERT ... SELECT stored masked values in probe_sink; billing then read the masked values, deleted the 3 rows and inserted from the base table; the agent's next SELECT * FROM probe_sink returned real values. (42-copy-out-1-agent-insert.txt to 42-copy-out-5-agent-select.txt)
- **F36.** (captured) ALTER TABLE probe_idx MODIFY COLUMN code ... MASKING POLICY probe_mask_phone on an indexed column gave ERROR 6572 Column 'code' cannot have a MASKING POLICY and have an index. CREATE INDEX idx_phone ON probe_people (phone) on a masked column gave ERROR 6572 Column 'phone' cannot have a MASKING POLICY and have an index. (43-indexed-columns.txt)
- **F37.** (captured script text) The audit component install script creates tables audit_log_filter and audit_log_user and runs INSTALL COMPONENT "file://component_audit_log"; its uninstall script uninstalls the component and drops both tables. The first 80 lines of the firewall component script create firewall_group_allowlist, firewall_groups and firewall_membership, run INSTALL COMPONENT 'file://component_firewall' SET PERSIST component_firewall.database = DATABASE() and start creating stored procedures. Nothing was run. (45-component-scripts.txt)
- **F38.** (captured) After cleanup, ddv_probe2, its policies and ddv_owner are gone; the before and after snapshots compare equal after stripping timings. (46-cleanup.txt, 47-after.txt, 48-compare.txt)

Limits added: three rows and each result seen once. Masking changes sorting, grouping, distinct counts and joins (reasoning, for what that means to an agent). A column grant on the base table does not cover views (reasoning).

## 12. Evidence index additions (Step 4 and Step 4b)

Files in sql/, agent/ and evidence/ not listed in section 10. Step 4 = commit 3875686; Step 4b = the Step 4b commit. Section 10 is unchanged.

| File | Step | SHA-256 |
|---|---|---|
| evidence/30-before.txt | Step 4 | 39cdf2fae5ff07cfd318e8bcae7beb9b0167f3560290362d704895b60b1a396c |
| evidence/31-probe-setup.txt | Step 4 | e53b6ac05ae0b6a56b11b460d33d7032ec704b4950822a956d24a14a8cf40b58 |
| evidence/32-probes-agent.txt | Step 4 | ab4c7e02faebe5a4534e889fccf5ee128d8231c1eb9b0c91a1b253fa0adc758c |
| evidence/32-probes-billing.txt | Step 4 | 00097ae3ab8d377cc6ef518d9b74993dbfe7cbb573d6bef1455a27b5cf13a163 |
| evidence/33-regrant-root.txt | Step 4 | 2d794efb62f5a30e1629722f83a5e679de6c4d8f8593b2b29d459fee1dbbb1cd |
| evidence/33-views-routines-agent.txt | Step 4 | aaa6c1e2d76c46bedccf707f49dddbc34a3aa2373dc71fd66206ce790294570d |
| evidence/33-views-routines-billing.txt | Step 4 | f6372009aab57d5f50780622f3d44cae7f66658a105525d5f1d426aaa35e2a42 |
| evidence/33-views-setup-root.txt | Step 4 | 2628ddaeabbbc26885c23aa514b3167cbd979c1bd735247a8034039d487cd34f |
| evidence/34-copy-out.txt | Step 4 | f63e0d28a16e0b7ce393eb9cdba34f34b4741a3bbce2933c76c1ab54648c3530 |
| evidence/35-column-grant.txt | Step 4 | f2011f0e2760552498137dc0990021f2f944764691133a5daeefdaf246f6a24d |
| evidence/36-audit-firewall-check.txt | Step 4 | cf36bfb2a81575c2a6cc7042159225c2ea6ad6f4e35340a2b61d5380686f4689 |
| evidence/36-share-plugin-listing.txt | Step 4 | 1680f1626311a5c308d44253761c4f3d70718bccecb141a74bc3b94c12ba2921 |
| evidence/37-cleanup.txt | Step 4 | 40228a9820c598d1c99de171b5f0e777c04c23009344f7a5222c84a98eec25e4 |
| evidence/38-after.txt | Step 4 | f73704d7a77d5b71b39fb2454dc92cf8527f01ae9f5f3c11aa7a90c782766839 |
| evidence/40-before.txt | Step 4b | d28fa19560f278513c0c585946cb8721ef1c069383490a6baa56e69c81babd4f |
| evidence/41-agent-select.txt | Step 4b | 51ae20186405a0dd370198731117964db038e19e9130e992ed73410ab7f0b0a2 |
| evidence/41-agent-select-rerun.txt | Step 4b | c9f0146b5ca1937db2f07c3c9524e80de037e1096ec16e0f069fd890ceed55c4 |
| evidence/41-owner-execute-grant.txt | Step 4b | 8a5057d62f6c40165a3ae1eccee6c1677bc4dfc736bcbeae5812691b9721236a |
| evidence/41-owner-select.txt | Step 4b | afa2d53185dac902a617bc274f3ef354e23170028d94b91a8265f35ce2f8beda |
| evidence/41-setup-root.txt | Step 4b | 0d0212a29e32f6dda8fa35957beeafc90ba85e186084d924e8869f09d50b749e |
| evidence/42-copy-out-1-agent-insert.txt | Step 4b | 20fab5f98e794a1246a41e448d8d4fefe98d7a6a7d2caded82c3f180f33fbe72 |
| evidence/42-copy-out-2-billing-select.txt | Step 4b | 5bc8e99c2e790a736b5de91e2dee9b1a98b886270ab231ed81e2060503e9ce39 |
| evidence/42-copy-out-3-billing-delete.txt | Step 4b | e5448f4d29f908dc841d133600041727ee936512b35938b19babff30d34edaaa |
| evidence/42-copy-out-4-billing-insert.txt | Step 4b | b026e4dc27d3e50771f7855ebc689ffbf4dcb7d184044f943e6a15f82768dfae |
| evidence/42-copy-out-5-agent-select.txt | Step 4b | e5af5a4cdc09c3e76f844946f10b9cd2a8f75e0aad2c55edff41ab19469401b9 |
| evidence/42-copy-out-setup-root.txt | Step 4b | f74c6a7407e31905c40201a5ed244ff724a29b0a24ff70c6b78e717578713198 |
| evidence/43-indexed-columns.txt | Step 4b | 39ef4525b4872df3a9c32c3af8f93228bbd79890704871cf02ff39246f455cdc |
| evidence/45-component-scripts.txt | Step 4b | 95cf356446347452f9dba1364075785c70feea64b3223d86d66347c4a53f2d96 |
| evidence/46-cleanup.txt | Step 4b | 544dc985305a5f40311b51c3f8ec5c6fbe937ebf79dbf4cd43f2fad11360377b |
| evidence/47-after.txt | Step 4b | 539c24d9781afb35371f14c526936465a201cacd7223c1b2b4db8e3df89c0330 |
| evidence/48-compare.txt | Step 4b | 74856b3644a545970127a7a021a07c160a8934ee818652a60bbc7245cda61f7c |
| evidence/REPORT-04.md | Step 4 | 17791051219975f13e9d322e044cc1ad791c0a9b314c30058eb3a85760083faf |
| evidence/REPORT-05.md | Step 4b | 2aae3565634fa5ce965a80ef26fd368a039370a32435093df87ad548ce522710 |
| sql/30-snapshot.sql | Step 4 | f0276fc5d87f10542bb5a5606a4c291592d84901cc98cac494a29890f8fdb3d9 |
| sql/31-probe-setup.sql | Step 4 | e2717cfc6fa4ac777bc341a1ee27f38f9d7ea077340d7e855fbfe297ba60012f |
| sql/32-probes.sql | Step 4 | 357828a70dc99ccbb6cc58a741ba0f672c28436e74a6fc076dd0abb9936a3cdc |
| sql/33-regrant.sql | Step 4 | cce2baf7f1df55716f71eebb4c5030a42f793e5544b00e04307fc56977811296 |
| sql/33-views-probes.sql | Step 4 | bd2a988f4962983fdf6eef436135e20f0d33e344bab4079c0ab0540c2c3dd696 |
| sql/33-views-setup.sql | Step 4 | 1b56cf3bc4a2c05ebc079cc4d77a4e4badc4f593dacf4f5f412a2fb913cfbf29 |
| sql/34-sink-agent.sql | Step 4 | 6e0c3ac264eea8a8385c1ada24866702ae47c13d87dcdb306ad717a16fbbe124 |
| sql/34-sink-billing.sql | Step 4 | f7b772f01130f293645d731d6a39cfd585be0d51221231a1c07268b4e92acaaa |
| sql/34-sink-setup.sql | Step 4 | d6e5786f218c22507ae44baecdeac2309a2a4d08726c5c22299cc04070b3141d |
| sql/35-column-grant-agent.sql | Step 4 | cbe942e3154f25009e7d235f8b9ff7f55012ef04249788ff37055f97e50d254c |
| sql/35-column-grant-setup.sql | Step 4 | a1f54479401814eda818b4ee44bea4e971a0b9d6b515ea158ae48363bf610e7d |
| sql/36-audit-firewall-check.sql | Step 4 | 091b8d1dfd3b679c49eed4c8fda8219e425bf3c7185779633bc347d0223be481 |
| sql/37-cleanup.sql | Step 4 | a112d6935909d848339b7c9b5a4b0717f0f99c2efef0e697a9f1db96a21b5e28 |
| sql/40-snapshot.sql | Step 4b | 7fde7bdbfeba8205cdb5c177d406e5f3448f78209bc39b1f03e8d26c8b7a8be0 |
| sql/41-agent-select.sql | Step 4b | 40e923f695052a3988b451fdf1015995258ef7ce44ebea5a7c3723ab7a98b4ea |
| sql/41-create-owner.template.sql | Step 4b | e1e30b1f5172a3c5251e1f68a807b77a68b3ad8494e81b1aa7787e17e45c4763 |
| sql/41-owner-execute-grant.sql | Step 4b | dd3878a819ee84b33fba62c8176f92a39fa3de1be01993b920dc17daae4be31e |
| sql/41-owner-select.sql | Step 4b | 8ee5f38ad5625d63f1f325c5813208381ee9dff411cebed89ee80c8a501e63a1 |
| sql/41-owner-setup.sql | Step 4b | 66d49c4ddb74bb68c27443b554034a070144e90518f00aa4d9104bbf4e089bde |
| sql/42-copy-out-1-agent-insert.sql | Step 4b | 0053923d5e1f44fa8df08b0bea81c514b9a16769fb2f4d9d94b82ad795d5694b |
| sql/42-copy-out-2-billing-select.sql | Step 4b | 24b4c2238512cfb774c66d43e50f1b547c0ba10bd32603bd14e6aef753a223dc |
| sql/42-copy-out-3-billing-delete.sql | Step 4b | 739a9c47efe534c14177e2e69715f92181e676a91e1d4de0728592dda282d981 |
| sql/42-copy-out-4-billing-insert.sql | Step 4b | 71cfb60eda866cccbfd0a20eb00fb4722d03a474c4f52bfa782d1068f6ae50bf |
| sql/42-copy-out-5-agent-select.sql | Step 4b | 24b4c2238512cfb774c66d43e50f1b547c0ba10bd32603bd14e6aef753a223dc |
| sql/42-copy-out-setup.sql | Step 4b | 9e4bd9c86f63965fb43f1e909a09a972bc67983734daf17879fc7910c324c38f |
| sql/43-indexed-columns.sql | Step 4b | ffc7e196ea33384c8135d7b222c1df68f80c9ec46ef712da4c3e82d7fe51ae8e |
| sql/46-cleanup.sql | Step 4b | 8aa78a47407445cddc62eed942c940d7529c4e40ad70d8c153d47fb760194380 |

## 13. Step 4c findings (F39 onward)

Added after earlier sections; earlier entries unchanged. All captured. Files are in evidence/ (52-*).

- **F39.** (captured) State 1: with `ddv_owner2` holding `r_billing_admin` as default role (its `CURRENT_ROLE()` showed it), `SELECT * FROM v_owner2_definer` and `CALL p_owner2()` as `ddv_agent` returned real email, phone and notes. The agent had no privilege on the base table. (52-state1-root.txt, 52-state1-owner.txt, 52-state1-agent.txt)
- **F40.** (captured) State 2: with the role still granted but `SET DEFAULT ROLE NONE`, the owner's `CURRENT_ROLE()` showed NONE and both the view and the procedure returned masked rows to the agent. (52-state2-*.txt)
- **F41.** (captured) State 3: after `REVOKE` of the role, the owner's `CURRENT_ROLE()` showed NONE and both returned masked rows. (52-state3-*.txt)
- **F42.** (captured) State 4: after granting the role again with `SET DEFAULT ROLE ALL`, the owner's `CURRENT_ROLE()` showed the role and both returned real values again, as in state 1. (52-state4-*.txt)
- **F43.** (captured) Setup: policies `probe3_mask_email` and `probe3_mask_phone`, DEFINER view and procedure, and the agent's grants (SELECT on the view, EXECUTE on the procedure, nothing on the base table) are in 52-setup-root.txt.
- **F44.** (captured) Cleanup removed `ddv_probe3`, both policies and `ddv_owner2`; the after snapshot compares equal to the baseline once timings are stripped. (52-cleanup.txt, 52-after.txt, 52-compare.txt)

## 14. Evidence index additions (Step 4c)

Files in sql/, agent/ and evidence/ not listed in earlier index sections. Step = Step 4c.

| File | Step | SHA-256 |
|---|---|---|
| evidence/50-baseline.txt | Step 4c | 2a98853945f57074a45d4138744e31bcdb5489adad6f5025182e95a0946bd575 |
| evidence/51-component-scripts-rest.txt | Step 4c | bf060bd6f3e6938afda81552aecc809911196fe3e5d73c68af6c271fbe26a252 |
| evidence/52-after.txt | Step 4c | caad39c28d2c4e4ea48c07be1562da5e82a353704406930f54150af1eaad18d6 |
| evidence/52-cleanup.txt | Step 4c | 439e4e4edee379ab8f9c6776a5fe65d3658a18e50f93009f639b2d1d0f26fd18 |
| evidence/52-compare.txt | Step 4c | 6dd2fba8f0b1d4c6d9312bb7e8e7c0eb3e836e46102e7a1a4ca9c431b0662024 |
| evidence/52-setup-root.txt | Step 4c | fa1641b71803b1c9e7364ed6947b81ba1754475ec1321621e5224c1ebf9b2b5d |
| evidence/52-state1-agent.txt | Step 4c | 5a082ba90e6c70e852f262d4ca8a5266d06a751c52c08ec37f42ffcb0519c23e |
| evidence/52-state1-owner.txt | Step 4c | 198750f65e58eace9a089bbcc20315004697801e0092a8cae8cac9e3e60084bc |
| evidence/52-state1-root.txt | Step 4c | 11323919ff5f3b8083be60a55463340cce7f18c95b5070432788884eb51d9442 |
| evidence/52-state2-agent.txt | Step 4c | 718bf8431e68dcfe7dcf6d0be2d0db65bfea0c609bf003c996ffbfccc3712222 |
| evidence/52-state2-owner.txt | Step 4c | 5a87bc3e2f5f4ad11a2f76de2ae9b708737957fef0a46b9b06767c6b92d99179 |
| evidence/52-state2-root.txt | Step 4c | f14e3a26e57cf1f365f00eb3fe53f767288aad7efde5c5511c1110cf17177278 |
| evidence/52-state3-agent.txt | Step 4c | c44edae51f832a3eb6a92651137b7edad51068c3cf524fbcc0ebf94c045e828a |
| evidence/52-state3-owner.txt | Step 4c | 9c47d880bdf71814cfa1650db2e9ef588d847eb557e3127deb86887235d4144b |
| evidence/52-state3-root.txt | Step 4c | abc245b318dc253e7c6b137be7a7e78ecbb6649cf879fbcb462b5341ad5533c0 |
| evidence/52-state4-agent.txt | Step 4c | 997ab9d40e6cfbae2b8b02b7ae518fd468008d27e6139adbdd44f00c1937adc7 |
| evidence/52-state4-owner.txt | Step 4c | 764eedc853bfbe33e75d9a9e620d723ee239d7d0718e8ef6159e1bd48efccd67 |
| evidence/52-state4-root.txt | Step 4c | 40655df77aeec5072d51ea71409ef22d010251f0f938f7812d0befd9c483b6f3 |
| evidence/REPORT-06.md | Step 4c | d464f5a4650961047ef33c5cb1b62bf4ef4e28edcc166849cdb5f22830a814ed |
| sql/50-snapshot.sql | Step 4c | 6e00930c9834a54bdd571c826076d5409774ed7365edc701756891ef5e07393e |
| sql/52-agent.sql | Step 4c | fc6bf0fcd7e92be3461a12bafb568a19dad1aa6768f26bc63b3a29e75c7b017f |
| sql/52-cleanup.sql | Step 4c | b0cae2b7a18733aad5119facec54fa8df723e1a2df30a689f0e18d99e25f57a2 |
| sql/52-create-owner2.template.sql | Step 4c | 0db2594d9d9fda8c5536a4f343494ea8a4e68d48ef0db799df586585a1df8438 |
| sql/52-owner.sql | Step 4c | deed806ecd9af9d8a39d7fa1d34dc4bec0764df0fcfcaf3dbcb8d70d31142eaf |
| sql/52-setup.sql | Step 4c | 52af816435d3bfeeb5007c9a85d2de1e87f144a7dfc376abc8205b7e81696529 |
| sql/52-state1-root.sql | Step 4c | 20e4d35425ac037374f942c0283a67cc5ede6e64fc75bc57d83a6fc245143e65 |
| sql/52-state2-root.sql | Step 4c | 8361a4889898f0a30f59a5d06250ebed29dfacd98bbf3938582881293a96d693 |
| sql/52-state3-root.sql | Step 4c | e38fde03abf05fb7dec2897ad3d4e03c626c054b141160160d434eec9451a22c |
| sql/52-state4-root.sql | Step 4c | f3aece4fb4d47b570fc6fc2ac193739f6b1387a588288f762210994b424b5f25 |

## 15. Step 5 Firewall findings (F45 onward)

Added after earlier sections; earlier entries unchanged. All captured. Files are in evidence/ (53-*).

- **F45.** (captured) The component install script ran against schema `ddv_sec`; the captured output has no ERROR lines (the exit code is not in the capture). Afterwards `mysql.component` listed `file://component_firewall`; `component_firewall.database` was `ddv_sec` and `component_firewall.enabled` ON; `ddv_sec` held tables `firewall_group_allowlist`, `firewall_groups`, `firewall_membership` and 7 procedures; `performance_schema.persisted_variables` gained `component_firewall.database = ddv_sec`. (53-firewall-install.txt, 53-firewall-state.txt)
- **F46.** (captured) Root's `SHOW GRANTS` listed FIREWALL_EXEMPT but not FIREWALL_ADMIN. FIREWALL_ADMIN was granted to root@localhost for the test. (53-firewall-state.txt, 53-firewall-recording.txt)
- **F47.** (captured) `sp_set_firewall_group_mode_and_user('fw_agent', 'RECORDING', 'ddv_agent@%')` created the group with USERHOST `ddv_agent@%` and an empty `firewall_membership`; `sp_firewall_group_enlist` then added the membership row. (53-firewall-recording.txt, 53-firewall-enlist.txt)
- **F48.** (captured) Recording the four scripted questions gave 8 allowlist rules with literals replaced by `?`, including `SET NAMES ? COLLATE ?`, ``SET @@SESSION . `autocommit` = OFF`` and ``SELECT @@SESSION . `sql_mode` ``. (53-firewall-recording-run.txt, 53-firewall-allowlist.txt)
- **F49.** (captured) In PROTECTING mode the four scripted questions ran again and returned data (the run output is in 53-firewall-protecting.txt). Five other statements, each in its own run as `ddv_agent`, returned `ERROR 6444 (28000) at line 1: Access denied.`: `SELECT * FROM ddv_support.customers`, `SELECT * FROM ddv_support.payments`, `SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'`, `SELECT * FROM ddv_support.support_tickets` and `SELECT 1`. Afterwards `firewall_access_denied` was 10 and `firewall_access_granted` 28; the capture does not explain why the denied counter is 10 for five visible denials. The manual tutorial quotes `ERROR 1045 (28000): Statement was blocked by Firewall`. (53-firewall-protecting.txt, 53-firewall-protecting-status.txt)
- **F50.** (captured) `SELECT COUNT(*) FROM ddv_support.customers` returned 6 for `ddv_billing` and for root while the group was in PROTECTING mode. (53-firewall-others.txt)
- **F51.** (captured) `RESET` set the group mode to OFF and emptied the allowlist; `sp_firewall_group_remove` removed the group. The uninstall script ran against `ddv_sec` (exit code not captured); `ddv_sec` was dropped. The persisted `component_firewall.database` entry remained until `RESET PERSIST component_firewall.database`; afterwards only `log_bin_trust_function_creators` remained. (53-firewall-uninstall.txt)
- **F52.** (captured) The after snapshot compares equal to the baseline once timings are stripped. (53-after.txt, 53-compare.txt)
- **F53.** (captured) `agent/support_agent_fw.py` differs from `agent/support_agent.py` only in `CONTEXT_FILE`; its final console line still says `evidence/21-llm-context.txt` (hard-coded text) while the file written was `evidence/53-fw-llm-context.txt`. The hash of `evidence/21-llm-context.txt` is unchanged. (53-firewall-recording-run.txt)

## 16. Evidence index additions (Step 5 Firewall)

Files in sql/, agent/ and evidence/ not listed in earlier index sections. Step = Step 5 Firewall.

| File | Step | SHA-256 |
|---|---|---|
| agent/support_agent_fw.py | Step 5 Firewall | 2c4ff3551eefa89130912b394899e06309e1aaa95520e1274f78e9e458391112 |
| evidence/53-after.txt | Step 5 Firewall | 0daa5d680d5b74b1cb63f6f000b73f28b905044e79856524aa80d1c919e62d48 |
| evidence/53-compare.txt | Step 5 Firewall | 3578c435122e896b341f1b94c31ed5f1e33edf7cad3e9e96a80633a93f1f3264 |
| evidence/53-firewall-allowlist.txt | Step 5 Firewall | 7769c4b270d2aa5b6616ce992d0291f4fe40b06378ba175ad54762f71bf9d0b6 |
| evidence/53-firewall-enlist.txt | Step 5 Firewall | 486c26f778315089dcd9e2bd628d1723bbbe38d51e09a770963438815d294208 |
| evidence/53-firewall-install.txt | Step 5 Firewall | 2329acc01f1849e6e8141289dd92e7dd17a718d04feafc703316b831c73fcc88 |
| evidence/53-firewall-others.txt | Step 5 Firewall | 1820c636c4e780668e6bd3c78cf1a10416fc1181f7fa6f5485219789ca0a4a0a |
| evidence/53-firewall-protecting.txt | Step 5 Firewall | d1c7d388e5775c380b7b43eb30e76c21bb48e3e75ce412bf5ac5ea8763e37fc9 |
| evidence/53-firewall-protecting-status.txt | Step 5 Firewall | 5a75ea46e3621a69b6d4174ab17bf36194935e1966931e858c9dd74370e4eba7 |
| evidence/53-firewall-recording.txt | Step 5 Firewall | f31cc479dd57cfb0c5573fbaf6ebd3f0ffd656b0e7f61b2275c94fb798a26391 |
| evidence/53-firewall-recording-run.txt | Step 5 Firewall | 67da58bd32738e437abf5893a2d498e4e54f6a35a9946fbfb086132720df0d2c |
| evidence/53-firewall-state.txt | Step 5 Firewall | a9f5c4de1e0880979a91771bab734c432182cc068d10660a39eeeff942c86b61 |
| evidence/53-firewall-uninstall.txt | Step 5 Firewall | 5d098db6fb1c577d2c36dc16806be628a0fb186f17ea0d1adc72c8f7ddc7c8ba |
| evidence/53-fw-llm-context.txt | Step 5 Firewall | faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671 |
| evidence/53-schema-create.txt | Step 5 Firewall | d9fb415d3fdfd3774fd2d39b4192f2270a15e1db694c4f2cd3bf3c7f298c5b37 |
| evidence/REPORT-07.md | Step 5 Firewall | 21aa5b9280c781800afbbe853820ec60bc0740c638c88eab57dc7809b65a8dcc |
| sql/53-allowlist.sql | Step 5 Firewall | ac00fd48835cec239bd5aef77bce7713f2beecaeedaecbcd978d2f7ed172a11b |
| sql/53-create-schema.sql | Step 5 Firewall | a4d798dcbd163bfa14ffb1304ca3e026d660bae4808c1703f34bb7b2cd390725 |
| sql/53-enlist.sql | Step 5 Firewall | 5ce2848fc2efc8168edeb20b564fb0173a7a43bb2916cb2309e40819d49b1ae0 |
| sql/53-firewall-state.sql | Step 5 Firewall | 391ae0134f80c0a603d530c9dfa7b69e4e274619f0d1b949f7677c93c178fa45 |
| sql/53-others.sql | Step 5 Firewall | ae1ef3101a5ac1d5f19a29836e9cda8717b429af74b405c39c058afcd5b296af |
| sql/53-protecting-start.sql | Step 5 Firewall | e245ca12d84f4ffc5ed107a2bd38d922b14fd24181b144d1a118b6878c9c336a |
| sql/53-protecting-status.sql | Step 5 Firewall | 8d6f9b37966420397b83850de6019001033b54c47c300d18fa7e64366f142d38 |
| sql/53-protecting-stmts.sql | Step 5 Firewall | 451797a4d32828f397fcfe52d4621ec1cd7bcee596099bd546962ca5dc8fb1be |
| sql/53-recording-start.sql | Step 5 Firewall | 550b4506f123702b58d288ea44b60f4949e62a3adb4b7e0c483ae1d57ead4680 |
| sql/53-reset-persist.sql | Step 5 Firewall | c7b27a7b9232f2e706d54a94d0c46da2d32c83fd475f92048647a5afac1a5bec |
| sql/53-teardown-1.sql | Step 5 Firewall | 95170137e4ffcdc2f51d7d6a541a7ea691a57404959f04b8bf9b2f3ce243c800 |
| sql/53-teardown-2.sql | Step 5 Firewall | faceeebda5e078c18e53b5d898cb33d58e20b78023691364de6fe7db00706a0d |

## 17. Step 5 Audit findings (F54 onward)

Added after earlier sections; earlier entries unchanged. All captured. Files are in evidence/ (54-*). The planned filtered-audit test was not run (see F54).

- **F54.** (captured) `audit_log_component_filter_install.sql` run with `-D ddv_sec` created `audit_log_filter` and `audit_log_user` in `ddv_sec` and then failed: `ERROR 3536 (HY000): Initialization method provided by component 'audit_log' failed.` `mysql.component` did not list the audit component. (54-audit-install.txt, 54-audit-state.txt)
- **F55.** (captured) The server error log, read through `performance_schema.error_log`, held `Component audit_log reported: 'Failed to open 'mysql.audit_log_filter' audit_log table.'` (54-audit-error-log.txt)
- **F56.** (captured) The documented `audit_log_component_filter_uninstall.sql` run against `ddv_sec` returned `ERROR 3537 (HY000): Component specified by URN 'file://component_audit_log' to unload has not been loaded before.` for the UNINSTALL COMPONENT line and dropped both tables; `ddv_sec` was then dropped. The after snapshot compares equal to the baseline once timings are stripped. (54-audit-uninstall.txt, 54-after.txt, 54-compare.txt)
- **F57.** (not tested) Filtered audit logging for `ddv_agent`, reading the log with `audit_log_read`, and the default-filter behaviour were not tested because the install failed. The manual says no account is logged until a filter is assigned (reasoning/manual-documented, `.local` notes).

## 18. Evidence index additions (Step 5 Audit attempt)

Files in sql/, agent/ and evidence/ not listed in earlier index sections. Step = Step 5 Audit attempt.

| File | Step | SHA-256 |
|---|---|---|
| evidence/54-after.txt | Step 5 Audit attempt | 9d5105042ff317bc48cf7dbae04df836518e387bf0f90f4c34c9200ab749de44 |
| evidence/54-audit-error-log.txt | Step 5 Audit attempt | 86b9b931ffc1b5f2402e25f1e48bedede79f52ca6e6a835383fa29efc3ba2ffe |
| evidence/54-audit-install.txt | Step 5 Audit attempt | d1e9df96224a290cbe503c0c7008fbf124223a6062aaffb1b55f0bba5a5d2568 |
| evidence/54-audit-state.txt | Step 5 Audit attempt | 73d36359007a1d00edaf1ddb0c2bf8e82c68c5c64862228611aa9a342efee067 |
| evidence/54-audit-uninstall.txt | Step 5 Audit attempt | 7809db49939ea15237130a1ca14fff2c35064dcd63449d8f997612189d057a09 |
| evidence/54-compare.txt | Step 5 Audit attempt | 3b96c0587eeb1b855b887cb30100388b0a406b0f42d50bc894ea1d674553900a |
| evidence/54-schema-create.txt | Step 5 Audit attempt | beb82f6fb128db18722e0c872ba70c879cdc15c2f6de7ef188a3e3583c81de4d |
| evidence/REPORT-08.md | Step 5 Audit attempt | 2ca9903f46964e7931cd88a3cd4e817d68fb0546ae28edaba357b7113c62ec7b |
| sql/54-audit-state.sql | Step 5 Audit attempt | 0fbfb28480d97a4cd0fd3471d370141dcc0593ed33b53e3e31ec91ff0a0cd3af |
| sql/54-drop-schema.sql | Step 5 Audit attempt | 94678d76ff2eeb93d7b3f9ed15288edba03a1d6c57f19b9f846716988d8a8430 |
| sql/54-error-log.sql | Step 5 Audit attempt | 2bd265848fe5f57d36d362b84c570b6055750341cd3d1c9f2243e379c72b4c83 |

## 19. Manual notes (relayed by web-fetch subagents, open the page before quoting)

Label: manual-documented, not tested here. Short phrases only; the pages are under https://dev.mysql.com/doc/refman/9.7/en/ and were fetched 2026-11-03.

- `CURRENT_ROLE_IN` checks active roles. (gatekeeper-functions.html)
- Masking usage: for a view, stored function or procedure with SQL SECURITY INVOKER, "the privileges of the invoking user are considered". DEFINER is not documented there. (data-masking-policy-usage.html)
- Stored-objects security: for DEFINER routines the server sets "only the default roles" for the definer account, unless `activate_all_roles_on_login` is enabled. Note: this page concerns routines and does not mention masking. (stored-objects-security.html)
- Firewall component: the plugin is deprecated; the install script persists `component_firewall.database`; uninstall needs no other connections ("a single connection"); the manual tutorial shows ERROR 1045 "Statement was blocked by Firewall", while the captured denial was ERROR 6444 (F49). (firewall.html, firewall-component.html)
- Audit component: no filter is assigned by default, so nothing is logged; `audit_log.database` defaults to `mysql` and is read only; the install example uses `-D mysql`; audit-log.html covers the deprecated plugin, not the component. (audit-log-component-installation.html, audit-log-component-filtering.html, audit-log-component-reference.html)

## 20. Conclusions from captured tests (reasoning)

Inferences from the captured findings named in each bullet. Not tested beyond those runs.

- Views and routines that agents can reach should not be owned by an account with an active unmasking role. (F39 to F42)
- A shared writable table is a leak path. (F35)
- Masked columns can't be indexed. (F36)
- Masking changes sorting, grouping, distinct counts and joins, so give agents surrogate ids. (F21 to F23)
- The Firewall allowlist holds statement shapes with `?` for values. (F48)
- In-workflow shapes still return free text. (F8; question 3 in 53-firewall-protecting.txt)
- Client session statements must be recorded. (F48)
- A persisted setting remained after uninstall. (F51)

## 21. Step 6 Audit findings (F58 onward)

Added after earlier sections; earlier entries unchanged. All captured unless stated. Files are in evidence/ (60-* to 63-*). This follows the F54 to F57 failure and uses the documented route (`-D mysql`).

- **F58.** (captured) `audit_log_component_filter_install.sql` run with `-D mysql` succeeded: no ERROR lines, `mysql.component` listed `file://component_audit_log`, tables `audit_log_filter` and `audit_log_user` existed in `mysql`, and 10 `audit_log*` functions were registered. `audit_log.database` was `mysql`, `audit_log.filter_recovery_mode` was `LOG_ALL_IF_INVALID_FILTER_DETECTED`, and persisted variables were unchanged. The two CREATE TABLE statements printed warnings (1 and 2), all code 1287 (BINARY as attribute of a type is deprecated), now captured. In Step 5 the same script against `ddv_sec` failed (F54). That the schema choice caused the earlier failure is reasoning. (60-audit-install.txt, 60-audit-state.txt)
- **F59.** (captured) `audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }')` and `audit_log_filter_set_user('ddv_agent@%', 'agent_log')` both returned OK. `SHOW STATUS LIKE 'audit_log%'` gave `audit_log.filter_id` 1 for ddv_agent and 0 for root and ddv_billing. (60-audit-filter.txt, 60-status-root.txt, 60-status-agent.txt, 60-status-billing.txt)
- **F60.** (captured) The first `audit_log_read` call, started at the first event, returned 89 events (32634 bytes; `audit_log.read_buffer_size` is 32768, so truncation by the buffer is reasoning). Paging with `{"timestamp", "id", "max_array_length": 40}` returned 98 events followed by a null marker; the start event is returned again, so pages overlap by one. `audit_log.events_written` was 98 afterwards. Both extracts are kept. (62-audit-read.txt, 62-audit-read-complete.txt, 63-audit-remove.txt)
- **F61.** (captured) The 98 events were one server startup event (root) and 97 events from ddv_agent: 11 connects, 11 disconnects, 19 table_access reads and the rest general/status. Root and ddv_billing sessions that ran while the filter was assigned to ddv_agent are not in the log. (62-audit-read-complete.txt)
- **F62.** (captured) Denied statements were logged with their error codes: ALTER TABLE 1142, DROP MASKING POLICY 1227, CREATE TABLE ... AS SELECT 1142, CREATE VIEW 1142; they have a general/status event and no table_access event. The five out-of-workflow selects were logged as allowed (status 0), with statement text including literals such as the customer name and the LIKE pattern. Query results are not in the log. (61-outofworkflow-1.txt to 61-tampering-4.txt, 62-audit-read-complete.txt)
- **F63.** (captured) The raw `audit_log_read` JSON held a local path, the machine name and the OS user name (scan counts 1, 1 and 10), so the repo keeps only an extract. The extract scan found 0 forbidden terms, 0 passwords and 0 paths. (62-audit-read-complete.txt)
- **F64.** (captured) `audit_log_filter_remove_user` and `audit_log_filter_remove_filter` returned OK and both filter tables were empty. The uninstall script, run with `-D mysql` while the only connections were root and the event scheduler, ended without ERROR lines; the after snapshot equals the baseline. (63-audit-remove.txt, 63-audit-uninstall.txt, 63-after.txt, 63-compare.txt)
- **F65.** (not checked) The audit log file in the Data folder: access to the folder was denied, so names and sizes were not checked. (not tested) Statements containing passwords were deliberately not run while the component was loaded, so whether such text is masked in the log is not tested.

## 22. Evidence index additions (Step 6 Audit)

Files in sql/, agent/ and evidence/ not listed in earlier index sections. Step = Step 6 Audit.

| File | Step | SHA-256 |
|---|---|---|
| agent/support_agent_audit.py | Step 6 Audit | 047409996fd282b1bbeb372b1bd117f69d99dea38ebecdb62f5504be31d7a59b |
| evidence/60-audit-filter.txt | Step 6 Audit | 27289edeeb32d8c23c406aec7628b63c6fdb5a353c7ddba2822a662f2e81e57f |
| evidence/60-audit-install.txt | Step 6 Audit | 57271be0c7bb7260bfa1001abbb7a92b004144b7205678ca923e3cb5d1d7550c |
| evidence/60-audit-state.txt | Step 6 Audit | ec1a8d4b162ca6ca2ca3a49369645e61341131d6e6991b5ba8ba9d3a750dee07 |
| evidence/60-baseline.txt | Step 6 Audit | 2f707d43a6a80607c6e673e660e5566e3f47380e3021027511b5c5d0e44ad0e7 |
| evidence/60-status-agent.txt | Step 6 Audit | a3cb5f5a5724b30c00dd58a03e9dc8db2ae940c9d561d5acd01ddc735ebda9d2 |
| evidence/60-status-billing.txt | Step 6 Audit | f2481e3a1b33aa63a43f28720595ba1e6f7da52ae0192ecfd7bfdc4ec0434a7a |
| evidence/60-status-root.txt | Step 6 Audit | 9c2a890ac015486c8d3e6e4f6e17b9ce42ee1167af7e06e5b3a88b2dde9661f8 |
| evidence/61-audit-agent-run.txt | Step 6 Audit | 08da560a2e3fe1b94691e241a583f958361fcf304b26c75820531a6f230a4c0e |
| evidence/61-audit-llm-context.txt | Step 6 Audit | faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671 |
| evidence/61-outofworkflow-1.txt | Step 6 Audit | 51dbf1f2cb7c3ded83234e0c1d36e9c2b465c18855bee38d1ff98fa45618173b |
| evidence/61-outofworkflow-2.txt | Step 6 Audit | d031e753ab38afd3a673fde7ed3f46d08da1a109c5544f85bb561a1ebe03d0bd |
| evidence/61-outofworkflow-3.txt | Step 6 Audit | 025bcaa5e3cced372165c3ed74a9aa6b2539ad33b1d6a88cb189db7e0c56dbd1 |
| evidence/61-outofworkflow-4.txt | Step 6 Audit | 0f2c93162e01eb0c7e2987aeac8afeddf4391416eccdc616edba15a679ddca0f |
| evidence/61-outofworkflow-5.txt | Step 6 Audit | 813a3fc6395ff1c6dd5f47433c3f1676f1c6f8eb72e7e9d6717b0180faca7c38 |
| evidence/61-tampering-1.txt | Step 6 Audit | f915dc319e5c36b2906dce3e64e6795ced82c502c366de61c64c44cd45c794af |
| evidence/61-tampering-2.txt | Step 6 Audit | b92b96a5c6b0b995a3329cdb922561929be901eeb0e5c6bf16204c8351bd6469 |
| evidence/61-tampering-3.txt | Step 6 Audit | e9b2651a6c5e28eba0ded3741d332a3b8fec1e96a729e6ca11b275a5b9ed9899 |
| evidence/61-tampering-4.txt | Step 6 Audit | 7d860a2274d11565ee92babbdbac9eedaa59cceb03ed09ac332da96ad68301d5 |
| evidence/62-audit-read.txt | Step 6 Audit | ecd24b23c262507ba657e2ef5a694db3f887c38f38e66bdb340bb204a6af761a |
| evidence/62-audit-read-complete.txt | Step 6 Audit | 462f0328bd02585a71a65b252cf9c9f3db1ef482a1b274ae9896e5e13120989e |
| evidence/63-after.txt | Step 6 Audit | 58e6a199e7e971156de5498322e56f264f095141daf252596de48569642f67b5 |
| evidence/63-audit-remove.txt | Step 6 Audit | 9a6064c3a83d1bc14f69fc209694531dd6a01a8f2b8ade6ff5a6d472e44a445f |
| evidence/63-audit-uninstall.txt | Step 6 Audit | 85432a1150ccb236401ed1fc32cdaab0a72bc62fc2f8dd45657a91340c6e2574 |
| evidence/63-compare.txt | Step 6 Audit | ce030da78fdf204f968ceed9b58eb28a069bb598bf76890f91679ce81874dea5 |
| evidence/REPORT-09.md | Step 6 Audit | c16b622d98243505affe53b8121f117f8a32bea77623068f71ea3c91ddf992f5 |
| sql/60-audit-filter.sql | Step 6 Audit | c44ce8387e426f6d173ec555c561d89a4216d19d39bac33025c5ac4f7b8852ac |
| sql/60-audit-state.sql | Step 6 Audit | a202e97f6516b18e2245d206f90fe3039b74af594bba38cfd69ca885c796d8e5 |
| sql/60-audit-status.sql | Step 6 Audit | cebd34c8a4ffa9ff1c48251aa5626c374cab120a79498134192e2b27cad1a037 |
| sql/60-snapshot.sql | Step 6 Audit | c7994aef37cefeae28c36fc3b2531ac8a7e6894ad767a2cf7491ed62de2201d2 |
| sql/61-outofworkflow-1.sql | Step 6 Audit | 07a020ad02a6c4beaefd30cce44dec18335d4ce2509bd142cb38cbb1a57644b9 |
| sql/61-outofworkflow-2.sql | Step 6 Audit | 7a67024e80a7b525508f884e3a680edb7a225dd11afbe50d3703caa3e3c29e22 |
| sql/61-outofworkflow-3.sql | Step 6 Audit | c261a3937d5c4f6cfd29c52029781c060bf2e9e7689c35b9750081d174ca9d9d |
| sql/61-outofworkflow-4.sql | Step 6 Audit | 4cf2e6d757174c0589fcbae1ba031ea07ce30e7b8ebaa8a2ca8e2301dfe5e520 |
| sql/61-outofworkflow-5.sql | Step 6 Audit | d3cd5042f97738960d802ad6b3a548dfa18152215118ba18f04493bc6944b0e4 |
| sql/61-tampering-1.sql | Step 6 Audit | 1c02af14065b1db3f01361def465d86e616c6aa45debde2c807a38ef669def9f |
| sql/61-tampering-2.sql | Step 6 Audit | 2680c150fbd857741504abe90fcbd5a74f2e9a3482750de11863220d68d612bd |
| sql/61-tampering-3.sql | Step 6 Audit | df1666896c6a13f988e7fcc9336f0db7b5294b4af34d5729197565086666f74a |
| sql/61-tampering-4.sql | Step 6 Audit | 38378804d62846ed3ef75f36731c907698b39100ec0f9a0df1829a784d01f5d3 |
| sql/63-audit-remove.sql | Step 6 Audit | 30d54ff3fec2c3c28e99c27ce4b8ac2d5721764ae808ec767473fc008b8afa83 |
