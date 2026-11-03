SELECT * FROM mysql.component;
SHOW TABLES FROM mysql LIKE 'audit%';
SHOW VARIABLES LIKE 'audit_log%';
SHOW STATUS LIKE 'audit_log%';
SELECT * FROM performance_schema.persisted_variables;
SELECT UDF_NAME FROM performance_schema.user_defined_functions WHERE UDF_NAME LIKE 'audit_log%' ORDER BY 1;
SELECT * FROM mysql.audit_log_filter;
SELECT * FROM mysql.audit_log_user;
