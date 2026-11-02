CREATE TABLE ddv_probe2.probe_sink (id INT, email VARCHAR(100), phone VARCHAR(20));
GRANT SELECT, INSERT, DELETE ON ddv_probe2.probe_sink TO 'ddv_agent'@'%', 'ddv_billing'@'%';
GRANT SELECT ON ddv_probe2.probe_people TO 'ddv_billing'@'%';
SHOW WARNINGS;
SHOW GRANTS FOR 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_billing'@'%';
