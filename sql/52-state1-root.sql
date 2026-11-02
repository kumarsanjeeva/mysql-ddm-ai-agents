GRANT 'r_billing_admin'@'%' TO 'ddv_owner2'@'%';
SET DEFAULT ROLE 'r_billing_admin'@'%' TO 'ddv_owner2'@'%';
SHOW WARNINGS;
SHOW GRANTS FOR 'ddv_owner2'@'%';

