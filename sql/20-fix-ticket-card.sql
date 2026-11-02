UPDATE ddv_support.support_tickets
SET notes = REPLACE(notes, '5555555555554444', '378282246310005')
WHERE id = 3;
SHOW WARNINGS;
SELECT notes FROM ddv_support.support_tickets WHERE id=3;
