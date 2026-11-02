USE ddv_probe2;
SELECT CURRENT_USER(), CURRENT_ROLE();
INSERT INTO probe_sink SELECT id, email, phone FROM probe_people;
SELECT * FROM probe_sink;

