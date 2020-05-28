BEGIN TRANSACTION;

-- copy stress from stressed lemmata to their corresponding wordform after additional lemmata have been stressed
UPDATE wordform
SET wordform_stressed =
    IFNULL(
        (SELECT lemma_stressed FROM lemma WHERE lemma_id = wordform.lemma_id AND num_stresses > 0),
        wordform_stressed
    )
WHERE is_lemma = 1;

-- adds trivial stress to monosyllabic wordforms
UPDATE wordform
SET wordform_stressed = stress_syllable(wordform_stressed, 1)
WHERE num_syllables = 1 AND num_stresses = 0;

-- by default, stress all non-lemma wordforms the same way their lemmata are stressed
-- they can have up to four stresses
UPDATE wordform
SET wordform_stressed =
    (WITH ctx(lemma_stressed, num_stresses) AS (SELECT lemma_stressed, num_stresses FROM lemma WHERE lemma_id = wordform.lemma_id)
        SELECT
            CASE ctx.num_stresses
            WHEN 1 THEN stress_syllable(
                            wordform_stressed,
                            MIN(num_syllables, find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 1))
                        )
            WHEN 2 THEN stress_syllable(
                            stress_syllable(
                                wordform_stressed,
                                MIN(num_syllables, find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 1))
                            ),
                            find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 2)
                        )
            WHEN 3 THEN stress_syllable(
                            stress_syllable(
                                stress_syllable(
                                    wordform_stressed,
                                    MIN(num_syllables, find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 1))
                                ),
                                find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 2)
                            ),
                            find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 3)
                        )
            WHEN 4 THEN stress_syllable(
                            stress_syllable(
                                stress_syllable(
                                    stress_syllable(
                                        wordform_stressed,
                                        MIN(num_syllables, find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 1))
                                    ),
                                    find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 2)
                                ),
                                find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 3)
                            ),
                            find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 4)
                        )
            WHEN 5 THEN stress_syllable(
                            stress_syllable(
                                stress_syllable(
                                    stress_syllable(
                                        stress_syllable(
                                            wordform_stressed,
                                            MIN(num_syllables, find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 1))
                                        ),
                                        find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 2)
                                    ),
                                    find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 3)
                                ),
                                find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 4)
                            ),
                            find_nth_stressed_syllable_rev((SELECT lemma_stressed FROM ctx), 5)
                        )
            ELSE wordform_stressed
            END
        FROM ctx
    )
WHERE num_stresses = 0 AND is_lemma = 0;

-- deal with masculine monosyllabic nouns where stress moves away from the root to the suffixed article
UPDATE wordform
SET wordform_stressed =
    replace_last_stress(wordform_stressed, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 1)
WHERE lemma_id IN
    (
        WITH RECURSIVE ctx(lemma_id) AS (
            -- base case
            SELECT l1.lemma_id FROM lemma l1 WHERE l1.pos = 'Ncm' AND l1.num_syllables = 1 AND
            (l1.definition LIKE '%ъ`т%' OR l1.definition LIKE '%ъ̀т%' OR l1.definition LIKE '%я`т,%')
            AND l1.lemma NOT IN ('кът', 'хрът') -- false positives
            UNION ALL SELECT l1.lemma_id FROM lemma l1 WHERE l1.lemma IN ('тел', 'син', 'рев', 'ред', 'рид', 'род',
            'ръб', 'ръст', 'слух', 'срам', 'смях', 'сняг', 'тим') AND l1.pos = 'Ncm' -- false negatives
            -- inductive case
            UNION SELECT d.child_id FROM ctx c -- inefficient to omit ALL, but necessary to prevent infinite loop
            INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
            INNER JOIN derivation d ON d.parent_id = c.lemma_id
            INNER JOIN lemma l2 ON d.child_id = l2.lemma_id AND l1.pos = l2.pos
            WHERE l1.lemma NOT IN ('час') -- exclude derivatives of these words
        ) SELECT * FROM ctx WHERE ctx.lemma_id NOT IN (321)
        -- exclude derivations for whom this accent rule does not apply below
    )
    AND (tag LIKE 'N__sh' OR tag LIKE 'N__sf');

