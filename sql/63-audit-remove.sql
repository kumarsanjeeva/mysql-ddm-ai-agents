SELECT audit_log_filter_remove_user('ddv_agent@%');
SELECT audit_log_filter_remove_filter('agent_log');
SELECT * FROM mysql.audit_log_filter;
SELECT * FROM mysql.audit_log_user;
SHOW STATUS LIKE 'audit_log.events%';
SELECT ID, USER, HOST, DB, COMMAND FROM information_schema.PROCESSLIST;
