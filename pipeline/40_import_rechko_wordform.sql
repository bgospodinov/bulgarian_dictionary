BEGIN TRANSACTION;

-- delete verb inflections that are not relevant for BTB-style morphosyntactic tagging
DELETE FROM rechko.derivative_form WHERE
description LIKE "бъд.вр.%" OR
description LIKE "мин.неопр.%" OR
description LIKE "мин.пред.%" OR
description LIKE "бъд.пред.%" OR
description LIKE "пр.накл.%" OR
description LIKE "условно наклонение%";

CREATE TABLE main.rechko_wordform AS
SELECT
	rd.name AS wordform,
	rd.name AS wordform_stressed,
	rd.base_word_id AS lemma_id,
	rd.is_infinitive AS is_lemma,
	RECHKO_TAG(rd.name, rl.speech_part, rd.description) AS tag,
	rl.speech_part AS pos, -- for debugging only
	rd.description AS morphosyntactic_tag, -- for debugging only
	rl.classification as classification
FROM
	rechko.derivative_form rd
LEFT JOIN main.rechko_lemma rl ON rd.base_word_id = rl.id;

-- delete all impossible wordforms inherited from rechko
DELETE FROM rechko_wordform WHERE wordform = "—";

-- delete misspelled wordforms
DELETE FROM rechko_wordform WHERE lemma_id = 782; -- прираст is misspelled as приръст

-- fix bugs in rechko
-- fix wordforms wrongfully marked up as lemmata
UPDATE rechko_wordform
SET
	wordform = SUBSTR(wordform, 1, LENGTH(wordform) - 1) || 'о',
	wordform_stressed = SUBSTR(wordform_stressed, 1, LENGTH(wordform_stressed) - 1) || 'о'
WHERE tag = 'Ncms-v' AND is_lemma = 1 AND SUBSTR(wordform, LENGTH(wordform)) = 'а';
UPDATE rechko_wordform SET is_lemma = 0 WHERE tag = 'Ncms-v' AND is_lemma = 1;

-- replace latin letters with cyrillic equivalents
UPDATE rechko_wordform SET wordform = REPLACE(wordform, 'o', 'о'), wordform_stressed = REPLACE(wordform_stressed, 'o', 'о');

-- certain words are not inflected
UPDATE rechko_wordform SET wordform = 'урната', wordform_stressed = 'урната', is_lemma = 0 WHERE lemma_id = 114436 AND tag = 'Ncfsd';
UPDATE rechko_wordform SET wordform = 'урни', wordform_stressed = 'урни', is_lemma = 0 WHERE lemma_id = 114436 AND tag = 'Ncfpi';
UPDATE rechko_wordform SET wordform = 'урните', wordform_stressed = 'урните', is_lemma = 0 WHERE lemma_id = 114436 AND tag = 'Ncfpd';

UPDATE rechko_wordform SET wordform = 'боята', wordform_stressed = 'боята', is_lemma = 0 WHERE lemma_id = 114442 AND tag = 'Ncfsd';
UPDATE rechko_wordform SET wordform = 'бои', wordform_stressed = 'бои', is_lemma = 0 WHERE lemma_id = 114442 AND tag = 'Ncfpi';
UPDATE rechko_wordform SET wordform = 'боите', wordform_stressed = 'боите', is_lemma = 0 WHERE lemma_id = 114442 AND tag = 'Ncfpd';

UPDATE rechko_wordform SET wordform = 'грижата', wordform_stressed = 'грижата', is_lemma = 0 WHERE lemma_id = 114443 AND tag = 'Ncfsd';
UPDATE rechko_wordform SET wordform = 'грижи', wordform_stressed = 'грижи', is_lemma = 0 WHERE lemma_id = 114443 AND tag = 'Ncfpi';
UPDATE rechko_wordform SET wordform = 'грижите', wordform_stressed = 'грижите', is_lemma = 0 WHERE lemma_id = 114443 AND tag = 'Ncfpd';

UPDATE rechko_wordform
SET wordform = REPLACE(wordform, 'черири', 'четири'),
	wordform_stressed = REPLACE(wordform_stressed, 'черири', 'четири')
WHERE lemma_id = 102923;

-- this helps evade rechko mismatches for reflexive verbs and adjectives
UPDATE rechko_wordform SET wordform = REPLACE(wordform, ' се', ''), wordform_stressed = REPLACE(wordform_stressed, ' се', '')
WHERE classification = 'reflexive' or classification = '+reflexive';

CREATE TABLE main.wordform (
	wordform_id INTEGER PRIMARY KEY,
	lemma_id INT,
	wordform TEXT,
	wordform_stressed TEXT,
	is_lemma INT DEFAULT 0,
	tag TEXT,
	pos TEXT GENERATED ALWAYS AS (SUBSTR(tag, 1, 1)) STORED, -- only supported in sqlite >= 3.31.0
	source TEXT DEFAULT 'manual',
	num_syllables INT,
	num_stresses INT GENERATED ALWAYS AS (LENGTH(wordform_stressed) - LENGTH(REPLACE(wordform_stressed, '`', ''))) STORED, -- only supported in sqlite >= 3.31.0
	FOREIGN KEY(lemma_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE
);

INSERT INTO main.wordform SELECT
	NULL as wordform_id,
	r.lemma_id,
	r.wordform,
	CASE WHEN r.is_lemma = 0 THEN r.wordform_stressed ELSE l.lemma_stressed END AS wordform_stressed,
	r.is_lemma,
	r.tag,
	'rechko' AS source,
	COUNT_SYLLABLES(r.wordform) AS num_syllables
FROM main.rechko_wordform r
LEFT JOIN lemma l ON r.lemma_id = l.lemma_id;

-- if a lemma doesn't have any wordforms assigned, then try to find an identical lemma that has wordforms 
-- and assign those wordforms to it
INSERT INTO main.wordform SELECT
	NULL as wordform_id,
	l1.lemma_id,
	w2.wordform,
	w2.wordform_stressed,
	w2.is_lemma,
	w2.tag,
	w2.source,
	COUNT_SYLLABLES(w2.wordform) AS num_syllables
FROM lemma l1
LEFT JOIN wordform w1 ON w1.lemma_id = l1.lemma_id
INNER JOIN lemma l2 ON l1.lemma_stressed = l2.lemma_stressed AND l1.pos = l2.pos AND l1.lemma_id != l2.lemma_id
INNER JOIN wordform w2 ON w2.lemma_id = l2.lemma_id
WHERE w1.wordform_id IS NULL;

END TRANSACTION;