-- and with plural ове` and еве`
UPDATE wordform
SET wordform_stressed =
    replace_last_stress(wordform_stressed, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 2)
WHERE lemma_id IN
    (
        WITH RECURSIVE ctx(lemma_id) AS (
            SELECT lemma_id FROM lemma l
            WHERE pos = 'Ncm' AND num_syllables = 1 AND
            definition LIKE ('%' || replace(replace(l.lemma, 'я', 'е'), 'ръ', 'ър') || 'ове`%') AND
            definition NOT LIKE ('%' || replace(l.lemma_stressed, 'я', 'е') || 'ове%')
            UNION ALL SELECT lemma_id FROM lemma WHERE lemma IN ('свят', 'сняг', 'смях', 'бой', 'рой', 'син') AND pos = 'Ncm' -- false negatives
            UNION SELECT d.child_id FROM ctx c
            INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
            INNER JOIN derivation d ON d.parent_id = c.lemma_id
            INNER JOIN lemma l2 ON d.child_id = l2.lemma_id AND l1.pos = l2.pos
        ) SELECT * FROM ctx
    )
    AND (tag LIKE 'N__pi' OR tag LIKE 'N__pd' OR (tag LIKE 'N__t' AND wordform LIKE '%ове'));

-- and with plural о`ве
UPDATE wordform
SET wordform_stressed =
    replace_last_stress(wordform_stressed, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 1)
WHERE lemma_id IN
    (
        WITH RECURSIVE ctx(lemma_id) AS (
            SELECT lemma_id FROM lemma l
            WHERE pos = 'Ncm' AND num_syllables = 1 AND
            definition LIKE ('%' || replace(replace(l.lemma, 'я', 'е'), 'ръ', 'ър') || 'о`ве%')
            AND lemma NOT IN ('бой', 'клон') -- false positives
            UNION SELECT lemma_id FROM lemma WHERE lemma IN ('мост') AND pos = 'Ncm' -- false negatives
            UNION SELECT d.child_id FROM ctx c
            INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
            INNER JOIN derivation d ON d.parent_id = c.lemma_id
            INNER JOIN lemma l2 ON d.child_id = l2.lemma_id AND l1.pos = l2.pos
        ) SELECT * FROM ctx
    )
    AND (tag LIKE 'N__pi' OR tag LIKE 'N__pd' OR (tag LIKE 'N__t' AND wordform LIKE '%ове'));

-- and with plural е`
UPDATE wordform
SET wordform_stressed =
    replace_last_stress(wordform_stressed, find_nth_stressed_syllable_rev(wordform_stressed, 1) + 1)
WHERE lemma_id IN (
        WITH RECURSIVE ctx(lemma_id) AS (
            SELECT lemma_id FROM lemma l
            WHERE pos = 'Ncm' AND lemma IN ('мъж', 'княз', 'цар', 'крал', 'кон')
            UNION SELECT d.child_id FROM ctx c
            INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
            INNER JOIN derivation d ON d.parent_id = c.lemma_id
            INNER JOIN lemma l2 ON d.child_id = l2.lemma_id AND l1.pos = l2.pos
        ) SELECT * FROM ctx
    )
AND (tag LIKE 'N__pi' OR tag LIKE 'N__pd');

-- check for -и`ща
UPDATE wordform SET wordform_stressed = stress_syllable(wordform, 2)
WHERE lemma_id IN (
        WITH RECURSIVE ctx(lemma_id) AS (
            SELECT lemma_id FROM lemma WHERE lemma IN ('плет', 'град', 'дол') AND pos = 'Ncm'
            UNION SELECT d.child_id FROM ctx c
            INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
            INNER JOIN derivation d ON d.parent_id = c.lemma_id
            INNER JOIN lemma l2 ON d.child_id = l2.lemma_id AND l1.pos = l2.pos
        ) SELECT * FROM ctx
    )
