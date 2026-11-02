CREATE SCHEMA ddv_probe2;
USE ddv_probe2;

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

CREATE MASKING POLICY probe_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END;
SHOW WARNINGS;

CREATE MASKING POLICY probe_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END;
SHOW WARNINGS;

ALTER TABLE probe_people MODIFY COLUMN email VARCHAR(100) MASKING POLICY probe_mask_email;
ALTER TABLE probe_people MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe_mask_phone;
SHOW WARNINGS;

GRANT 'r_billing_admin'@'%' TO 'ddv_owner'@'%';
SET DEFAULT ROLE 'r_billing_admin'@'%' TO 'ddv_owner'@'%';
GRANT SELECT ON ddv_probe2.probe_people TO 'ddv_owner'@'%';
SHOW WARNINGS;

CREATE DEFINER='ddv_owner'@'%' SQL SECURITY DEFINER VIEW v_owner_definer AS SELECT * FROM probe_people;
CREATE DEFINER='ddv_owner'@'%' PROCEDURE p_owner() SQL SECURITY DEFINER SELECT * FROM probe_people;
SHOW WARNINGS;

GRANT SELECT (id, email, phone) ON ddv_probe2.probe_people TO 'ddv_agent'@'%';
GRANT SELECT ON ddv_probe2.v_owner_definer TO 'ddv_agent'@'%';
GRANT EXECUTE ON PROCEDURE ddv_probe2.p_owner TO 'ddv_agent'@'%';
SHOW WARNINGS;

SHOW GRANTS FOR 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_owner'@'%';
SHOW CREATE VIEW ddv_probe2.v_owner_definer;
