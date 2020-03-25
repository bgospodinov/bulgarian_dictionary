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

-- deal with masculine monosyllabic nouns where stress moves away from the root
-- deal with articles
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 1)
WHERE lemma_id IN
    (SELECT lemma_id FROM lemma WHERE pos = 'N' AND num_syllables = 1 AND definition LIKE '%ъ`т%') AND
    (tag LIKE 'N__sh' OR tag LIKE 'N__sf');

-- and with plural
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 2)
WHERE lemma_id IN
    (SELECT lemma_id FROM lemma WHERE pos = 'N' AND num_syllables = 1 AND (definition LIKE '%ове` %' OR definition LIKE '%ове`,%')) AND
    (tag LIKE 'N__pi' OR tag LIKE 'N__pd');

END TRANSACTION;