CALL ddv_sec.sp_set_firewall_group_mode_and_user('fw_norole', 'RECORDING', 'ddv_norole@%');
SHOW WARNINGS;
CALL ddv_sec.sp_firewall_group_enlist('fw_norole', 'ddv_norole@%');
SHOW WARNINGS;
SELECT * FROM performance_schema.firewall_groups;
SELECT * FROM performance_schema.firewall_membership;
