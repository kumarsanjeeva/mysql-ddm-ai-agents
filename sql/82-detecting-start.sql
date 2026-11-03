CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'DETECTING');
SHOW WARNINGS;
SELECT * FROM performance_schema.firewall_groups;
