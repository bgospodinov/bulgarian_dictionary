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

-- add stress to words starting with пра-
WITH pra1 AS (
	SELECT * FROM derivation LEFT JOIN lemma ON lemma.lemma_id = derivation.parent_id WHERE type = 'pra1'
)
    UPDATE lemma
	SET lemma_stressed = 'пра`' || (SELECT pra1.lemma_stressed FROM pra1 WHERE pra1.child_id = lemma.lemma_id)
    WHERE lemma.lemma_id IN (SELECT child_id FROM pra1);

WITH pra2 AS (
	SELECT * FROM derivation LEFT JOIN lemma ON lemma.lemma_id = derivation.parent_id WHERE type = 'pra2'
)
    UPDATE lemma
	SET lemma_stressed = 'пра`' || (SELECT pra2.lemma_stressed FROM pra2 WHERE pra2.child_id = lemma.lemma_id)
    WHERE lemma.lemma_id IN (SELECT child_id FROM pra2);

WITH pra3 AS (
	SELECT * FROM derivation LEFT JOIN lemma ON lemma.lemma_id = derivation.parent_id WHERE type = 'pra3'
)
    UPDATE lemma
	SET lemma_stressed = 'пра`' || (SELECT pra3.lemma_stressed FROM pra3 WHERE pra3.child_id = lemma.lemma_id)
    WHERE lemma.lemma_id IN (SELECT child_id FROM pra3);

WITH pra4 AS (
	SELECT * FROM derivation LEFT JOIN lemma ON lemma.lemma_id = derivation.parent_id WHERE type = 'pra4'
)
    UPDATE lemma
	SET lemma_stressed = 'пра`' || (SELECT pra4.lemma_stressed FROM pra4 WHERE pra4.child_id = lemma.lemma_id)
    WHERE lemma.lemma_id IN (SELECT child_id FROM pra4);

-- add stress to words starting with свръх-
UPDATE lemma SET lemma_stressed = stress_syllable(lemma_stressed, 1)
WHERE lemma_stressed LIKE 'свръх%' AND num_stresses > 0;

WITH svryh AS (
	SELECT * FROM derivation LEFT JOIN lemma ON lemma.lemma_id = derivation.parent_id WHERE type = 'svryh'
)
    UPDATE lemma
	SET lemma_stressed = 'свръ`х' || (SELECT svryh.lemma_stressed FROM svryh WHERE svryh.child_id = lemma.lemma_id)
    WHERE lemma.lemma_id IN (SELECT child_id FROM svryh) AND lemma.num_stresses = 0;

-- add stress to words starting with контра-
UPDATE lemma SET lemma_stressed = stress_syllable(lemma_stressed, 1)
WHERE lemma_stressed LIKE 'контра%' AND num_stresses > 0;

WITH kontra AS (
	SELECT * FROM derivation LEFT JOIN lemma ON lemma.lemma_id = derivation.parent_id WHERE type = 'kontra'
)
    UPDATE lemma
	SET lemma_stressed = 'ко`нтра' || (SELECT kontra.lemma_stressed FROM kontra WHERE kontra.child_id = lemma.lemma_id)
    WHERE lemma.lemma_id IN (SELECT child_id FROM kontra) AND lemma.num_stresses = 0;

-- TODO: stress the roots of disyllabic verbs by removing common prefixes and suffixes

END TRANSACTION;