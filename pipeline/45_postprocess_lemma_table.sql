BEGIN TRANSACTION;

-- deletes duplicate names
DELETE FROM lemma WHERE ROWID IN (
	SELECT ROWID FROM (
		SELECT ROWID, ROW_NUMBER() OVER(PARTITION BY lemma, pos) AS rownum FROM lemma WHERE pos = 'H'
	)
	WHERE rownum > 1
);

-- insert some archetype verbs such as 'лека', which will be used to establish derivation relationships later
INSERT INTO lemma (lemma, lemma_stressed, definition, comment, pos, num_syllables)
VALUES('лека', 'лека`', 'archetype', 'archetype', 'V', 2);

-- insert lemmata without wordforms into wordform table
INSERT INTO wordform (lemma_id, wordform, wordform_stressed, is_lemma, tag, num_syllables, source)
SELECT
	l.lemma_id,
	l.lemma,
	l.lemma_stressed,
	1,
	l.pos || CASE
		WHEN l.pos LIKE 'Nc%' THEN 'si'
		WHEN l.pos = 'Np' THEN '-si'
		WHEN l.pos = 'A' THEN 'msi'
		WHEN l.pos = 'M' THEN 'c-si'
		WHEN l.pos = 'D' THEN '-'
		WHEN l.pos LIKE 'V%' THEN 'pitf-r1s'
	END AS tag,
	COUNT_SYLLABLES(l.lemma),
	l.source
FROM lemma l
LEFT JOIN wordform w ON l.lemma_id = w.lemma_id
WHERE w.lemma_id IS NULL;

END TRANSACTION;