-- adds trivial stress to monosyllabic words
UPDATE lemma SET lemma_stressed = stress_first_syllable(lemma_stressed) WHERE num_syllables = 1;
UPDATE wordform SET wordform_stressed = stress_first_syllable(wordform_stressed) WHERE num_syllables = 1;

-- adds stress to diminutives
