SHOW CREATE TABLE ddv_mask.customers;
SELECT id, phone, email FROM ddv_mask.customers;
SELECT id FROM ddv_mask.customers WHERE phone='555-0101';
SELECT id FROM ddv_mask.customers WHERE email LIKE 'alice%';
SHOW GRANTS;
