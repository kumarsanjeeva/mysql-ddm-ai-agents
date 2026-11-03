ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe4_mask_phone;
SHOW CREATE TABLE probe_alter;
