CREATE TABLE ddv_probe.probe_sink (id INT, email VARCHAR(100), phone VARCHAR(20));
GRANT INSERT, SELECT ON ddv_probe.probe_sink TO 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_agent'@'%';
