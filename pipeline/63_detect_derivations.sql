BEGIN TRANSACTION;

DROP TABLE IF EXISTS derivation;
CREATE TABLE derivation(
	derivative_id INTEGER PRIMARY KEY,
	parent_id INTEGER,
	child_id INTEGER,
	type TEXT,
	FOREIGN KEY(parent_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE,
	FOREIGN KEY(child_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_derivation_parent_id_child_id_type ON derivation(parent_id, child_id, type);

-- detect diminutives
INSERT INTO derivation (parent_id, child_id, type)
SELECT
	l2.lemma_id as parent_id,
	l1.lemma_id as child_id,
	'diminutive' as type
FROM lemma l1
INNER JOIN lemma l2 ON l2.lemma = DIMINUTIVE_TO_BASE(l1.lemma) AND l1.lemma_id != l2.lemma_id
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
INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
WHERE
	l1.lemma IN ('чета', 'плета') AND
	l1.pos LIKE 'V%' AND
	l2.lemma LIKE '%' || l1.lemma
UNION ALL SELECT
	l1.lemma_id AS parent_id,
	l2.lemma_id AS child_id,
	'verb-to-verb' AS type
FROM lemma l1
INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
WHERE
	l1.lemma_stressed IN ('я`м') AND
	l1.pos LIKE 'V%' AND
	l2.lemma_stressed LIKE '%' || l1.lemma_stressed
;

-- add nouns derived from other nouns
INSERT INTO derivation (parent_id, child_id, type)
SELECT *, 'noun-to-noun' FROM
(
	SELECT
		l1.lemma_id AS parent_id,
		l2.lemma_id AS child_id
	FROM lemma l1
	INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
	WHERE
		l1.lemma IN ('сън', 'смях', 'глад', 'град', 'дял', 'звук', 'кръг',
		'труд', 'бог', 'клас', 'прах', 'страх', 'час', 'мост', 'мъж', 'крал') AND
		l1.lemma_id NOT IN (321) AND
		l1.pos LIKE 'N%' AND
		l2.lemma_stressed LIKE '%' || l1.lemma_stressed
	-- век
	UNION ALL SELECT 159, 750
	UNION ALL SELECT 159, 448
	-- вид
	UNION ALL SELECT 166, 740
	-- глас
	UNION ALL SELECT 234, 596
	UNION ALL SELECT 234, 34169
	-- стил
	UNION ALL SELECT 974, 381
	UNION ALL SELECT 974, 744
);

-- add пра- derivations
INSERT INTO derivation (parent_id, child_id, type)
SELECT *, 'pra1' FROM
(
	SELECT
		l1.lemma_id AS parent_id,
		l2.lemma_id AS child_id
	FROM lemma l1
	INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
	WHERE l1.lemma = SUBSTR(l2.lemma, 4) AND
		l2.lemma IN ('прадревен', 'праисторичен', 'правнучка', 'праисторийка', 'прапрабаба',
		'прародителка', 'прароднина', 'прабиблейски', 'прагермански', 'прадядовски',
		'прародителски', 'пратюркски', 'прачовешки', 'праобраз', 'праокеан', 'прабабче',
		'прабългарче', 'правнуче', 'праизворче', 'праобразче', 'праокеанче', 'прарелигия',
		'працивилизация', 'прабългарка', 'правнук', 'праисторик', 'праплеменник',
		'прачовек', 'праобитател', 'прародител', 'прамайка', 'правуйчо', 'прачичо',
		'прахора', 'пралеля', 'прабългари', 'правнука', 'правнуче', 'прадеден',
		'прадядов', 'прадядовски', 'прамайка', 'праотчески')
);

INSERT INTO derivation (parent_id, child_id, type)
SELECT *, 'pra2' FROM
(
	SELECT
		l1.lemma_id AS parent_id,
		l2.lemma_id AS child_id
	FROM lemma l1
	INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
	WHERE l1.lemma = SUBSTR(l2.lemma, 4) AND
		l2.lemma IN ('прапрароднина', 'праправнуче', 'прапрародител', 'прапрадеди',
	'прапрачичо', 'прапралеля','прапрабаба', 'праправнук',
	'праправнучка', 'прапрадядо')
);

INSERT INTO derivation (parent_id, child_id, type)
SELECT *, 'pra3' FROM
(
	SELECT
		l1.lemma_id AS parent_id,
		l2.lemma_id AS child_id
	FROM lemma l1
	INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
	WHERE l1.lemma = SUBSTR(l2.lemma, 4) AND
		l2.lemma IN ('прапраправнучка', 'прапраправнук', 'прапрапрабаба', 'прапрапрадядо')
);

INSERT INTO derivation (parent_id, child_id, type)
SELECT *, 'pra4' FROM
(
	SELECT
		l1.lemma_id AS parent_id,
		l2.lemma_id AS child_id
	FROM lemma l1
	INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
	WHERE l1.lemma = SUBSTR(l2.lemma, 4) AND
		l2.lemma IN ('прапрапрапрадядо',  'прапрапрапрабаба')
);

-- add свръх- derivations
INSERT INTO derivation (parent_id, child_id, type)
SELECT *, 'svryh' FROM
(
	SELECT
		l1.lemma_id AS parent_id,
		l2.lemma_id AS child_id
	FROM lemma l1
	INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
	WHERE l1.lemma = SUBSTR(l2.lemma, 6) AND
		l2.lemma LIKE 'свръх%'
);

-- add контра- derivations
INSERT INTO derivation (parent_id, child_id, type)
SELECT *, 'kontra' FROM
(
	SELECT
		l1.lemma_id AS parent_id,
		l2.lemma_id AS child_id
	FROM lemma l1
	INNER JOIN lemma l2 ON l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
	WHERE l1.lemma = SUBSTR(l2.lemma, 7) AND
		l2.lemma LIKE 'контра%' AND l2.lemma NOT IN
		('контрастен', 'контракт', 'контраст', 'контракция',
		'контрастно', 'контрактче', 'контрастче')
);

END TRANSACTION;
