CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- should be 0
INSERT INTO _res VALUES('missing_rechko_wordforms', (
	SELECT
		COUNT(*)
	FROM rechko_wordform r
	WHERE
		(
			SELECT
				COUNT(*)
			FROM wordform w
			WHERE r.wordform = w.wordform AND r.lemma_id = w.lemma_id
		) = 0
));

-- should be 0
INSERT INTO _res VALUES('missing_slovnik_wordforms', (
	SELECT
		COUNT(*)
	FROM slovnik_wordform s
	WHERE
		(
			SELECT
				COUNT(*)
			FROM wordform w
			WHERE s.wordform = w.wordform AND s.tag = w.tag
		) = 0
));

-- test whether wordforms containing ь or й have their syllables counted correctly
-- should be 1
INSERT INTO _res VALUES('гьол_number_of_syllables', (SELECT num_syllables FROM wordform WHERE wordform = 'гьол'));

-- should be 1
INSERT INTO _res VALUES('байк_number_of_syllables', (SELECT num_syllables FROM wordform WHERE wordform = 'байк'));

-- should be 2
INSERT INTO _res VALUES('брейкбийт_number_of_syllables', (SELECT num_syllables FROM wordform WHERE wordform = 'брейкбийт'));

-- should be 3
INSERT INTO _res VALUES('айнщайний_number_of_syllables', (SELECT num_syllables FROM wordform WHERE wordform = 'айнщайний'));

-- should be 3
INSERT INTO _res VALUES('Албион_number_of_syllables', (SELECT num_syllables FROM wordform WHERE wordform = 'Албион'));

-- should be 3
INSERT INTO _res VALUES('Узунов_number_of_syllables', (SELECT num_syllables FROM wordform WHERE wordform = 'Узунов'));

-- should be 0
INSERT INTO _res VALUES('number_of_wordforms_containing_latin_o', (SELECT COUNT(*) FROM wordform WHERE wordform LIKE '%o%'));

-- should be 0
INSERT INTO _res VALUES("number_of_wordforms_without_lemma", (SELECT COUNT(*) FROM wordform WHERE lemma_id IS NULL));

-- should be 0
INSERT INTO _res VALUES("number_of_—_wordforms", (SELECT COUNT(*) FROM wordform WHERE wordform = '—'));

INSERT INTO _res VALUES("number_of_wordforms", (SELECT COUNT(*) FROM wordform));

SELECT * FROM _res;
DROP TABLE _res;
