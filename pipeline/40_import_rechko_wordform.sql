BEGIN TRANSACTION;

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
	main.derivative_form rd
LEFT JOIN main.rechko_lemma rl ON rd.base_word_id = rl.id;

-- delete misspelled wordforms
DELETE FROM rechko_wordform WHERE lemma_id = 782; -- прираст is misspelled as приръст
DELETE FROM rechko_wordform WHERE lemma_id = 901;

-- fix bugs in rechko
UPDATE rechko_wordform
SET
	wordform = SUBSTR(wordform, 1, LENGTH(wordform) - 1) || 'о',
	wordform_stressed = SUBSTR(wordform_stressed, 1, LENGTH(wordform_stressed) - 1) || 'о'
WHERE tag = 'Ncms-v' AND is_lemma = 1 AND SUBSTR(wordform, LENGTH(wordform)) = 'а';

-- fix wordforms wrongfully marked up as lemmata
UPDATE rechko_wordform SET is_lemma = 0 WHERE tag IN ('Ncms-v', 'Vpptf-o2s', 'Vpptf-o3s') AND is_lemma = 1;

-- replace latin letters with cyrillic equivalents
UPDATE rechko_wordform SET
	wordform = REPLACE(REPLACE(wordform, 'o', 'о'), 'e', 'е'),
	wordform_stressed = REPLACE(REPLACE(wordform_stressed, 'o', 'о'), 'e', 'е');

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

-- deals with wrong inflections
DELETE FROM rechko_wordform WHERE wordform LIKE 'полугласи%' AND lemma_id = 34169;
DELETE FROM rechko_wordform WHERE wordform LIKE 'радиочаси%' AND lemma_id = 34598;

-- this helps evade rechko mismatches for reflexive verbs and adjectives
UPDATE rechko_wordform SET wordform = REPLACE(wordform, ' се', ''), wordform_stressed = REPLACE(wordform_stressed, ' се', '')
WHERE classification = 'reflexive' or classification = '+reflexive';

-- deals with wrong inflections
DELETE FROM rechko_wordform WHERE wordform IN ('начета', 'затека', 'завлека') AND tag LIKE 'V%' AND tag NOT LIKE '%r1s' AND is_lemma = 1;

-- fix rechko bugs, where reflexive verbs have wrong imperative forms and are considered lemmata
UPDATE rechko_wordform
	SET is_lemma = 0,
		(wordform, wordform_stressed) =
			(SELECT IFNULL(w2.wordform, rechko_wordform.wordform), IFNULL(w2.wordform_stressed, rechko_wordform.wordform) FROM lemma l
			INNER JOIN rechko_wordform w ON l.lemma_id = w.lemma_id AND w.is_lemma = 1 AND w.wordform = l.lemma
			INNER JOIN lemma l2 ON l.lemma = l2.lemma AND l.lemma_id != l2.lemma_id
			INNER JOIN rechko_wordform w2 ON l2.lemma_id = w2.lemma_id AND w.tag = w2.tag AND w.wordform != w2.wordform
			WHERE w.tag LIKE 'V___z__2_' AND l.lemma_id = rechko_wordform.lemma_id AND l.pos LIKE 'V%' AND l2.pos LIKE 'V%')
WHERE rechko_wordform.tag LIKE 'V___z__2_' AND rechko_wordform.is_lemma = 1;

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
	accent_model TEXT,
	FOREIGN KEY(lemma_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE
);

INSERT INTO main.wordform (lemma_id, wordform, wordform_stressed, is_lemma, tag, source, num_syllables)
SELECT
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
INSERT INTO main.wordform (lemma_id, wordform, wordform_stressed, is_lemma, tag, source, num_syllables)
SELECT
	l1.lemma_id,
	w2.wordform,
	w2.wordform_stressed,
	w2.is_lemma,
	w2.tag,
	w2.source,
	COUNT_SYLLABLES(w2.wordform) AS num_syllables
FROM lemma l1
LEFT JOIN wordform w1 ON w1.lemma_id = l1.lemma_id
INNER JOIN lemma l2 ON l1.lemma_stressed = l2.lemma_stressed AND (l1.pos = l2.pos OR SUBSTR(l1.pos, 1, 1) = l2.pos) AND l1.lemma_id != l2.lemma_id
INNER JOIN wordform w2 ON w2.lemma_id = l2.lemma_id
WHERE w1.wordform_id IS NULL;

END TRANSACTION;