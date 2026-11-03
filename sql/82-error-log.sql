SELECT LOGGED, PRIO, SUBSYSTEM, DATA FROM performance_schema.error_log WHERE DATA LIKE '%irewall%' ORDER BY LOGGED DESC LIMIT 40;
SHOW VARIABLES LIKE 'log_error_verbosity';
SHOW VARIABLES LIKE 'component_firewall.trace';
