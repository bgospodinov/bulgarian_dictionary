BEGIN TRANSACTION;

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

-- fix some mistakes in rechko
UPDATE main.rechko_lemma SET pos = 'V' WHERE name = 'недей';
UPDATE main.rechko_lemma SET name_stressed = name WHERE name_stressed IS NULL;

-- fix accidental double stressing
UPDATE main.rechko_lemma SET name_stressed = 'боя`' WHERE id = 114442;

-- fix other stressing mistakes
UPDATE main.rechko_lemma SET name_stressed = 'чета`' WHERE id = 98942;
UPDATE main.rechko_lemma SET name_stressed = 'хиля`да' WHERE id = 102948;

-- fix some spelling mistakes
UPDATE main.rechko_lemma SET name = 'четиринайсет', name_stressed = 'четирина`йсет' WHERE id = 102923;
DELETE FROM main.rechko_lemma WHERE id = 782; -- прираст is misspelled as приръст

-- this helps evade rechko mismatches for reflexive verbs and adjectives
UPDATE main.rechko_lemma SET name = REPLACE(name, ' се', ''), name_stressed = REPLACE(name_stressed, ' се', '')
WHERE classification = 'reflexive' or classification = '+reflexive';

-- here we join rechko and rbe lemmata, but lemma_id column contains repetitions
CREATE TEMPORARY TABLE _lemma_ AS SELECT
	rl.id as lemma_id,
	rl.name as lemma,
	COALESCE(rl.name_stressed, rl.name) AS lemma_stressed,
	rl.source,
	CASE WHEN COALESCE(m.source_definition, rl.meaning) IS NULL
		THEN NULL
		ELSE IFNULL(m.source_definition, '') || IFNULL(rl.meaning, '')
	END AS source_definition,
	rl.pos as pos
FROM main.rechko_lemma rl
LEFT JOIN rbe_lemma m
	ON m.lemma_with_stress = rl.name_stressed -- monosyllabic words are not marked as stressed in either rbe and rechko
	AND rl.pos = m.pos;

-- here we autoincrement lemma_id correctly to make it unique
CREATE TABLE lemma (
	lemma_id INTEGER PRIMARY KEY,
	derivative_id INT,
	lemma,
	lemma_stressed,
	definition TEXT,
	derivative_type TEXT,
	ner TEXT,
	pos TEXT,
	source TEXT,
	num_syllables INT,
	num_stresses INT GENERATED ALWAYS AS (LENGTH(lemma_stressed) - LENGTH(REPLACE(lemma_stressed, '`', ''))) STORED, -- only supported in sqlite >= 3.31.0
	FOREIGN KEY(derivative_id) REFERENCES lemma(lemma_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO lemma (
	lemma_id, lemma, lemma_stressed, definition, pos, source, num_syllables
) SELECT
	CASE WHEN repetition > 0 
		THEN (SELECT MAX(lemma_id) FROM _lemma_) + offset
		ELSE lemma_id 
	END AS lemma_id,
	lemma,
	lemma_stressed,
	source_definition as definition,
	pos,
	source,
	COUNT_SYLLABLES(lemma) as num_syllables
FROM
(
	SELECT
		SUM(repetition) OVER win2 AS offset,
		*
	FROM
	(
		SELECT
			lag(1, 1, 0) OVER win1 AS repetition,
			*
		FROM _lemma_
		WINDOW win1 AS (PARTITION BY lemma_id)
	)
	WINDOW win2 AS (ORDER BY lemma_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_lemma_lemma_id ON lemma(lemma_id);
CREATE TRIGGER trg_lemma_id AFTER INSERT ON lemma
WHEN NEW.lemma_id IS NULL
BEGIN
	UPDATE lemma SET lemma_id = (SELECT MAX(lemma_id) + 1 FROM lemma)
	WHERE ROWID = NEW.ROWID;
END;

INSERT INTO lemma (
	lemma, lemma_stressed, definition, pos, source, num_syllables
) SELECT
	lemma,
	COALESCE(lemma_with_stress, lemma) as lemma_stressed,
	m.source_definition as definition,
	m.pos as pos,
	'rbe' as source,
	COUNT_SYLLABLES(lemma) as num_syllables
FROM rbe_lemma m
LEFT JOIN rechko_lemma rl
	ON m.lemma_with_stress = rl.name_stressed
	AND m.pos = rl.pos
WHERE rl.name_stressed IS NULL;

END TRANSACTION;
