REVOKE SELECT, INSERT, UPDATE, ALTER ON ddv_probe5.probe_alter FROM 'ddv_alterer2'@'%';
DROP SCHEMA IF EXISTS ddv_probe5;
DROP MASKING POLICY IF EXISTS probe5_mask_phone;
DROP MASKING POLICY IF EXISTS probe5_open;
DROP MASKING POLICY IF EXISTS probe5_try;
DROP USER IF EXISTS 'ddv_alterer2'@'%';
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%';
SHOW DATABASES LIKE 'ddv_probe5';
SELECT user FROM mysql.user WHERE user LIKE 'ddv_alterer%';
