BEGIN TRANSACTION;

-- add missing forms and words with two possible stress patterns (dubletni formi)
-- съм
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'съм' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'беше', 'бе`ше', 'Vxitf-t2s', 2),
    ((SELECT * FROM ctx), 'беше', 'бе`ше', 'Vxitf-t3s', 2);

-- неин
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'неин' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'ѝ', 'ѝ`', 'Psot--3--f', 1);

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

-- ключ
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'ключ' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'ключа', 'ключа`', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'ключът', 'ключъ`т', 'Ncmsf', 2);

-- лък
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'лък' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'лъка', 'лъ`ка', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'лъкът', 'лъ`кът', 'Ncmsf', 2),
    ((SELECT * FROM ctx), 'лъци', 'лъ`ци', 'Ncmpi', 2),
    ((SELECT * FROM ctx), 'лъците', 'лъ`ците', 'Ncmpd', 3);

-- бик
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'бик' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'бика', 'би`ка', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'бикът', 'би`кът', 'Ncmsf', 2);

-- бук
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'бук' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'бука', 'бука`', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'букът', 'букъ`т', 'Ncmsf', 2);

-- грим
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'грим' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'грима', 'грима`', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'гримът', 'гримъ`т', 'Ncmsf', 2);

-- грип
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'грип' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'грипа', 'грипа`', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'грипът', 'грипъ`т', 'Ncmsf', 2);

-- вир
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'вир' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'вира', 'ви`ра', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'вирът', 'ви`рът', 'Ncmsf', 2);

-- план
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'план' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'плана', 'плана`', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'планът', 'планъ`т', 'Ncmsf', 2);

-- лен
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'лен' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'лена', 'лена`', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'ленът', 'ленъ`т', 'Ncmsf', 2);

-- дол
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'дол' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'дола', 'до`ла', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'долът', 'до`лът', 'Ncmsf', 2),
    ((SELECT * FROM ctx), 'долове', 'до`лове', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'доловете', 'до`ловете', 'Ncmpd', 4);

-- плет
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'плет' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'плета', 'пле`та', 'Ncmsh', 2),
    ((SELECT * FROM ctx), 'плетът', 'пле`тът', 'Ncmsf', 2);

-- лист
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'лист' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'листи', 'ли`сти', 'Ncmpi', 2),
    ((SELECT * FROM ctx), 'листите', 'ли`стите', 'Ncmpd', 3),
    ((SELECT * FROM ctx), 'листа', 'листа`', 'Ncmpi', 2),
    ((SELECT * FROM ctx), 'листата', 'листа`та', 'Ncmpd', 3),
    ((SELECT * FROM ctx), 'листя', 'листя`', 'Ncmpi', 2),
    ((SELECT * FROM ctx), 'листята', 'листя`та', 'Ncmpd', 3);

-- двор
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'двор' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'дворища', 'дво`рища', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'дворищата', 'дво`рищата', 'Ncmpd', 4);

UPDATE wordform SET wordform_stressed = stress_syllable(wordform, 1)
    WHERE lemma_id = 272 AND wordform LIKE 'двори%' AND tag IN ('Ncmpi', 'Ncmpd');

-- село
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'село' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'село', 'село`', 'Ncnsi', 2),
    ((SELECT * FROM ctx), 'селото', 'село`то', 'Ncnsd', 3);

-- чело
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'чело' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'чело', 'чело`', 'Ncnsi', 2),
    ((SELECT * FROM ctx), 'челото', 'чело`то', 'Ncnsd', 3);

-- бодил
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'бодил' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'бодли', 'бодли`', 'Ncmpi', 2),
    ((SELECT * FROM ctx), 'бодлите', 'бодли`те', 'Ncmpd', 3);

-- госпожа
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma_stressed = 'госпожа`' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'госпожи', 'госпо`жи', 'Ncfpi', 3),
    ((SELECT * FROM ctx), 'госпожите', 'госпо`жите', 'Ncfpd', 4),
    ((SELECT * FROM ctx), 'госпожа', 'госпожа`', 'Ncfs-v', 3),
    ((SELECT * FROM ctx), 'госпожа', 'госпо`жа', 'Ncfs-v', 3),
    ((SELECT * FROM ctx), 'госпоже', 'госпо`же', 'Ncfs-v', 3);

-- враг
WITH ctx AS (SELECT lemma_id FROM wordform WHERE wordform_stressed = 'врагове`' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'врази', 'вра`зи', 'Ncmpi', 2);

-- алт
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'алт' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'алти', 'алти`', 'Ncmpi', 2);

-- гръм
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'гръм' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'гърмове', 'гъ`рмове', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'гърмовете', 'гъ`рмовете', 'Ncmpd', 4),
    ((SELECT * FROM ctx), 'гърма', 'гъ`рма', 'Ncmt', 4);

-- дърво
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'дърво' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'дърве', 'дъ`рве', 'Ncnpi', 2),
    ((SELECT * FROM ctx), 'дървя', 'дървя`', 'Ncnpi', 2),
    ((SELECT * FROM ctx), 'дървята', 'дървя`та', 'Ncnpd', 3),
    ((SELECT * FROM ctx), 'дървеса', 'дървеса`', 'Ncnpi', 3),
    ((SELECT * FROM ctx), 'дървесата', 'дървеса`та', 'Ncnpd', 4);

-- слово
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'слово' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'словеса', 'словеса`', 'Ncnpi', 3),
    ((SELECT * FROM ctx), 'словесата', 'словеса`та', 'Ncnpd', 4);

-- поле
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'поле' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'поля', 'поля`', 'Ncnpi', 2),
    ((SELECT * FROM ctx), 'полята', 'поля`та', 'Ncnpd', 3);

-- море
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'море' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'моря', 'моря`', 'Ncnpi', 2),
    ((SELECT * FROM ctx), 'морята', 'моря`та', 'Ncnpd', 3);

-- джоб
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'джоб' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'джобове', 'джобо`ве', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'джобовете', 'джобо`вете', 'Ncmpd', 4);

-- стих
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'стих' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'стихове', 'стихове`', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'стиховете', 'стихове`те', 'Ncmpd', 4);

-- рог
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'рог' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'рога', 'рога`', 'Ncmpi', 2),
    ((SELECT * FROM ctx), 'рогата', 'рога`та', 'Ncmpd', 3);

-- даскал
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'даскал' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'даскаля', 'даскаля`', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'даскалята', 'даскаля`та', 'Ncmpd', 4);

-- циганин
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'циганин' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'циганя', 'циганя`', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'циганята', 'циганя`та', 'Ncmpd', 4);

-- журналист
WITH ctx AS (SELECT lemma_id FROM lemma WHERE lemma = 'журналист' ORDER BY lemma_id LIMIT 1)
    INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
    ((SELECT * FROM ctx), 'журналя', 'журналя`', 'Ncmpi', 3),
    ((SELECT * FROM ctx), 'журналята', 'журналя`та', 'Ncmpd', 4);

END TRANSACTION;