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

-- detect diminutives
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

-- add verbs derived from other verbs
INSERT INTO derivation (parent_id, child_id, type)
SELECT
	l1.lemma_id AS parent_id,
	l2.lemma_id AS child_id,
	'verb-to-verb' AS type
FROM lemma l1
INNER JOIN lemma l2 ON l1.pos = l2.pos
WHERE
	l1.lemma IN ('чета', 'плета') AND
	l1.pos = 'V' AND
	l2.lemma LIKE '%' || l1.lemma
UNION ALL SELECT
	l1.lemma_id AS parent_id,
	l2.lemma_id AS child_id,
	'verb-to-verb' AS type
FROM lemma l1
INNER JOIN lemma l2 ON l1.pos = l2.pos
WHERE
	l1.lemma_stressed IN ('я`м') AND
	l1.pos = 'V' AND
	l2.lemma_stressed LIKE '%' || l1.lemma_stressed
;

END TRANSACTION;