AND wordform LIKE '%ища%' AND tag IN ('Ncmpi', 'Ncmpd');

-- check for `-ища
UPDATE wordform SET wordform_stressed = stress_syllable(wordform, 1)
WHERE lemma_id IN (
        SELECT lemma_id FROM lemma WHERE lemma IN ('гюл', 'гьол', 'трап', 'друм') AND pos = 'Ncm'
    )
AND wordform LIKE '%ища%' AND tag IN ('Ncmpi', 'Ncmpd');


-- deal with feminite nouns that end in a consonant that move their stress when their article is suffixed
UPDATE wordform
SET wordform_stressed =
    replace_last_stress(wordform_stressed, num_syllables)
WHERE tag LIKE 'N_fsd' AND (
    SELECT COUNT(*) FROM wordform w
    WHERE w.lemma_id = wordform.lemma_id AND w.is_lemma = 1 AND NOT is_vocal(SUBSTR(w.wordform, LENGTH(w.wordform)))
) > 0;

-- deal with feminite nouns that end in a stressed vowel 'a' or 'я' that move their stress one syllable backwards in vocative form
UPDATE wordform
SET wordform_stressed =
    stress_syllable(wordform, MAX(1, find_nth_stressed_syllable_rev(wordform_stressed, 1) - 1))
WHERE tag LIKE 'N_f__v' AND (
    SELECT COUNT(*) FROM wordform w
    WHERE w.lemma_id = lemma_id and is_lemma = 1 AND num_stresses > 0 AND
    (w.wordform_stressed LIKE '%а`' OR w.wordform_stressed LIKE '%я`')
) > 0;

-- deal with neuter nouns that end in an unstressed vowel 'o'
UPDATE wordform
SET wordform_stressed =
    replace_last_stress(
        wordform_stressed,
        CASE WHEN tag LIKE 'N_npi'
        THEN num_syllables
        ELSE
            -- always stress the suffix syllable with the article
            (SELECT w1.num_syllables FROM wordform w1 WHERE w1.lemma_id = wordform.lemma_id and w1.tag LIKE 'N_npi')
        END
    )
WHERE tag LIKE 'N_np_' AND ((
    SELECT COUNT(*) FROM wordform w
    WHERE w.lemma_id = wordform.lemma_id AND w.is_lemma = 1 AND w.wordform_stressed LIKE '%о' AND num_stresses > 0
) > 0);

-- deal with neuter nouns whose plural ends in 'ена', 'еса' or 'я'
CREATE TEMP TABLE NeuterNounsEnaEsaJa AS
SELECT lemma_id FROM wordform WHERE (wordform LIKE '%ена' OR wordform LIKE '%еса') AND tag = 'Ncnpi'
UNION SELECT w1.lemma_id FROM wordform w1
INNER JOIN wordform w2 ON w1.lemma_id = w2.lemma_id
WHERE w1.tag = 'Ncnsi' AND w1.num_syllables = 2 AND find_nth_stressed_syllable(w1.wordform_stressed, 1) = 1
AND w2.tag = 'Ncnpi' AND w2.num_syllables = w1.num_syllables AND w2.wordform LIKE '%я';

UPDATE wordform
SET wordform_stressed = replace_last_stress(wordform_stressed, num_syllables)
WHERE lemma_id IN (
    SELECT * FROM NeuterNounsEnaEsaJa
) AND tag = 'Ncnpi';

UPDATE wordform
SET wordform_stressed = replace_last_stress(wordform_stressed, num_syllables - 1)
WHERE lemma_id IN (
    SELECT * FROM NeuterNounsEnaEsaJa
) AND tag = 'Ncnpd';

-- put stress on penultimate syllable for all disyllabic vocative forms of nouns
UPDATE wordform
SET wordform_stressed = stress_syllable(wordform, 1)
WHERE tag = 'Ncms-v' AND num_syllables = 2 AND wordform LIKE '%ьо';

-- deal with exceptions
CREATE TEMP TABLE Sudijia AS
WITH RECURSIVE ctx(lemma_id) AS (
    -- base case
    SELECT l1.lemma_id FROM lemma l1 WHERE l1.lemma IN ('съдия') AND l1.pos = 'Ncm'
    -- inductive case
    UNION SELECT d.child_id FROM ctx c -- inefficient to omit ALL, but necessary to prevent infinite loop
    INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
    INNER JOIN derivation d ON d.parent_id = c.lemma_id
    INNER JOIN lemma l2 ON d.child_id = l2.lemma_id AND l1.pos = l2.pos

) SELECT * FROM ctx;

UPDATE wordform SET wordform_stressed = replace_last_stress(wordform_stressed, num_syllables - 1)
WHERE lemma_id IN (
    SELECT * FROM Sudijia
) AND (tag = 'Ncmpi' OR tag = 'Ncmt');

UPDATE wordform SET wordform_stressed = replace_last_stress(wordform_stressed, num_syllables - 2)
WHERE lemma_id IN (
    SELECT * FROM Sudijia
) AND tag = 'Ncmpd';

UPDATE wordform
SET wordform_stressed = 'съди`лища'
WHERE wordform_stressed = 'съ`дилища';

