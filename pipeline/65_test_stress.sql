CREATE TEMP TABLE _vars(key TEXT, value INTEGER);
CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- should be 0
INSERT INTO _res VALUES('monosyllabic_lemmata_without_stress', (SELECT COUNT(*) FROM lemma WHERE num_syllables = 1) - (SELECT COUNT(*) FROM lemma WHERE num_syllables = 1 and lemma_stressed like '%`%'));

-- should be 0
INSERT INTO _res VALUES('wordforms_that_dont_match_their_lemma_stress', (SELECT
	COUNT(*)
from lemma l
left join wordform w ON l.lemma_id = w.lemma_id AND w.is_lemma = 1
where lemma_stressed like '%`%' and l.lemma_stressed != w.wordform_stressed));

SELECT * FROM _res;

DROP TABLE _vars;
DROP TABLE _res;
