USE ddv_probe2;
CREATE TABLE probe_idx (id INT PRIMARY KEY, code VARCHAR(20), KEY k_code (code));
INSERT INTO probe_idx VALUES (1, 'code-one');
ALTER TABLE probe_idx MODIFY COLUMN code VARCHAR(20) MASKING POLICY probe_mask_phone;
SHOW WARNINGS;
CREATE INDEX idx_phone ON probe_people (phone);
SHOW WARNINGS;
SHOW CREATE TABLE probe_idx;
SHOW CREATE TABLE probe_people;
