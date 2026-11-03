CREATE SCHEMA ddv_probe4;
USE ddv_probe4;
CREATE TABLE probe_alter (
  id INT PRIMARY KEY,
  phone VARCHAR(20),
  notes TEXT
);
INSERT INTO probe_alter VALUES
  (1, '555-0101', 'note one'),
  (2, '777-0101', 'note two'),
  (3, '555-0303', 'note three');
SHOW WARNINGS;
CREATE MASKING POLICY probe4_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END;
SHOW WARNINGS;
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe4_mask_phone;
SHOW WARNINGS;
GRANT SELECT, ALTER, INSERT, UPDATE ON ddv_probe4.probe_alter TO 'ddv_alterer'@'%';
SHOW WARNINGS;
SHOW GRANTS FOR 'ddv_alterer'@'%';
SHOW CREATE TABLE probe_alter;
SELECT * FROM probe_alter;
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe4%';
