CREATE TEMP TABLE _res(key TEXT, value INTEGER);

-- should be 0
INSERT INTO _res VALUES('monosyllabic_lemmata_without_stress', 
	(SELECT COUNT(*) FROM lemma WHERE num_syllables = 1 AND num_stresses = 0));

-- should be 0
INSERT INTO _res VALUES('monosyllabic_wordforms_without_stress',
	(SELECT COUNT(*) FROM wordform WHERE num_syllables = 1 AND num_stresses = 0));

-- should be 0
INSERT INTO _res VALUES('wordforms_that_dont_match_their_lemma_stress', (
SELECT
	COUNT(*)
FROM lemma l
LEFT JOIN wordform w ON l.lemma_id = w.lemma_id AND w.is_lemma = 1
WHERE lemma_stressed LIKE '%`%' AND l.lemma_stressed != w.wordform_stressed));

-- should be 0
INSERT INTO _res VALUES("lemmata_that_dont_match_their_wordform_stress", (
SELECT
	COUNT(*)
FROM lemma l
INNER JOIN wordform w ON l.lemma_id = w.lemma_id
WHERE l.num_stresses != w.num_stresses AND l.pos != 'Ncf' AND l.num_stresses > 0 AND w.pos NOT LIKE 'N__s-v'));

-- should be 0
-- check again after amending some stresses
INSERT INTO _res VALUES('missing_murdarov_lemmata',
	-- make sure murdarov stress takes precedence
	(SELECT COUNT(*) FROM murdarov_lemma m WHERE NOT EXISTS(SELECT lemma_id FROM lemma l WHERE m.lemma_stressed = l.lemma_stressed))
);

-- should be 0
INSERT INTO _res VALUES('number_of_lemma_stress_mismatches', (SELECT COUNT(*) FROM lemma WHERE lemma != REPLACE(lemma_stressed, '`', '')));

-- should be 0
INSERT INTO _res VALUES("number_of_wordform_stress_mismatches", (SELECT COUNT(*) FROM wordform WHERE wordform != REPLACE(wordform_stressed, '`', '')));

-- should be 0
INSERT INTO _res VALUES("number_of_lemma_with_double_stress", (SELECT COUNT(*) FROM lemma WHERE lemma LIKE '%``%' OR lemma_stressed LIKE '%``%'));

-- should be 0
INSERT INTO _res VALUES("number_of_wordform_with_double_stress", (SELECT COUNT(*) FROM wordform WHERE wordform LIKE '%``%' OR wordform_stressed LIKE '%``%'));

-- should be 0
INSERT INTO _res VALUES("false_positive_stressed_lemma", (SELECT COUNT(*) FROM lemma WHERE num_stresses = 0 AND lemma_stressed LIKE '%`%'));

-- should be 0
INSERT INTO _res VALUES("false_positive_stressed_wordform", (SELECT COUNT(*) FROM wordform WHERE num_stresses = 0 AND wordform_stressed LIKE '%`%'));

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

-- should be 1
INSERT INTO _res VALUES("ръба`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'ръба`'));

-- should be 1
INSERT INTO _res VALUES("ръбъ`т_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'ръбъ`т'));

-- should be 1
INSERT INTO _res VALUES("скръбта`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'скръбта`'));

-- should be 1
INSERT INTO _res VALUES("пе`дята_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'пе`дята'));

-- should be 1
INSERT INTO _res VALUES("мъже`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'мъже`'));

-- should be 1
INSERT INTO _res VALUES("върхове`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'върхове`'));

-- should be 1
INSERT INTO _res VALUES("воло`ве_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'воло`ве'));

-- should be 1
INSERT INTO _res VALUES("се`стро_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'се`стро'));

-- should be 1
INSERT INTO _res VALUES("пе`дьо_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'пе`дьо'));

-- should be 1
INSERT INTO _res VALUES("пове`льо_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'пове`льо'));

-- should be 1
INSERT INTO _res VALUES("па`ртийо_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'па`ртийо'));

-- should be 1
INSERT INTO _res VALUES("градъ`т_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'градъ`т'));

-- should be 1
INSERT INTO _res VALUES("градове`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'градове`'));

-- should be 1
INSERT INTO _res VALUES("блата`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'блата`'));

-- should be 1
INSERT INTO _res VALUES("блата`та_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'блата`та'));

-- should be 1
INSERT INTO _res VALUES("стада`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'стада`'));

-- should be 1
INSERT INTO _res VALUES("стада`та_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'стада`та'));

-- should be 1
INSERT INTO _res VALUES("семена`_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'семена`'));

-- should be 1
INSERT INTO _res VALUES("семена`та_stress", (SELECT COUNT(*) FROM wordform WHERE wordform_stressed = 'семена`та'));

-- should be 1
INSERT INTO _res VALUES("четирите`_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'четирите`'));

-- should be 1
INSERT INTO _res VALUES("четири`ма_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'четири`ма'));

-- should be 0
INSERT INTO _res VALUES("unstressed_numeral_lemmata", (SELECT COUNT(*) FROM lemma WHERE pos = 'M' and num_stresses = 0));

-- should be 1
INSERT INTO _res VALUES("че`тох_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'че`тох'));

-- should be 1
INSERT INTO _res VALUES("че`тохме_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'че`тохме'));

-- should be 1
INSERT INTO _res VALUES("че`тен_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'че`тен'));

-- should be 1
INSERT INTO _res VALUES("че`лия_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'че`лия'));

-- should be 1
INSERT INTO _res VALUES("носи`_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'носи`'));

-- should be 1
INSERT INTO _res VALUES("носе`те_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'носе`те'));

-- should be 1
INSERT INTO _res VALUES("о`рльо_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'о`рльо'));

-- should be 1
INSERT INTO _res VALUES("пе`тльо_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'пе`тльо'));

-- should be 1
INSERT INTO _res VALUES("мосто`ве_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'мосто`ве'));

-- should be 1
INSERT INTO _res VALUES("яде`м_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'яде`м'));

-- should be 1
INSERT INTO _res VALUES("а`мперчасове`_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'а`мперчасове`'));

-- should be 1
INSERT INTO _res VALUES("а`мперчасове`те_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'а`мперчасове`те'));

-- should be 1
INSERT INTO _res VALUES("и`нтернационализира`й_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'и`нтернационализира`й'));

-- should be 1
INSERT INTO _res VALUES("и`нтернационализира`йте_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'и`нтернационализира`йте'));

-- should be 1
INSERT INTO _res VALUES("не`колкоме`сечна_stress", (SELECT COUNT(*) > 0 FROM wordform WHERE wordform_stressed = 'не`колкоме`сечна'));

SELECT * FROM _res;
DROP TABLE _res;
