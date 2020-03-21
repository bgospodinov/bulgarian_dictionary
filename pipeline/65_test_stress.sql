CREATE TEMP TABLE _vars(key TEXT, value INTEGER);
CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- should be 0
INSERT INTO _res VALUES('monosyllabic_lemmata_without_stress', (SELECT COUNT(*) FROM lemma WHERE num_syllables = 1) - (SELECT COUNT(*) FROM lemma WHERE num_syllables = 1 AND lemma_stressed LIKE '%`%'));

-- should be 0
INSERT INTO _res VALUES('wordforms_that_dont_match_their_lemma_stress', (SELECT
	COUNT(*)
FROM lemma l
LEFT JOIN wordform w ON l.lemma_id = w.lemma_id AND w.is_lemma = 1
WHERE lemma_stressed LIKE '%`%' AND l.lemma_stressed != w.wordform_stressed));

-- should be 0
INSERT INTO _res VALUES('number_of_lemma_stress_mismatches', (SELECT COUNT(*) FROM lemma WHERE lemma != REPLACE(lemma_stressed, '`', '')));

-- should be 0
INSERT INTO _res VALUES("number_of_wordform_stress_mismatches", (SELECT COUNT(*) FROM wordform WHERE wordform != REPLACE(wordform_stressed, '`', '')));

SELECT * FROM _res;

DROP TABLE _vars;
DROP TABLE _res;
