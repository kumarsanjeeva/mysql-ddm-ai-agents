CREATE SCHEMA ddv_probe5;
USE ddv_probe5;
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
CREATE MASKING POLICY probe5_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END;
SHOW WARNINGS;
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe5_mask_phone;
SHOW WARNINGS;
SHOW CREATE TABLE probe_alter;
SELECT * FROM probe_alter;
