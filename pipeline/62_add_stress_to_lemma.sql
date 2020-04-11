BEGIN TRANSACTION;

-- adds trivial stress to monosyllabic words
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma_stressed, 1)
WHERE num_syllables = 1 AND num_stresses = 0;

-- adds stress to murdarov lemmata that dont have it
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma_stressed, num_syllables)
WHERE source = 'murdarov' AND num_stresses = 0;

-- here we use the fact thah some suffixes are very likely (or not) to be stressed, especially as heuristic for disyllabic words
-- always stress first syllable of disyllabic adjectives ending in -ов
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ов' AND pos = 'A';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ис' AND pos LIKE 'Nc%';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ок' AND lemma_id not in (84346);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ел' AND lemma_id not in (36621, 119194);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ер';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%вед' AND pos = 'Ncm';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%въд' ;

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%яд';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ар';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%рък' AND lemma NOT LIKE '%ярък' AND pos = 'A';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ач';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%тел' AND pos != 'Np' AND lemma_id NOT IN (31436, 35036, 35790);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%еж' AND lemma_id NOT IN (33067);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables = 3 AND num_stresses = 0 AND lemma LIKE '%ница' AND lemma_id NOT IN (14735, 18621, 19087, 21069, 21097, 22700);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%нича' AND lemma_id NOT IN (96881, 102265, 100420, 100428, 180802);

-- TODO: 70% of Ncm is 01
-- TODO: 85% of Ncf is 10
-- TODO: При повече от 84% от глаголите ударението е пенултимно (ходя, чакам), а при останалите оксинонно (чета, благодаря)

END TRANSACTION;