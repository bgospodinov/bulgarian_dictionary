-- adds trivial stress to monosyllabic words
UPDATE lemma SET lemma_stressed = stress_first_syllable(lemma) WHERE num_syllables = 1;