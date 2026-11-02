USE ddv_probe;
REVOKE SELECT ON ddv_probe.probe_people FROM 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_agent'@'%';

CREATE DEFINER=root@localhost SQL SECURITY DEFINER VIEW v_people_definer AS SELECT * FROM probe_people;
CREATE DEFINER=root@localhost SQL SECURITY INVOKER VIEW v_people_invoker AS SELECT * FROM probe_people;
CREATE DEFINER=root@localhost PROCEDURE p_people() SQL SECURITY DEFINER SELECT * FROM probe_people;
SHOW WARNINGS;

GRANT SELECT ON ddv_probe.v_people_definer TO 'ddv_agent'@'%', 'ddv_billing'@'%';
GRANT SELECT ON ddv_probe.v_people_invoker TO 'ddv_agent'@'%', 'ddv_billing'@'%';
GRANT EXECUTE ON PROCEDURE ddv_probe.p_people TO 'ddv_agent'@'%', 'ddv_billing'@'%';
SHOW WARNINGS;
SHOW GRANTS FOR 'ddv_agent'@'%';
SHOW GRANTS FOR 'ddv_billing'@'%';
