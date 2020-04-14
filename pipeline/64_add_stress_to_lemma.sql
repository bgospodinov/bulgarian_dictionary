BEGIN TRANSACTION;

-- adds stress to diminutive lemmata
WITH diminutive AS (
	SELECT * FROM derivation LEFT JOIN lemma ON lemma.lemma_id = derivation.parent_id WHERE type = 'diminutive'
)
	UPDATE lemma
	SET lemma_stressed = 
        stress_syllable(lemma.lemma_stressed,
            find_nth_stressed_syllable_rev(
                IFNULL(
                    (SELECT diminutive.lemma_stressed FROM diminutive
                    WHERE lemma.lemma_id = diminutive.child_id AND diminutive.num_stresses > 0
                    ORDER BY num_stresses DESC LIMIT 1),
                    lemma.lemma_stressed), 1
            )
        )
	WHERE lemma.lemma_id IN (SELECT child_id FROM diminutive) AND lemma.num_stresses = 0;

-- TODO: stress the roots of disyllabic verbs by removing common prefixes and suffixes

END TRANSACTION;