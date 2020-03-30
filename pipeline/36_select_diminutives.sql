BEGIN TRANSACTION;

UPDATE
	lemma
SET
	derivative_type = 'diminutive',
	derivative_id = (SELECT l1.lemma_id FROM lemma l1 WHERE l1.lemma = DIMINUTIVE_TO_BASE(lemma.lemma) AND l1.pos LIKE 'N%' ORDER BY num_stresses DESC LIMIT 1)
WHERE
	derivative_id IS NULL AND
	pos LIKE 'N%' AND
	ner IS NULL AND
	(
		(lemma like '%че') OR
		(lemma like '%це') OR
		(lemma like '%йка') OR
		(lemma like '%чица')
	)
;

END TRANSACTION;
