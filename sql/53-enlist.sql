CALL ddv_sec.sp_firewall_group_enlist('fw_agent', 'ddv_agent@%');
SHOW WARNINGS;
SELECT * FROM performance_schema.firewall_groups;
SELECT * FROM performance_schema.firewall_membership;
