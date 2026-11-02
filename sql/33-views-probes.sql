USE ddv_probe;
SELECT CURRENT_USER(), CURRENT_ROLE();
SELECT * FROM v_people_definer;
SELECT * FROM v_people_invoker;
CALL p_people();
SELECT * FROM probe_people;