UPDATE wordform
SET wordform_stressed = 'номера`'
WHERE wordform_stressed = 'но`мера' AND tag = 'Ncmpi';

UPDATE wordform
SET wordform_stressed = 'номера`та'
WHERE wordform_stressed = 'но`мерата' AND tag = 'Ncmpd';

-- fix misstressed vocative forms
UPDATE wordform
SET wordform_stressed = 'о`тче'
WHERE wordform_stressed = 'отче`';

-- deal with numerals after "three" where the suffixed article receives the stress e.g. chetirite`
UPDATE wordform
SET wordform_stressed = replace_last_stress(wordform_stressed, num_syllables)
WHERE (tag like 'Mc_pd' or tag like 'Mc_ph' or tag like 'Mc_pf') AND 
lemma_id NOT IN (102896, 102897, 102898, 102947, 102948, 102949, 102950, 102951) AND
wordform LIKE '%те' AND wordform NOT IN ('тринките', 'тричките');

UPDATE wordform
SET wordform_stressed = replace_last_stress(wordform_stressed, CASE WHEN tag LIKE '%i' THEN num_syllables - 1 ELSE num_syllables - 2 END)
WHERE (tag like 'Mc-s_' or tag like 'My-p_') and lemma_id not in (102897, 102898, 102947, 102948, 102949, 102950, 102951)
AND is_lemma = 0;

-- deal with the numeral хи`ляди
UPDATE wordform
SET wordform_stressed = stress_syllable(wordform, 1)
WHERE lemma_id = 102948 AND wordform like 'хиляди%';

-- deal with prepositions
UPDATE wordform SET wordform_stressed = 'й`' WHERE wordform = 'й' and num_stresses = 0;

-- deal with verbs like чета which change their stress in aorist (incl. participle) and passive
UPDATE wordform
SET wordform_stressed
    = stress_syllable(wordform, MAX(1, (SELECT find_nth_stressed_syllable(lemma_stressed, 1) FROM lemma WHERE lemma_id = wordform.lemma_id) - 1))
WHERE lemma_id IN (
    WITH RECURSIVE ctx(lemma_id) AS (
        SELECT lemma_id FROM lemma WHERE lemma IN ('чета', 'плета', 'бода', 'неса', 'клада', 'крада', 'лека',
            'мета', 'преда', 'сека', 'веда', 'треса', 'паса', 'раста', 'река', 'пека', 'тека', 'гнета',
            'дера', 'пера', 'бера', 'сера', 'кълна')
            AND lemma_stressed LIKE '%`' AND pos LIKE 'V%'
        UNION SELECT d.child_id FROM ctx c
        INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
        INNER JOIN derivation d ON d.parent_id = c.lemma_id
        INNER JOIN lemma l2 ON d.child_id = l2.lemma_id
        WHERE l1.pos LIKE 'V%' AND l2.pos LIKE 'V%' -- you need this to match non-reflexive and reflexive verbs
        AND l2.num_stresses > 0
    ) SELECT * FROM ctx
)
AND (tag LIKE 'V___f_o__' OR tag LIKE 'V___cv_____' OR tag LIKE 'V___cao____');

