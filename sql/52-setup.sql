CREATE SCHEMA ddv_probe3;
USE ddv_probe3;
CREATE TABLE probe_people (
  id INT PRIMARY KEY,
  email VARCHAR(100),
  phone VARCHAR(20),
  notes TEXT
);
INSERT INTO probe_people VALUES
  (1, 'mark.zzzz@example.test', '555-0101', 'note one'),
  (2, 'mark.aaaa@example.test', '777-0101', 'note two'),
  (3, 'lena.mmmm@example.test', '555-0303', 'note three');
SHOW WARNINGS;
CREATE MASKING POLICY probe3_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END;
SHOW WARNINGS;
CREATE MASKING POLICY probe3_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END;
SHOW WARNINGS;
ALTER TABLE probe_people MODIFY COLUMN email VARCHAR(100) MASKING POLICY probe3_mask_email;
ALTER TABLE probe_people MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe3_mask_phone;
SHOW WARNINGS;
GRANT SELECT ON ddv_probe3.probe_people TO 'ddv_owner2'@'%';
CREATE DEFINER='ddv_owner2'@'%' SQL SECURITY DEFINER VIEW v_owner2_definer AS SELECT * FROM probe_people;
CREATE DEFINER='ddv_owner2'@'%' PROCEDURE p_owner2() SQL SECURITY DEFINER SELECT * FROM probe_people;
GRANT EXECUTE ON PROCEDURE ddv_probe3.p_owner2 TO 'ddv_owner2'@'%';
GRANT SELECT ON ddv_probe3.v_owner2_definer TO 'ddv_agent'@'%';
GRANT EXECUTE ON PROCEDURE ddv_probe3.p_owner2 TO 'ddv_agent'@'%';
SHOW WARNINGS;
SHOW GRANTS FOR 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_owner2'@'%';
SHOW CREATE VIEW ddv_probe3.v_owner2_definer;
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe3%';
