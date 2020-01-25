CREATE TABLE main.rechko_wordforms AS SELECT * FROM rechko.derivative_form;

CREATE TABLE main.wordforms (
	wordform TEXT,
	wordform_stressed TEXT,
	lemma_id INT,
	is_lemma INT,
	pos,
	tag TEXT,
	source,
	num_syllables INT,
	FOREIGN KEY(lemma_id) REFERENCES lemma(lemma_id)
	ON DELETE CASCADE
);

INSERT INTO main.wordforms
SELECT
	rw.name as wordform,
	rw.name as wordform_stressed,
	rw.base_word_id as lemma_id,
	rw.is_infinitive as is_lemma,
	l.pos as pos,
	rw.description as tag,
	'rechko' as source,
	LENGTH(rw.name) - LENGTH(rw.name_condensed) as num_syllables
FROM
	main.rechko_wordforms rw
LEFT JOIN main.lemma l ON rw.base_word_id = l.lemma_id;
