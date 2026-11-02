-- Template only. Real passwords are random, generated into a gitignored file under .local/.
-- ddv_agent already existed from Step 1 and kept its password (hence IF NOT EXISTS).
CREATE USER IF NOT EXISTS 'ddv_agent'@'%'   IDENTIFIED BY '<redacted>';
CREATE USER 'ddv_billing'@'%' IDENTIFIED BY '<redacted>';
CREATE USER 'ddv_norole'@'%'  IDENTIFIED BY '<redacted>';
