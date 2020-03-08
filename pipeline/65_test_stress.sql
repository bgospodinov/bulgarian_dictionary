CREATE TEMP TABLE _vars(key TEXT, value INTEGER);
CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- should be 0
INSERT INTO _res VALUES('monosyllabic_lemmata_without_stress', (SELECT COUNT(*) FROM lemma WHERE num_syllables = 1) - (SELECT COUNT(*) FROM lemma WHERE num_syllables = 1 and lemma_stressed like '%`%'));

SELECT * FROM _res;

DROP TABLE _vars;
DROP TABLE _res;
