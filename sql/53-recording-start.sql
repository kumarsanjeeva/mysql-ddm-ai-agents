GRANT FIREWALL_ADMIN ON *.* TO 'root'@'localhost';
SHOW WARNINGS;
CALL ddv_sec.sp_set_firewall_group_mode_and_user('fw_agent', 'RECORDING', 'ddv_agent@%');
SHOW WARNINGS;
SELECT * FROM performance_schema.firewall_groups;
SELECT * FROM performance_schema.firewall_membership;
