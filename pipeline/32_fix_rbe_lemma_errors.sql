BEGIN TRANSACTION;
UPDATE rbe_lemma SET lemma = 'войнстващ', lemma_with_stress = 'во`йнстващ' WHERE lemma = 'войнстващ  войнствуващ';
UPDATE rbe_lemma SET lemma = 'бъх' WHERE lemma = 'бъ х';
UPDATE rbe_lemma SET lemma_with_stress = 'га`' WHERE lemma = 'га';
UPDATE rbe_lemma SET pos = 'N' WHERE lemma = 'гъзар' and pos = 'V';
END TRANSACTION;