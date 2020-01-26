CREATE TABLE main.rechko_wordforms AS
SELECT
	rd.name as wordform,
	rd.name as wordform_stressed,
	rd.name_condensed as wordform_condensed,
	rd.base_word_id as lemma_id,
	rd.is_infinitive as is_lemma,
	NULL as tag,
	rl.speech_part as speech_part,
	rd.description as tag_description
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
	LENGTH(REPLACE(REPLACE(wordform, 'й', ''), 'ь', '')) - LENGTH(wordform_condensed) as num_syllables
FROM main.rechko_wordforms;
