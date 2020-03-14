BEGIN TRANSACTION;

UPDATE
	lemma
SET
	derivative_type = 'diminutive'
WHERE
	pos = 'N' AND
	stressed = 0 AND
	ner IS NULL AND
	(
		lemma like '%че' OR
		lemma like '%це' OR
		lemma like '%йка' OR
		lemma like '%чица'
	)
;

END TRANSACTION;
