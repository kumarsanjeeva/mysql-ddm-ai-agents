SELECT audit_log_filter_set_filter('root_log', '{ "filter": { "log": true } }');
SELECT audit_log_filter_set_user('root@localhost', 'root_log');
