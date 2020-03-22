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

END TRANSACTION;