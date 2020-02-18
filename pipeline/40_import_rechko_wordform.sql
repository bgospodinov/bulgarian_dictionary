CREATE TABLE main.rechko_wordform AS
SELECT
	rd.name AS wordform,
	rd.name AS wordform_stressed,
	rd.base_word_id AS lemma_id,
	rd.is_infinitive AS is_lemma,
	RECHKO_TAG(rd.name, rl.speech_part, rd.description) AS tag,
	rl.speech_part AS pos, -- for debugging only
	rd.description AS morphosyntactic_tag -- for debugging only
FROM
	rechko.derivative_form rd
LEFT JOIN main.rechko_lemma rl ON rd.base_word_id = rl.id;

-- delete verb inflections that are not relevant for BTB-style morphosyntactic tagging
DELETE FROM main.rechko_wordform WHERE morphosyntactic_tag LIKE "бъд.вр.%";

CREATE TABLE main.wordform (
	wordform TEXT,
	wordform_stressed TEXT,
	lemma_id INT,
	is_lemma INT,
	tag TEXT,
	source TEXT,
	num_syllables INT,
	morphosyntactic_tag,
	FOREIGN KEY(lemma_id) REFERENCES lemma(lemma_id)
	ON DELETE CASCADE
);

INSERT INTO main.wordform
SELECT
	wordform,
	wordform_stressed,
	lemma_id,
	is_lemma,
	tag,
	'rechko' as source,
	COUNT_SYLLABLES(wordform) as num_syllables
FROM main.rechko_wordform;

-- fix bugs in rechko
-- replace latin letters with cyrillic equivalents
UPDATE main.wordform SET wordform = REPLACE(wordform, 'o', 'о'), wordform_stressed = REPLACE(wordform_stressed, 'o', 'о');
