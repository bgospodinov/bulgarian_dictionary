CREATE TEMP TABLE _vars(key TEXT, value INTEGER);
CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- test whether all lemmata from RBE are included in the final lemma table
INSERT INTO _vars VALUES('total_rbe_lemmata_inside_lemma_table',
	(SELECT
		COUNT(*)
	FROM rbe_lemma r
	WHERE
		(
			SELECT
				COUNT(*)
			FROM lemma l
			WHERE r.lemma_with_stress = l.lemma_stressed AND r.pos = l.pos
		) > 0)
);

INSERT INTO _vars VALUES('total_rbe_lemmata',
	(SELECT
		COUNT(*)
	FROM rbe_lemma)
);

INSERT INTO _vars VALUES('total_rechko_lemmata_inside_lemma_table',
	(SELECT
		COUNT(*)
	FROM rechko_lemma r
	WHERE
		(
			SELECT
				COUNT(*)
			FROM lemma l
			WHERE r.name_stressed = l.lemma_stressed AND r.pos = l.pos
		) > 0)
);

INSERT INTO _vars VALUES('total_rechko_lemmata',
	(SELECT
		COUNT(*)
	FROM rechko_lemma)
);

INSERT INTO _vars VALUES('total_slovnik_lemmata_inside_lemma_table', (
	SELECT
		COUNT(*)
	FROM slovnik_wordform s
	WHERE is_lemma = 1 AND
	(
		SELECT
			COUNT(*)
		FROM lemma l
		WHERE s.lemma = l.lemma AND s.pos = l.pos
	) > 0
));

INSERT INTO _vars VALUES('total_slovnik_lemmata',
	(SELECT
		COUNT(*)
	FROM slovnik_wordform s
	WHERE is_lemma = 1)
);

-- should be 0
INSERT INTO _res VALUES('missing_rbe_lemmata', (SELECT value FROM _vars WHERE key = 'total_rbe_lemmata') - (SELECT value FROM _vars WHERE key = 'total_rbe_lemmata_inside_lemma_table'));

-- should be 0
INSERT INTO _res VALUES('missing_rechko_lemmata', (SELECT value FROM _vars WHERE key = 'total_rechko_lemmata') - (SELECT value FROM _vars WHERE key = 'total_rechko_lemmata_inside_lemma_table'));

-- should be 0
INSERT INTO _res VALUES('missing_slovnik_lemmata', (SELECT value FROM _vars WHERE key = 'total_slovnik_lemmata') - (SELECT value FROM _vars WHERE key = 'total_slovnik_lemmata_inside_lemma_table'));

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

SELECT * FROM _res;

DROP TABLE _vars;
DROP TABLE _res;
