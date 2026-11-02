SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'ddv%';
SELECT policy_name FROM mysql.column_masking_policies ORDER BY 1;
SHOW GRANTS FOR 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_billing'@'%';
SHOW GRANTS FOR 'ddv_norole'@'%';
