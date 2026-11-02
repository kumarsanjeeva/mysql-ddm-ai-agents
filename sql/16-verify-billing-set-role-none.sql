SELECT CURRENT_USER(), CURRENT_ROLE();
SELECT * FROM ddv_support.customers ORDER BY id;
SELECT o.id AS order_id, o.status, o.total_amount, o.created_at, c.id AS customer_id, c.full_name, c.phone, c.email, c.tax_id
  FROM ddv_support.orders o JOIN ddv_support.customers c ON c.id = o.customer_id ORDER BY o.id;
SELECT * FROM ddv_support.payments ORDER BY id;
SELECT * FROM ddv_support.support_tickets ORDER BY id;
SET ROLE NONE;
SELECT CURRENT_USER(), CURRENT_ROLE();
SELECT * FROM ddv_support.customers ORDER BY id;
