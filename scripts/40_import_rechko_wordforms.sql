CREATE TABLE main.rechko_wordforms AS SELECT * FROM rechko.derivative_form;

CREATE TABLE main.wordforms AS 
SELECT
	name as wordform,
	name as wordform_stressed,
	base_word_id as lemma_id,
	is_infinitive as is_lemma,
	description as tag,
	'rechko' as source,
	LENGTH(name) - LENGTH(name_condensed) as num_syllables
FROM
	main.rechko_wordforms
