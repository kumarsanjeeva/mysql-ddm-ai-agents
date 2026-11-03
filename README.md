# MySQL Dynamic Data Masking for an AI agent

## What this is

This is a small customer-support scenario. It tests MySQL Dynamic Data Masking for an AI agent.

It was tested on MySQL Enterprise Edition 9.7.4. I used the trial version from Oracle Software Delivery Cloud.

The agent is a fixed script. No LLM is called. The script shows the text a model would receive.

All data is fake. Each table has three to ten rows.

## What is not in this repo

Oracle software is not in this repo. Oracle's install scripts are not in this repo either.

You need your own MySQL Enterprise download. The install and uninstall scripts come from the `share` folder of that installation.

## Layout

- `sql/`: the SQL scripts, numbered in the order they were run. Files named `*template*` are templates.
- `agent/`: the scripted support agent (Python) and copies of it that change only the output file.
- `docs/`: notes. `docs/FINDINGS.md` is the main reference. `docs/agent-walkthrough.md` explains the agent.
- `evidence/`: raw client output, the `REPORT-nn.md` files and the SHA-256 hashes.
- `scripts/`: `verify-hashes.ps1`, which checks the hashes.

## Reading the evidence

Every result in `docs/FINDINGS.md` carries one label:

- captured test: I ran it and the output is in `evidence/`.
- manual-documented: taken from the MySQL manual. I did not test it.
- reasoning: an inference from captured output. I did not test it.
- not tested: nothing was run.

Evidence files are raw client output. I did not edit them. Some early runs lack error lines, because the client's error output was not captured. The reports say which.

Each `evidence/REPORT-nn.md` lists a SHA-256 hash for every file added in that step.

`scripts/verify-hashes.ps1` reads those lists and hashes each file again. Run it from the repo root with Windows PowerShell 5.1:

```
powershell -File scripts\verify-hashes.ps1
```

It prints `checked=N mismatches=M` for each report, and `MISMATCH` plus the path for each bad file. The exit code is 1 if any file differs or is missing.

## Reproduce it

Passwords are never in the repo. Files named `sql/*template*` hold `<redacted>`. Generate your own passwords and keep them outside the repo.

The agent reads its login from a `.local/agent.cnf` file, which is not in the repo. Create it yourself with the usual `[client]` section for `ddv_agent`. The agent needs the `mysql-connector-python` package.

1. Install MySQL Enterprise on a throwaway server.
2. From the `share` folder of that installation, run `masking_functions_install.sql` and `install_component_object_policy.sql` against the `mysql` schema (`docs/FINDINGS.md`, section 2).
3. Create the users `ddv_agent`, `ddv_billing` and `ddv_norole`, as in `sql/00-create-users.template.sql`.
4. Run `sql/12-support-schema.sql`, which creates `ddv_support` with fake data.
5. Run `sql/13-support-policies.sql`, which creates the masking policies.
6. Run `sql/14-roles-grants.sql`, which creates the two roles and the grants.
7. Run `sql/15-verify-user.sql` once as each of the three users and compare with `evidence/15-*`.
8. Run `agent/support_agent.py` and compare with `evidence/21-llm-context.txt`.
9. Run `sql/24-unexpected-queries.sql` as `ddv_agent`.
10. Later steps follow the numbering: `30-` to `37-` (views, routines, copy out), `40-` to `46-`, `50-` to `53-` (Firewall), `54-` and `60-` to `63-` (Audit), `70-` to `73-` (together), `80-` to `84-` and `90-` to `92-` (ALTER and inference probes). `evidence/REPORT-nn.md` lists the files of each step.

I have not listed every flag of every run here. The evidence files show the statements that were run.

## Before you run anything

Run it on a throwaway server.

- The Enterprise MSI can upgrade an existing Community install in place. I saw this on a machine with Community 9.7.2 (`docs/FINDINGS.md`, section 2).
- Audit writes log files into the data directory. I did not check what is left there after uninstall, because access to that folder was denied (F65). Check it yourself.
- The Firewall install persists the setting `component_firewall.database`. It stays after uninstall until you run `RESET PERSIST component_firewall.database` (F51, F92).

## What was and wasn't tested

- **Masking and free text.** With role-gated policies, `ddv_agent` and `ddv_norole` saw masked phone, email, tax id, card and UPI. `ddv_billing` with `r_billing_admin` active saw real values (F4, F5, F6; captured test). Free text is not masked: a card number and an email in a ticket note were readable by all three (F8; captured test). The agent's filters ran on the masked value (F2; captured test, two queries only).
- **ALTER and policy attach.** An account with ALTER but without `MANAGE_DATA_MASKING_POLICY` removed a policy with `MODIFY COLUMN` and no policy clause, and real values followed (F77, F94, F96; captured test). The same account attached a policy to a column that had none (F95, F98; captured test). The same account was refused `CREATE MASKING POLICY` and `DROP MASKING POLICY` with error 1227 (F99; captured test). `ddv_agent` was refused ALTER with error 1142 (F100; captured test). F78 is reworded because its run did not show who attached the policy; F95 is the clean test.
- **Firewall and Audit.** In PROTECTING mode the Firewall denied statements outside the recorded shapes with error 6444 (F49; captured test). The same text as an `OR` outside a literal was denied and inside one literal it was accepted (F85; captured test). In DETECTING mode the statements ran and a counter rose, with no error log rows at verbosity 2 (F88; captured test). The Audit component installed with `-D mysql` and logged by filter (F58, F89; captured test). It showed `<secret>` for the passwords in account statements, and a password-like text inside a `SELECT` literal was logged as written (F90; captured test).

Limits, in plain words. This is one server, one scripted agent, and small fake tables. No real LLM was run. I did not test encryption, MySQL REST Service, Audit log rotation, pruning, compression or encryption, a server restart, or masking-policy changes while the Firewall is in PROTECTING mode (F76 and `docs/FINDINGS.md`, section 7). These results show what happened in these runs. They are not a guarantee for your setup.

## Licence

The MIT licence in `LICENSE` covers my SQL, scripts and text. It does not cover Oracle's software.
