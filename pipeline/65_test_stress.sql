CREATE TEMP TABLE _vars(key TEXT, value INTEGER);
CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- should be 0
INSERT INTO _res VALUES('monosyllabic_lemmata_without_stress', 
	(SELECT COUNT(*) FROM lemma WHERE num_syllables = 1) - 
	(SELECT COUNT(*) FROM lemma WHERE num_syllables = 1 AND lemma_stressed LIKE '%`%'));

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

-- should be 0
INSERT INTO _res VALUES("false_positive_stressed_lemma", (SELECT COUNT(*) FROM lemma WHERE stressed = 0 AND lemma_stressed LIKE '%`%'));

-- should be 0
INSERT INTO _res VALUES("false_positive_stressed_wordform", (SELECT COUNT(*) FROM wordform WHERE stressed = 0 AND wordform_stressed LIKE '%`%'));

-- should be 4
INSERT INTO _res VALUES("абориге`н_stress_first_pos", (SELECT find_nth_stressed_syllable('абориге`н', 1)));

-- should be 4
INSERT INTO _res VALUES("абориге`н_stress_first_pos_rev", (SELECT find_nth_stressed_syllable_rev('абориге`н', 1)));

-- should be 1
INSERT INTO _res VALUES("о`гненочерве`н_stress_first_pos", (SELECT find_nth_stressed_syllable('о`гненочерве`н', 1)));

-- should be 5
INSERT INTO _res VALUES("о`гненочерве`н_stress_second_pos", (SELECT find_nth_stressed_syllable('о`гненочерве`н', 2)));

-- should be 5
INSERT INTO _res VALUES("о`гненочерве`н_stress_first_pos_rev", (SELECT find_nth_stressed_syllable_rev('о`гненочерве`н', 1)));

-- should be 1
INSERT INTO _res VALUES("о`гненочерве`н_stress_second_pos_rev", (SELECT find_nth_stressed_syllable_rev('о`гненочерве`н', 2)));

-- should be -1
INSERT INTO _res VALUES("чук-чук_stress_first_pos", (SELECT find_nth_stressed_syllable('чук-чук', 1)));

-- should be -1
INSERT INTO _res VALUES("чук-чук_stress_first_pos_rev", (SELECT find_nth_stressed_syllable_rev('чук-чук', 1)));

-- should be -1
INSERT INTO _res VALUES("ч`ук-чук_stress_second_pos", (SELECT find_nth_stressed_syllable('ч`ук-чук', 2)));

-- should be -1
INSERT INTO _res VALUES("ч`ук-чук_stress_second_pos_rev", (SELECT find_nth_stressed_syllable_rev('ч`ук-чук', 2)));

-- should be 0
INSERT INTO _res VALUES("МВР_stress_first_pos", (SELECT find_nth_stressed_syllable('МВР', 1)));

-- should be 0
INSERT INTO _res VALUES("МВР_stress_first_pos_rev", (SELECT find_nth_stressed_syllable_rev('МВР', 1)));

-- should be 0
INSERT INTO _res VALUES("М`ВР_stress_first_pos", (SELECT find_nth_stressed_syllable('М`ВР', 1)));

-- should be 0
INSERT INTO _res VALUES("М`ВР_stress_first_pos_rev", (SELECT find_nth_stressed_syllable_rev('М`ВР', 1)));

-- should be чуде`сно
INSERT INTO _res VALUES("чудесно_stress_second_syllable", (SELECT stress_syllable('чудесно', 2)));

-- should be чудесно
INSERT INTO _res VALUES("чудесно_stress_negative_syllable", (SELECT stress_syllable('чудесно', -2)));

-- should be чудесно
INSERT INTO _res VALUES("чудесно_stress_out_of_bound_syllable", (SELECT stress_syllable('чудесно', 22)));

SELECT * FROM _res;

DROP TABLE _vars;
DROP TABLE _res;
