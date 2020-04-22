BEGIN TRANSACTION;

-- removes reflexivity from murdarov
UPDATE murdarov_lemma
SET
    lemma = SUBSTR(lemma, 1, LENGTH(lemma) - 3),
    lemma_stressed = SUBSTR(lemma_stressed, 1, LENGTH(lemma_stressed) - 3)
WHERE lemma LIKE '% се';

-- update existing lemmata with stresses from murdarov
UPDATE lemma
SET lemma_stressed =
        IFNULL((SELECT lemma_stressed FROM murdarov_lemma m WHERE m.lemma = lemma.lemma), lemma.lemma_stressed);

-- insert missing lemmata
INSERT INTO lemma (
	lemma, lemma_stressed, pos, source, num_syllables
) SELECT
    lemma,
    lemma_stressed,
    NULL AS pos,
    'murdarov' as source,
    COUNT_SYLLABLES(lemma) as num_syllables
FROM murdarov_lemma m
WHERE NOT EXISTS(SELECT lemma_id FROM lemma l WHERE m.lemma = l.lemma);

END TRANSACTION;