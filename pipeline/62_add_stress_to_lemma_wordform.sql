-- adds trivial stress to monosyllabic words
UPDATE lemma SET lemma_stressed = stress_syllable(lemma_stressed, 1) WHERE num_syllables = 1;
UPDATE wordform SET wordform_stressed = stress_syllable(wordform_stressed, 1) WHERE num_syllables = 1;

-- adds stress to diminutives
