-- adds trivial stress to monosyllabic words
UPDATE lemma SET lemma_stressed = stress_syllable(lemma_stressed, 1) WHERE num_syllables = 1;
UPDATE wordform SET wordform_stressed = stress_syllable(wordform_stressed, 1) WHERE num_syllables = 1;

-- adds stress to diminutive lemmata
/*UPDATE lemma l1
SET l1.lemma_stressed = stress_syllable(l1.lemma_stressed, )
LEFT JOIN lemma l2
ON l1.derivative_id = l2.lemma_id
WHERE l1.derivative_type = 'diminutive' AND
l1.derivative_id IS NOT NULL AND
l2.stressed = 1;*/
