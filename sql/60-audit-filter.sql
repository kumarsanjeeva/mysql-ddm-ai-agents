SELECT audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }');
SELECT audit_log_filter_set_user('ddv_agent@%', 'agent_log');
SELECT * FROM mysql.audit_log_filter;
SELECT * FROM mysql.audit_log_user;
