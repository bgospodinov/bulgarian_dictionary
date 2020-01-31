CREATE TABLE main.rechko_wordforms AS
SELECT
	rd.name AS wordform,
	rd.name AS wordform_stressed,
	rd.base_word_id AS lemma_id,
	rd.is_infinitive AS is_lemma,
	RECHKO_TAG(rl.speech_part, rd.description) AS tag,
	rl.speech_part AS pos, -- for debugging only
	rd.description AS morphosyntactic_tag -- for debugging only
FROM
	rechko.derivative_form rd
LEFT JOIN main.rechko_lemma rl ON rd.base_word_id = rl.id;

CREATE TABLE main.wordforms (
	wordform TEXT,
	wordform_stressed TEXT,
	lemma_id INT,
	is_lemma INT,
	tag TEXT,
	source TEXT,
	num_syllables INT,
	FOREIGN KEY(lemma_id) REFERENCES lemma(lemma_id)
	ON DELETE CASCADE
);

INSERT INTO main.wordforms
SELECT
	wordform,
	wordform_stressed,
	lemma_id,
	is_lemma,
	tag,
	'rechko' as source,
	COUNT_SYLLABLES(wordform) as num_syllables
FROM main.rechko_wordforms;

-- fix bugs in rechko
-- replace latin letters with cyrillic equivalents
UPDATE main.wordforms SET wordform = REPLACE(wordform, 'o', 'о'), wordform_stressed = REPLACE(wordform_stressed, 'o', 'о');
