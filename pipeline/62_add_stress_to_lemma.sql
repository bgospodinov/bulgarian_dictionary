BEGIN TRANSACTION;

-- adds trivial stress to monosyllabic words
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma_stressed, 1)
WHERE num_syllables = 1 AND stressed = 0;

-- adds stress to diminutive lemmata
UPDATE lemma
SET lemma_stressed = 
        stress_syllable(lemma.lemma_stressed, 
            find_nth_stressed_syllable_rev(
                IFNULL(
                    (SELECT l2.lemma_stressed FROM lemma l2 WHERE l2.lemma_id = lemma.derivative_id AND l2.stressed = 1),
                    lemma.lemma_stressed
                ), 1
            )
        )
WHERE lemma.derivative_type = 'diminutive' AND
    lemma.stressed = 0 AND
    lemma.derivative_id IS NOT NULL;

END TRANSACTION;