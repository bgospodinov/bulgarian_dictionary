CREATE TABLE main.rechko_word_type AS SELECT * FROM rechko.word_type;

-- fix mistakes in rechko_word_type
UPDATE rechko_word_type SET speech_part = 'noun_male' WHERE id = 3;

CREATE TABLE main.rechko_lemma AS SELECT
	*,
	rwt.speech_part,
	CASE
		WHEN rwt.speech_part LIKE 'verb%' THEN 'V'
		WHEN rwt.speech_part = 'adjective' THEN 'A'
		WHEN rwt.speech_part = 'adverb' THEN 'D'
		WHEN rwt.speech_part LIKE 'pronominal%' THEN 'P'
		WHEN rwt.speech_part LIKE 'name%' THEN 'N' -- proper nouns
		WHEN rwt.speech_part LIKE 'numeral%' THEN 'M'
		WHEN rwt.speech_part = 'conjunction' THEN 'C'
		WHEN rwt.speech_part = 'interjection' THEN 'I'
		WHEN rwt.speech_part = 'particle' THEN 'T'
		WHEN rwt.speech_part = 'preposition' THEN 'R'
		ELSE 'N'
	END AS pos
FROM rechko.rechko_lemma rl
LEFT JOIN rechko_word_type rwt
	ON rl.type_id = rwt.id;

CREATE TABLE lemma AS SELECT
	rl.id as lemma_id,
	rl.name,
	COALESCE(rl.name_stressed, rl.name) AS name_stressed,
	rl.source,
	m.source_definition,
	rl.pos as pos
FROM main.rechko_lemma rl
LEFT JOIN rbe_lemma m
	ON m.lemma_with_stress = rl.name_stressed
	AND rl.pos = m.pos;

CREATE INDEX idx_lemma_id ON lemma(lemma_id);
CREATE TRIGGER trg_lemma_id AFTER INSERT ON lemma
WHEN NEW.lemma_id IS NULL
BEGIN
	UPDATE lemma SET lemma_id = (SELECT MAX(lemma_id) + 1 FROM lemma)
	WHERE ROWID = NEW.ROWID;
END;

INSERT INTO lemma SELECT
	NULL as lemma_id,
	lemma as name,
	COALESCE(lemma_with_stress, lemma) as name_stressed,
	'rbe' as source,
	m.source_definition,
	m.pos as pos
FROM rbe_lemma m
LEFT JOIN rechko_lemma rl
	ON m.lemma_with_stress = rl.name_stressed
	AND m.pos = rl.pos
WHERE rl.name_stressed IS NULL;
