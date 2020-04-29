BEGIN TRANSACTION;

-- removes reflexivity from murdarov
UPDATE murdarov_lemma
SET
    lemma = SUBSTR(lemma, 1, LENGTH(lemma) - 3),
    lemma_stressed = SUBSTR(lemma_stressed, 1, LENGTH(lemma_stressed) - 3),
    pos = 'Vr'
WHERE lemma LIKE '% се';

-- separates words that have two possiblе stresses
CREATE TEMP TABLE lemmata_with_two_possible_stresses AS
VALUES ('про`ми`л'), ('по`дку`м'), ('о`ке`й');

INSERT INTO murdarov_lemma (lemma, lemma_stressed)
SELECT
    lemma, remove_last_char(lemma_stressed, '`')
FROM murdarov_lemma
WHERE lemma_stressed IN (
    SELECT * FROM lemmata_with_two_possible_stresses
);

UPDATE murdarov_lemma
SET lemma_stressed = remove_first_char(lemma_stressed, '`')
WHERE lemma_stressed IN (
    SELECT * FROM lemmata_with_two_possible_stresses
);

DROP TABLE lemmata_with_two_possible_stresses;

-- update existing lemmata with stresses from murdarov
UPDATE lemma
SET lemma_stressed =
        IFNULL((SELECT lemma_stressed FROM murdarov_lemma m WHERE m.lemma = lemma.lemma), lemma.lemma_stressed),
    source = source || ', murdarov'
WHERE EXISTS(SELECT lemma_stressed FROM murdarov_lemma m WHERE m.lemma = lemma.lemma);

-- insert missing lemmata
INSERT INTO lemma (
	lemma, lemma_stressed, pos, source, num_syllables
) SELECT
    lemma,
    lemma_stressed,
    pos,
    'murdarov' as source,
    COUNT_SYLLABLES(lemma) as num_syllables
FROM murdarov_lemma m
WHERE NOT EXISTS(SELECT lemma_id FROM lemma l WHERE m.lemma_stressed = l.lemma_stressed);

END TRANSACTION;