BEGIN TRANSACTION;

UPDATE slovnik_wordform
SET pos = SUBSTR(tag, 1, 
            CASE WHEN tag LIKE 'Nc%'
                THEN 3
                ELSE 1
            END);

END TRANSACTION;