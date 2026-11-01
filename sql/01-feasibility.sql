SELECT VERSION();
SELECT CURRENT_USER();

CREATE SCHEMA ddv_mask;
USE ddv_mask;

CREATE TABLE customers (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL
);
SHOW WARNINGS;

INSERT INTO customers VALUES
  (1, 'Alice Example', '555-0101', 'alice@example.test'),
  (2, 'Bob Sample',    '555-0102', 'bob@example.test'),
  (3, 'Carol Demo',    '555-0103', 'carol@example.test');
SHOW WARNINGS;

CREATE MASKING POLICY mask_phone(phone_column)
CASE WHEN CURRENT_USER_IN('ddv_admin@%')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END;
SHOW WARNINGS;

CREATE MASKING POLICY mask_email(email_column)
CASE WHEN CURRENT_USER_IN('ddv_admin@%')
     THEN email_column
     ELSE mask_outer(email_column, 2, 2, '#')
END;
SHOW WARNINGS;

ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20) NOT NULL MASKING POLICY mask_phone;
SHOW WARNINGS;

ALTER TABLE customers MODIFY COLUMN email VARCHAR(100) NOT NULL MASKING POLICY mask_email;
SHOW WARNINGS;

GRANT SELECT ON ddv_mask.* TO 'ddv_agent'@'%';
SHOW WARNINGS;
GRANT SELECT ON ddv_mask.* TO 'ddv_admin'@'%';
SHOW WARNINGS;

SELECT * FROM customers ORDER BY id;
