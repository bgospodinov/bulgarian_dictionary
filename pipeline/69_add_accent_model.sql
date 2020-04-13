UPDATE lemma
SET accent_model = accent_model(lemma_stressed)
WHERE num_stresses > 0;

UPDATE wordform
SET accent_model = accent_model(wordform_stressed)
WHERE num_stresses > 0;