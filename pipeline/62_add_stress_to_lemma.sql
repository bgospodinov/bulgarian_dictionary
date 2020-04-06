BEGIN TRANSACTION;

-- adds trivial stress to monosyllabic words
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma_stressed, 1)
WHERE num_syllables = 1 AND num_stresses = 0;

END TRANSACTION;