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
			WHERE r.lemma_with_stress = l.name_stressed AND r.pos = l.pos
		) > 0)
);

INSERT INTO _vars VALUES('total_rbe_lemmata',
	(SELECT
		COUNT(*)
	FROM rbe_lemma)
);

-- should be 0
INSERT INTO _res VALUES('missing_rbe_lemmata', (SELECT value FROM _vars WHERE key = 'total_rbe_lemmata') - (SELECT value FROM _vars WHERE key = 'total_rbe_lemmata_inside_lemma_table'));

-- test whether there are lemmata with NULL stress columns
-- should be 0
INSERT INTO _res VALUES('lemmata_without_stress', (SELECT COUNT(*) FROM lemma WHERE name_stressed IS NULL));

SELECT * FROM _res;

DROP TABLE _vars;
DROP TABLE _res;