UPDATE wordform
SET wordform_stressed
    = stress_syllable(wordform, MIN(num_syllables, (SELECT find_nth_stressed_syllable(lemma_stressed, 1) FROM lemma WHERE lemma_id = wordform.lemma_id) + 1))
WHERE lemma_id IN (
    WITH RECURSIVE ctx(lemma_id) AS (
        SELECT lemma_id FROM lemma WHERE lemma IN ('дойда', 'зайда') AND pos LIKE 'V%'
        UNION SELECT d.child_id FROM ctx c
        INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
        INNER JOIN derivation d ON d.parent_id = c.lemma_id
        INNER JOIN lemma l2 ON d.child_id = l2.lemma_id
        WHERE l1.pos LIKE 'V%' AND l2.pos LIKE 'V%' -- you need this to match non-reflexive and reflexive verbs
        AND l2.num_stresses > 0
    ) SELECT * FROM ctx
)
AND (tag LIKE 'V___f_o__' OR tag LIKE 'V___cv_____' OR tag LIKE 'V___cao____');

-- deal with verbs whose lemmata have an internal syllable stressed and move their stress in imperative form
UPDATE wordform
SET wordform_stressed 
    = replace_last_stress(wordform_stressed, MIN(num_syllables, (SELECT find_nth_stressed_syllable_rev(lemma_stressed, 1) FROM lemma WHERE lemma_id = wordform.lemma_id) + 1))
WHERE num_syllables > 1 AND lemma_id IN (SELECT lemma_id FROM lemma WHERE find_nth_stressed_syllable_rev(lemma_stressed, 1) < num_syllables AND pos LIKE 'V%') AND
tag LIKE 'V___z__2_';

UPDATE wordform
SET wordform_stressed
    = replace_last_stress(wordform_stressed, MIN(num_syllables, (SELECT find_nth_stressed_syllable_rev(lemma_stressed, 1) FROM lemma WHERE lemma_id = wordform.lemma_id) - 1))
WHERE num_syllables > 1 AND lemma_id IN (SELECT lemma_id FROM lemma WHERE find_nth_stressed_syllable_rev(lemma_stressed, 1) = num_syllables AND pos LIKE 'V%' AND num_syllables > 1) AND
tag LIKE 'V___z__2_';

-- deal with verbs like ям where stress moves one syllable to the right of its position in the lemma
UPDATE wordform SET wordform_stressed =
    stress_syllable(wordform,
        MIN(num_syllables, (SELECT find_nth_stressed_syllable_rev(lemma_stressed, 1) FROM lemma WHERE lemma_id = wordform.lemma_id) + 1))
WHERE lemma_id IN (
    WITH RECURSIVE ctx(lemma_id) AS (
        SELECT lemma_id FROM lemma WHERE lemma IN ('ям') AND pos LIKE 'V%'
        UNION SELECT d.child_id FROM ctx c
        INNER JOIN lemma l1 ON l1.lemma_id = c.lemma_id
        INNER JOIN derivation d ON d.parent_id = c.lemma_id
        INNER JOIN lemma l2 ON d.child_id = l2.lemma_id AND l1.pos = l2.pos
    ) SELECT * FROM ctx
) 
AND (tag LIKE 'V___f_r__' OR tag LIKE 'V___f_m__' OR tag LIKE 'V___cam____' OR tag LIKE 'V___car____' OR tag = 'Vpitg');

END TRANSACTION;