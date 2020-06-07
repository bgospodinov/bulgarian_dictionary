BEGIN TRANSACTION;

INSERT INTO pronunciation (wordform_id, pronunciation, pronunciation_stressed, sonority_model)
SELECT wordform_id, pronounce(wordform), pronounce(wordform_stressed), sonority_model(wordform) FROM wordform;

-- deal with masculine nouns with short definite article
CREATE TEMP TABLE Ncmsh AS
SELECT p.wordform_id, p.pronunciation, p.pronunciation_stressed FROM pronunciation p
LEFT JOIN wordform w ON w.wordform_id = p.wordform_id
WHERE w.tag = 'Ncmsh' AND pronunciation LIKE '%а';

-- deal with masculine nouns with full definite article
CREATE TEMP TABLE Ncmsf AS
SELECT p.wordform_id, p.pronunciation, p.pronunciation_stressed FROM pronunciation p
LEFT JOIN wordform w ON w.wordform_id = p.wordform_id
WHERE w.tag = 'Ncmsf' AND pronunciation LIKE '%йат';

INSERT INTO pronunciation (wordform_id, pronunciation, pronunciation_stressed, is_normative)
SELECT *, 0 FROM Ncmsh
UNION SELECT *, 0 FROM Ncmsf;

-- deal with 1st person singular verbs and 3rd person plural verbs of 1st and 2nd conjugation
-- in Bulgarian conjugation is determined by the last vowel of the 3rd person singular present tense wordform of the verb
-- 1st conjugation ends in 'е' and 2nd conjugation in 'и'
CREATE TEMP TABLE SpecialVerbs AS
SELECT p.wordform_id, p.pronunciation, p.pronunciation_stressed FROM pronunciation p
LEFT JOIN wordform w ON w.wordform_id = p.wordform_id
WHERE w.lemma_id IN
(
	SELECT w1.lemma_id FROM wordform w1 WHERE w1.tag LIKE 'V%r3s' AND (w1.wordform LIKE '%е' OR w1.wordform LIKE '%и')
)
AND (w.tag LIKE '%r1s' OR w.tag LIKE '%r3p');

INSERT INTO pronunciation (wordform_id, pronunciation, pronunciation_stressed, is_normative)
SELECT *, 0 FROM SpecialVerbs;

UPDATE pronunciation
SET
    pronunciation = SUBSTR(pronunciation, 1, LENGTH(pronunciation) - 1) || 'ъ',
    pronunciation_stressed = CASE WHEN pronunciation_stressed LIKE '%`'
            THEN SUBSTR(pronunciation_stressed, 1, LENGTH(pronunciation_stressed) - 2) || 'ъ`'
            ELSE SUBSTR(pronunciation_stressed, 1, LENGTH(pronunciation_stressed) - 1) || 'ъ'
            END
WHERE wordform_id IN (
    SELECT wordform_id FROM SpecialVerbs WHERE pronunciation LIKE '%а'
    UNION SELECT wordform_id FROM Ncmsh
) AND is_normative = 1;

UPDATE pronunciation
SET
    pronunciation = SUBSTR(pronunciation, 1, LENGTH(pronunciation) - 2) || 'ът',
    pronunciation_stressed = CASE WHEN pronunciation_stressed LIKE '%`т'
            THEN SUBSTR(pronunciation_stressed, 1, LENGTH(pronunciation_stressed) - 3) || 'ъ`т'
            ELSE SUBSTR(pronunciation_stressed, 1, LENGTH(pronunciation_stressed) - 2) || 'ът'
            END
WHERE wordform_id IN (
    SELECT wordform_id FROM SpecialVerbs WHERE pronunciation LIKE '%ат'
    UNION SELECT wordform_id FROM Ncmsf
) AND is_normative = 1;

-- TODO: nouns ending in -ст

END TRANSACTION;