DROP VIEW IF EXISTS wordform_frequency;
CREATE VIEW wordform_frequency AS
SELECT w.*, IFNULL(CAST(u.frequency AS INTEGER), 0) as frequency FROM wordform w
LEFT JOIN unigram u ON w.wordform = u.wordform;