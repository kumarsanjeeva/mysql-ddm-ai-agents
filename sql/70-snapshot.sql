SELECT * FROM mysql.component;
SHOW TABLES FROM mysql LIKE 'audit%';
SHOW VARIABLES LIKE 'audit_log%';
SELECT * FROM performance_schema.persisted_variables;
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST;
