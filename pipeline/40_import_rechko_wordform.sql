BEGIN TRANSACTION;

-- delete verb inflections that are not relevant for BTB-style morphosyntactic tagging
DELETE FROM rechko.derivative_form WHERE description LIKE "бъд.вр.%" OR description LIKE "мин.неопр.%" OR description LIKE "мин.пред.%" OR description LIKE "бъд.пред.%" OR description LIKE "пр.накл.%" OR description LIKE "условно наклонение%";

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

-- fix bugs in rechko
-- replace latin letters with cyrillic equivalents
UPDATE rechko_wordform SET wordform = REPLACE(wordform, 'o', 'о'), wordform_stressed = REPLACE(wordform_stressed, 'o', 'о');

-- this helps evade rechko mismatches for reflexive verbs and adjectives
UPDATE rechko_wordform SET wordform = REPLACE(wordform, ' се', ''), wordform_stressed = REPLACE(wordform_stressed, ' се', '')
WHERE classification = 'reflexive' or classification = '+reflexive';

CREATE TABLE main.wordform (
	wordform_id INTEGER PRIMARY KEY,
	lemma_id INT,
	wordform TEXT,
	wordform_stressed TEXT,
	is_lemma INT,
	tag TEXT,
	pos TEXT GENERATED ALWAYS AS (SUBSTR(tag, 1, 1)) STORED, -- only supported in sqlite >= 3.31.0
	source TEXT,
	num_syllables INT,
	num_stresses INT GENERATED ALWAYS AS (LENGTH(wordform_stressed) - LENGTH(REPLACE(wordform_stressed, '`', ''))) STORED, -- only supported in sqlite >= 3.31.0
	FOREIGN KEY(lemma_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE
);

INSERT INTO main.wordform
SELECT
	NULL as wordform_id,
	r.lemma_id,
	r.wordform,
	CASE WHEN r.is_lemma = 0 THEN r.wordform_stressed ELSE l.lemma_stressed END AS wordform_stressed,
	r.is_lemma,
	r.tag,
	'rechko' as source,
	COUNT_SYLLABLES(r.wordform) as num_syllables
FROM main.rechko_wordform r
LEFT JOIN lemma l ON r.lemma_id = l.lemma_id;

END TRANSACTION;