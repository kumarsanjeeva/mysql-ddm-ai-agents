CREATE SCHEMA ddv_support;
USE ddv_support;

CREATE TABLE customers (
  id INT NOT NULL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  tax_id VARCHAR(20) NOT NULL
);

CREATE TABLE orders (
  id INT NOT NULL PRIMARY KEY,
  customer_id INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers (id)
);

CREATE TABLE payments (
  id INT NOT NULL PRIMARY KEY,
  order_id INT NOT NULL,
  method VARCHAR(10) NOT NULL,
  card_number VARCHAR(19) NULL,
  upi_id VARCHAR(50) NULL,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders (id)
);

CREATE TABLE support_tickets (
  id INT NOT NULL PRIMARY KEY,
  customer_id INT NOT NULL,
  subject VARCHAR(200) NOT NULL,
  notes TEXT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers (id)
);
SHOW WARNINGS;

INSERT INTO customers VALUES
  (1, 'Asha Example',   '555-0101', 'asha.example@example.test',   'TEST-0001'),
  (2, 'Bilal Sample',   '555-0102', 'bilal.sample@example.test',   'TEST-0002'),
  (3, 'Chen Demo',      '555-0103', 'chen.demo@example.test',      'TEST-0003'),
  (4, 'Dana Placeholder','555-0104', 'dana.placeholder@example.test','TEST-0004'),
  (5, 'Elif Fictional', '555-0105', 'elif.fictional@example.test', 'TEST-0005'),
  (6, 'Farid Mock',     '555-0106', 'farid.mock@example.test',     'TEST-0006');

INSERT INTO orders VALUES
  (101, 1, 'delivered', 1250.00, '2026-09-01 10:15:00'),
  (102, 1, 'shipped',    349.50, '2026-09-20 14:02:00'),
  (103, 2, 'delivered',  899.99, '2026-09-03 09:40:00'),
  (104, 2, 'refunded',   120.00, '2026-09-11 16:25:00'),
  (105, 3, 'pending',    45.00,  '2026-10-02 11:05:00'),
  (106, 3, 'delivered',  310.75, '2026-09-28 18:30:00'),
  (107, 4, 'cancelled',  75.25,  '2026-09-15 08:55:00'),
  (108, 5, 'shipped',    560.00, '2026-10-05 13:45:00'),
  (109, 6, 'delivered',  99.99,  '2026-10-10 17:10:00'),
  (110, 6, 'pending',    210.40, '2026-10-12 12:00:00');

INSERT INTO payments VALUES
  (1001, 101, 'card', '4111111111111111', NULL,            'captured'),
  (1002, 102, 'upi',  NULL,               'asha@testbank', 'captured'),
  (1003, 103, 'card', '5555555555554444', NULL,            'captured'),
  (1004, 104, 'card', '5555555555554444', NULL,            'refunded'),
  (1005, 105, 'upi',  NULL,               'chen@testbank', 'pending'),
  (1006, 106, 'card', '378282246310005',  NULL,            'captured'),
  (1007, 107, 'card', '6011111111111117', NULL,            'voided'),
  (1008, 108, 'upi',  NULL,               'elif@testbank', 'captured'),
  (1009, 109, 'card', '4242424242424242', NULL,            'captured'),
  (1010, 110, 'upi',  NULL,               'farid@testbank','pending');

INSERT INTO support_tickets VALUES
  (1, 1, 'Where is my order 102?',            'Customer asked for tracking. Shipped 2026-09-20.'),
  (2, 2, 'Refund for order 104',              'Refund issued to original payment method.'),
  (3, 3, 'Charge failed, please call back',   'Customer typed: my card is 5555555555554444 and you can reach me at chen.demo@example.test, please retry the charge.'),
  (4, 5, 'Change delivery address',           'Address change requested before shipment.'),
  (5, 6, 'Order 110 still pending',           'Customer asked why payment is pending; UPI collect request sent.');
SHOW WARNINGS;
SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS orders FROM orders;
SELECT COUNT(*) AS payments FROM payments;
SELECT COUNT(*) AS tickets FROM support_tickets;
