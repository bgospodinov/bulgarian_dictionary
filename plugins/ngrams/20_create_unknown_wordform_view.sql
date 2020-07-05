DROP VIEW IF EXISTS unknown_words;
CREATE VIEW unknown_words AS
SELECT u.* FROM unigram u
LEFT JOIN wordform w ON w.wordform = u.wordform
WHERE
	w.wordform IS NULL AND
	u.wordform NOT LIKE 'по-%' AND
	u.wordform NOT LIKE 'най-%'
;