CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- should be 0
INSERT INTO _res VALUES('missing_rbe_lemmata',
	(SELECT COUNT(*) FROM rbe_lemma r WHERE NOT EXISTS(SELECT lemma_id FROM lemma l WHERE r.lemma = l.lemma AND r.pos = l.pos))
);

-- should be 0
INSERT INTO _res VALUES('missing_rechko_lemmata',
	(SELECT COUNT(*) FROM rechko_lemma r WHERE NOT EXISTS(SELECT lemma_id FROM lemma l WHERE r.name = l.lemma AND r.pos = l.pos))
);

-- should be 0
INSERT INTO _res VALUES('missing_slovnik_lemmata',
	(SELECT COUNT(*) FROM slovnik_wordform s WHERE NOT EXISTS(SELECT lemma_id FROM lemma l WHERE s.lemma = l.lemma AND s.pos = l.pos) AND s.is_lemma = 1)
);

-- should be 0
INSERT INTO _res VALUES('missing_murdarov_lemmata',
	-- make sure murdarov stress takes precedence
	(SELECT COUNT(*) FROM murdarov_lemma m WHERE NOT EXISTS(SELECT lemma_id FROM lemma l WHERE m.lemma_stressed = l.lemma_stressed))
);

-- test whether there are lemmata with NULL stress columns
-- should be 0
INSERT INTO _res VALUES('lemmata_with_null_stress_column', (SELECT COUNT(*) FROM lemma WHERE lemma_stressed IS NULL));

INSERT INTO _res VALUES("number_of_lemmata", (SELECT COUNT(*) FROM lemma));

-- should be 0
INSERT INTO _res VALUES("number_of_lemmata_without_wordforms", (
	SELECT COUNT(*) FROM lemma l
	LEFT JOIN wordform w ON l.lemma_id = w.lemma_id
	WHERE w.lemma_id IS NULL)
);

-- should be 0
INSERT INTO _res VALUES("number_of_reflexive_lemmata", (
	SELECT COUNT(*) FROM lemma WHERE lemma LIKE '% се' OR lemma LIKE '% ми' OR lemma LIKE '% си'
	)
);

SELECT * FROM _res;
DROP TABLE _res;
