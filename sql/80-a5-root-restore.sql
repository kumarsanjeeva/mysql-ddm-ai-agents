ALTER TABLE probe_alter CHANGE COLUMN phone2 phone VARCHAR(20) MASKING POLICY probe4_mask_phone;
SHOW CREATE TABLE probe_alter;
SELECT * FROM probe_alter;
