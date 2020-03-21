-- capitalize stressed lemmata whose unstressed attributes are uppercase, so that they match letter for letter
UPDATE lemma
SET lemma_stressed = SUBSTR(lemma, 1, 1) || SUBSTR(lemma_stressed, 2)
WHERE lemma != replace(lemma_stressed, '`', '');

UPDATE wordform
SET wordform_stressed = SUBSTR(wordform, 1, 1) || SUBSTR(wordform_stressed, 2)
WHERE
    wordform != replace(wordform_stressed, '`', '') AND
    UNICODE(wordform_stressed) - 32 == UNICODE(wordform)
;