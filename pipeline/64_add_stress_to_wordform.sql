BEGIN TRANSACTION;

-- copy stress from stressed lemmata to their corresponding wordform after additional lemmata have been stressed
UPDATE wordform
SET wordform_stressed =
    IFNULL(
        (SELECT lemma_stressed FROM lemma WHERE lemma_id = wordform.lemma_id AND num_stresses > 0),
        wordform_stressed
    )
WHERE num_stresses = 0 AND is_lemma = 1;

-- adds trivial stress to monosyllabic wordforms
UPDATE wordform
SET wordform_stressed = stress_syllable(wordform_stressed, 1)
WHERE num_syllables = 1 AND num_stresses = 0;

-- by default, stress all non-lemma wordforms the same way their lemmata are stressed
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform_stressed, find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM lemma WHERE lemma_id = wordform.lemma_id), 1))
WHERE num_stresses = 0 AND is_lemma = 0;

-- deal with masculine monosyllabic nouns where stress moves away from the root to the suffixed article
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 1)
WHERE lemma_id IN
    (
        SELECT lemma_id FROM lemma WHERE pos = 'N' AND num_syllables = 1 AND 
                    (definition LIKE '%ъ`т%' OR definition LIKE '%ъ̀т%' OR definition LIKE '%я`т,%')
                    AND lemma NOT IN ('взрив', 'кът', 'хрът') -- false positives
        UNION SELECT lemma_id FROM lemma WHERE lemma IN ('син', 'рев', 'ред', 'рид', 'род',
                'ръб', 'ръст', 'слух', 'срам', 'смях', 'сняг', 'полусън') AND pos = 'N' -- false negatives
    )
    AND (tag LIKE 'N__sh' OR tag LIKE 'N__sf');

-- and with plural ове`
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 2)
WHERE lemma_id IN
    (
        SELECT lemma_id FROM lemma l
        WHERE pos = 'N' AND num_syllables = 1 AND 
        definition LIKE ('%' || replace(replace(l.lemma, 'я', 'е'), 'ръ', 'ър') || 'ове`%') AND 
        definition NOT LIKE ('%' || replace(l.lemma_stressed, 'я', 'е') || 'ове%')
        UNION SELECT lemma_id FROM lemma WHERE lemma IN ('свят', 'сняг', 'смях', 'бой', 'рой', 'син') AND pos = 'N' -- false negatives
    )
    AND (tag LIKE 'N__pi' OR tag LIKE 'N__pd' OR (tag LIKE 'N__t' AND wordform LIKE '%ове'));

-- and with plural о`ве
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 1)
WHERE lemma_id IN
    (
        SELECT lemma_id FROM lemma l
        WHERE pos = 'N' AND num_syllables = 1 AND 
        definition LIKE ('%' || replace(replace(l.lemma, 'я', 'е'), 'ръ', 'ър') || 'о`ве%')
		AND lemma NOT IN ('бой') -- false positives
    )
    AND (tag LIKE 'N__pi' OR tag LIKE 'N__pd' OR (tag LIKE 'N__t' AND wordform LIKE '%ове'));

-- and with plural е`
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 1)
WHERE lemma_id IN (
    SELECT lemma_id FROM lemma l
    WHERE pos = 'N' AND lemma IN ('мъж', 'княз', 'цар', 'крал', 'кон')
    )
AND (tag LIKE 'N__pi' OR tag LIKE 'N__pd');

-- deal with feminite nouns that end in a consonant that move their stress when their article is suffixed
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, num_syllables)
WHERE tag LIKE 'N_fsd' AND (
    SELECT COUNT(*) FROM wordform w
    WHERE w.lemma_id = wordform.lemma_id AND w.is_lemma = 1 AND NOT is_vowel(SUBSTR(w.wordform, LENGTH(w.wordform)))
) > 0;

-- deal with feminite nouns that end in a stressed vowel 'a' or 'я' that move their stress one syllable backwards in vocative form
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, MAX(1, find_nth_stressed_syllable_rev(wordform_stressed, 1) - 1))
WHERE tag LIKE 'N_f__v' AND (
    SELECT COUNT(*) FROM wordform w
    WHERE w.lemma_id = lemma_id and is_lemma = 1 AND num_stresses > 0 AND
    (w.wordform_stressed LIKE '%а`' OR w.wordform_stressed LIKE '%я`')
) > 0;

-- deal with neuter nouns that end in an unstressed vowel 'o'
UPDATE wordform
SET wordform_stressed =
    stress_syllable(
        wordform,
        CASE WHEN tag LIKE 'N_npi'
        THEN num_syllables
        ELSE
            -- always stress the suffix syllable with the article
            (SELECT w1.num_syllables FROM wordform w1 WHERE w1.lemma_id = wordform.lemma_id and w1.tag LIKE 'N_npi')
        END
    )
WHERE tag LIKE 'N_np_' AND ((
    SELECT COUNT(*) FROM wordform w
    WHERE w.lemma_id = wordform.lemma_id AND w.is_lemma = 1 AND w.wordform_stressed LIKE '%о'
) > 0);

-- deal with nouns whose plural ends in 'ена'
UPDATE wordform
SET wordform_stressed = stress_syllable(wordform, num_syllables)
WHERE lemma_id IN (SELECT lemma_id FROM wordform WHERE (wordform LIKE '%ена' OR wordform LIKE '%еса') AND tag = 'Ncnpi') AND tag = 'Ncnpi';

UPDATE wordform
SET wordform_stressed = stress_syllable(wordform, num_syllables - 1)
WHERE lemma_id IN (SELECT lemma_id FROM wordform WHERE (wordform LIKE '%ена' OR wordform LIKE '%еса') AND tag = 'Ncnpi') AND tag = 'Ncnpd';

-- deal with numerals after "three" where the suffixed article receives the stress e.g. chetirite`
UPDATE wordform
SET wordform_stressed = stress_syllable(wordform, num_syllables)
WHERE (tag like 'Mc_pd' or tag like 'Mc_ph' or tag like 'Mc_pf') AND 
lemma_id NOT IN (102896, 102897, 102898, 102947, 102948, 102949, 102950, 102951) AND
wordform LIKE '%те' AND wordform NOT IN ('тринките', 'тричките');

UPDATE wordform
SET wordform_stressed = stress_syllable(wordform, CASE WHEN tag LIKE '%i' THEN num_syllables - 1 ELSE num_syllables - 2 END)
WHERE (tag like 'Mc-s_' or tag like 'My-p_') and lemma_id not in (102897, 102898, 102947, 102948, 102949, 102950, 102951);

-- deal with the numeral хи`ляди
UPDATE wordform
SET wordform_stressed = stress_syllable(wordform, 1)
WHERE lemma_id = 102948 AND wordform like 'хиляди%';

-- deal with prepositions
UPDATE wordform SET wordform = 'ѝ', wordform_stressed = 'ѝ`' WHERE wordform = 'й' and num_stresses = 0;

END TRANSACTION;