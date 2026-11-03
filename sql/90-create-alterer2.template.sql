-- Template. The real file is in .local (gitignored). Run with the client echo off (no -v).
CREATE USER 'ddv_alterer2'@'%' IDENTIFIED BY '<redacted>';
GRANT SELECT, INSERT, UPDATE, ALTER ON ddv_probe5.probe_alter TO 'ddv_alterer2'@'%';
