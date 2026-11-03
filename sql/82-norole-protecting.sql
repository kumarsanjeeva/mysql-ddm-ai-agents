CALL ddv_sec.sp_set_firewall_group_mode('fw_norole', 'PROTECTING');
SHOW WARNINGS;
SELECT * FROM performance_schema.firewall_groups;
SELECT * FROM performance_schema.firewall_group_allowlist WHERE NAME = 'fw_norole';
