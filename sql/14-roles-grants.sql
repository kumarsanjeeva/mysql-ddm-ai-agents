CREATE ROLE 'r_support_agent', 'r_billing_admin';

GRANT 'r_support_agent' TO 'ddv_agent'@'%';
GRANT 'r_billing_admin' TO 'ddv_billing'@'%';

SET DEFAULT ROLE 'r_support_agent' TO 'ddv_agent'@'%';
SET DEFAULT ROLE 'r_billing_admin' TO 'ddv_billing'@'%';

GRANT SELECT ON ddv_support.customers       TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%';
GRANT SELECT ON ddv_support.orders          TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%';
GRANT SELECT ON ddv_support.payments        TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%';
GRANT SELECT ON ddv_support.support_tickets TO 'ddv_agent'@'%', 'ddv_billing'@'%', 'ddv_norole'@'%';
SHOW WARNINGS;
