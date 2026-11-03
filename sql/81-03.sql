SELECT CURRENT_USER(), CURRENT_ROLE();
SELECT id FROM probe_people WHERE phone IN (SELECT phone FROM probe_people WHERE id = 1) ORDER BY id;
