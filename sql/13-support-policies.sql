USE ddv_support;

CREATE MASKING POLICY sup_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END;
SHOW WARNINGS;

CREATE MASKING POLICY sup_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END;
SHOW WARNINGS;

CREATE MASKING POLICY sup_mask_tax_id(tax_id_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN tax_id_column
     ELSE mask_inner(tax_id_column, 0, 0, '*')
END;
SHOW WARNINGS;

CREATE MASKING POLICY sup_mask_card(card_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN card_column
     ELSE mask_inner(card_column, 0, 4, '*')
END;
SHOW WARNINGS;

CREATE MASKING POLICY sup_mask_upi(upi_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN upi_column
     ELSE mask_inner(upi_column, 1, 0, '*')
END;
SHOW WARNINGS;

ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20) NOT NULL MASKING POLICY sup_mask_phone;
ALTER TABLE customers MODIFY COLUMN email VARCHAR(100) NOT NULL MASKING POLICY sup_mask_email;
ALTER TABLE customers MODIFY COLUMN tax_id VARCHAR(20) NOT NULL MASKING POLICY sup_mask_tax_id;
ALTER TABLE payments MODIFY COLUMN card_number VARCHAR(19) NULL MASKING POLICY sup_mask_card;
ALTER TABLE payments MODIFY COLUMN upi_id VARCHAR(50) NULL MASKING POLICY sup_mask_upi;
SHOW WARNINGS;

SELECT * FROM mysql.column_masking_policies;
