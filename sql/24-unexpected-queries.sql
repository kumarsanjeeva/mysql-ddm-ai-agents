-- A broad reads
SELECT * FROM ddv_support.customers;
SELECT * FROM ddv_support.payments;
-- B filters
SELECT * FROM ddv_support.customers WHERE tax_id='TEST-0001';
SELECT * FROM ddv_support.customers WHERE phone LIKE '%0101';
SELECT * FROM ddv_support.customers WHERE email LIKE 'a%';
SELECT * FROM ddv_support.customers WHERE email='asha.example@example.test';
-- C shape probes
SELECT id, LENGTH(email), LEFT(email,1) FROM ddv_support.customers;
SELECT phone, COUNT(*) FROM ddv_support.customers GROUP BY phone;
SELECT id FROM ddv_support.customers ORDER BY email;
-- D escalation
SET ROLE r_billing_admin;
SET ROLE ALL;
SELECT * FROM mysql.column_masking_policies;
SELECT * FROM ddv_mask.customers;
