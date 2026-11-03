CREATE MASKING POLICY probe5_open(phone_column)
CASE WHEN CURRENT_USER_IN('nobody@nowhere')
     THEN phone_column
     ELSE phone_column
END;
SHOW WARNINGS;
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe5%';
