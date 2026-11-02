REVOKE SELECT ON ddv_probe.probe_people FROM 'ddv_agent'@'%';
GRANT SELECT (id, email, phone) ON ddv_probe.probe_people TO 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_agent'@'%';
