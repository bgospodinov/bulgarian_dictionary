BEGIN TRANSACTION;

-- copy stress from stressed lemmata to their corresponding wordform after additional lemmata have been stressed
UPDATE wordform
SET wordform_stressed =
    IFNULL(
        (SELECT lemma_stressed FROM lemma WHERE lemma_id = wordform.lemma_id AND num_stresses > 0),
        wordform_stressed
    )
WHERE num_stresses = 0 AND is_lemma = 1;

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
                'ръб', 'ръст', 'слух', 'срам', 'смях', 'сняг') AND pos = 'N' -- false negatives
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

-- words with both stresses: дар, дроб, грък, влас
-- чинове, дробове, клонове, колове, родове

END TRANSACTION;