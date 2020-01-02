CREATE TABLE main.rechko_lemma AS SELECT * FROM rechko.rechko_lemma;
CREATE TABLE main.rechko_word_type AS SELECT * FROM rechko.word_type;

CREATE TABLE lemma AS SELECT
	name,
	name_stressed,
	--r.id as rechko_id,
	type_id,
	source,
	NULL as source_definition
	--m.source_definition
FROM main.rechko_lemma r
--LEFT JOIN rbe_lemma m
	--ON m.lemma_with_stress = r.name_stressed
UNION ALL SELECT
	lemma as name,
	lemma_with_stress as name_stressed,
	--0 as rechko_id,
	type_id,
	'rbe' as source,
	m.source_definition
FROM rbe_lemma m
LEFT JOIN rechko_lemma l
	ON m.lemma_with_stress = l.name_stressed
WHERE l.name_stressed IS NULL
