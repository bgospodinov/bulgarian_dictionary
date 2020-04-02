BEGIN TRANSACTION;

-- add words with two possible stress patterns (dubletni formi)
-- дар
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'дар' LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'дарът', 'да`рът', 'Ncmsf', 2),
    ((SELECT * FROM ctx), 'дара', 'да`ра', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'дари', 'да`ри', 'Ncmt', 2),
    ((SELECT * FROM ctx), 'дари', 'да`ри', 'Ncmpi', 2);

-- дроб
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'дроб' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx LIMIT 1), 'дроба', 'дро`ба', 'Ncmsh', 2),
    ((SELECT * FROM ctx LIMIT 1), 'дробът', 'дро`бът', 'Ncmsf', 2),
    ((SELECT * FROM ctx LIMIT 1), 'дробове', 'дробове`', 'Ncmpi', 3),
    ((SELECT * FROM ctx LIMIT 1), 'дробовете', 'дробове`те', 'Ncmpd', 3);

-- грък
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'грък' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'гърка', 'гъ`рка', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'гъркът', 'гъ`ркът', 'Ncmsf', 2);

-- влас
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'влас' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'власа', 'вла`са', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'власът', 'вла`сът', 'Ncmsf', 2),
    ((SELECT * FROM ctx), 'власи', 'вла`си', 'Ncmpi', 2),
    ((SELECT * FROM ctx), 'власите', 'вла`сите', 'Ncmpd', 3),
    ((SELECT * FROM ctx), 'власове', 'вла`сове', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'власовете', 'вла`совете', 'Ncmpd', 4);

-- чин
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'чин' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'чина', 'чи`на', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'чинът', 'чи`нът', 'Ncmsf', 2);

-- клон
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'клон' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'клонища', 'кло`нища', 'Ncmpi', 3);

-- кол
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'кол' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'колове', 'ко`лове', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'коловете', 'ко`ловете', 'Ncmpd', 4);

-- род
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'род' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'родове', 'родове`', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'родовете', 'родове`те', 'Ncmpd', 4);

-- нож
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'нож' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'ножове', 'но`жове', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'ножовете', 'но`жовете', 'Ncmpd', 4);

-- гроб
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'гроб' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'гробове', 'гробо`ве', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'гробовете', 'гробо`вете', 'Ncmpd', 4);

-- стол
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'стол' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'столове', 'сто`лове', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'столовете', 'сто`ловете', 'Ncmpd', 4);

-- дом
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'дом' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'домове', 'домове`', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'домовете', 'домове`те', 'Ncmpd', 4);

-- взрив
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'взрив' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'взрива', 'взри`ва', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'взривът', 'взри`вът', 'Ncmsf', 2);

-- чук
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'чук' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'чука', 'чу`ка', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'чукът', 'чу`кът', 'Ncmsf', 2);

-- дублетни форми: ключ, лък, цвик, бик, бук, грим?, делът

END TRANSACTION;