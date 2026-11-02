USE ddv_probe2;
SELECT CURRENT_USER(), CURRENT_ROLE();
SELECT * FROM v_owner_definer;
CALL p_owner();
SELECT notes FROM probe_people;
SELECT notes FROM v_owner_definer;
