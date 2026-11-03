SELECT CURRENT_USER(), CURRENT_ROLE();
WITH c AS (SELECT id, email FROM probe_people) SELECT id, email FROM c ORDER BY email;
