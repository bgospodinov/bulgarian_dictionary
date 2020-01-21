CREATE TABLE main.rechko_lemma AS SELECT
	*,
	CASE
		WHEN rwt.speech_part LIKE "verb%" THEN "V"
		WHEN rwt.speech_part = "adjective" THEN "A"
		WHEN rwt.speech_part = "adverb" THEN "D"
		WHEN rwt.speech_part LIKE "pronominal%" THEN "P"
		WHEN rwt.speech_part LIKE "name%" THEN "H"
		WHEN rwt.speech_part LIKE "numeral%" THEN "M"
		WHEN rwt.speech_part = "conjunction" THEN "C"
		WHEN rwt.speech_part = "interjection" THEN "I"
		WHEN rwt.speech_part = "particle" THEN "T"
		WHEN rwt.speech_part = "preposition" THEN "R"
		ELSE "N"
	END AS pos
FROM rechko.rechko_lemma rl
LEFT JOIN rechko.word_type rwt
	ON rl.type_id = rwt.id;

CREATE TABLE main.rechko_word_type AS SELECT * FROM rechko.word_type;

CREATE TABLE lemma AS SELECT
	rl.name,
	rl.name_stressed,
	--rl.id as rechko_id,
	rl.source,
	m.source_definition,
	rl.pos as pos
FROM main.rechko_lemma rl
LEFT JOIN rbe_lemma m
	ON m.lemma_with_stress = rl.name_stressed
	AND rl.pos = m.pos
UNION ALL SELECT
	lemma as name,
	lemma_with_stress as name_stressed,
	--0 as rechko_id,
	'rbe' as source,
	m.source_definition,
	m.pos as pos
FROM rbe_lemma m
LEFT JOIN rechko_lemma l
	ON m.lemma_with_stress = l.name_stressed
	AND m.pos = l.pos
WHERE l.name_stressed IS NULL;
