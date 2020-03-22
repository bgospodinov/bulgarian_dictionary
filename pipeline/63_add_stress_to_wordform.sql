BEGIN TRANSACTION;

-- copy stress from stressed lemmata to their corresponding wordform after additional lemmata have been stressed
UPDATE wordform
SET wordform_stressed =
    IFNULL(
        (SELECT lemma_stressed FROM lemma WHERE lemma_id = wordform.lemma_id AND stressed = 1),
        wordform_stressed
    )
WHERE stressed = 0 and is_lemma = 1;

END TRANSACTION;