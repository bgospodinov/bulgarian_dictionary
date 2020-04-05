BEGIN TRANSACTION;

DROP TABLE IF EXISTS derivation;
CREATE TABLE derivation(
	derivative_id INTEGER PRIMARY KEY,
	parent_id INTEGER,
	child_id INTEGER,
	type CHAR,
	FOREIGN KEY(parent_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE,
	FOREIGN KEY(child_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_derivation_parent_id_child_id ON derivation(parent_id, child_id);

INSERT INTO derivation (parent_id, child_id, type)
SELECT
	l2.lemma_id as parent_id,
	l1.lemma_id as child_id,
	'diminutive' as type
FROM lemma l1
INNER JOIN lemma l2 ON l2.lemma = DIMINUTIVE_TO_BASE(l1.lemma)
WHERE
	l1.pos LIKE 'N%' AND l2.pos LIKE 'N%' AND l1.ner IS NULL AND
	(
		(l1.lemma LIKE '%че') OR
		(l1.lemma LIKE '%це') OR
		(l1.lemma LIKE '%йка') OR
		(l1.lemma LIKE '%чица')
	)
;

END TRANSACTION;
