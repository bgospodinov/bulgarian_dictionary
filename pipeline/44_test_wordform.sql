CREATE TEMP TABLE _vars(key TEXT, value INTEGER);
CREATE TEMP TABLE _res(key TEXT, value INTEGER);

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

SELECT * FROM _res;

DROP TABLE _vars;
DROP TABLE _res;
