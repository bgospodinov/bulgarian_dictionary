BEGIN TRANSACTION;

CREATE TABLE main.rechko_word_type AS SELECT * FROM rechko.word_type;

-- fix mistakes in rechko_word_type
UPDATE rechko_word_type SET speech_part = 'noun_male' WHERE id = 3;

CREATE TABLE main.rechko_lemma(
  id INTEGER PRIMARY KEY,
  name TEXT, name_stressed TEXT, name_broken TEXT,
  name_condensed TEXT, meaning TEXT, synonyms TEXT,
  classification TEXT, type_id INT, pronounciation TEXT,
  etymology TEXT, related_words TEXT, derived_words TEXT,
  chitanka_count INT, chitanka_percent REAL, chitanka_rank INT,
  search_count INT, source TEXT, other_langs TEXT,
  deleted_at NUM, corpus_count INT, corpus_percent INT,
  corpus_rank INT, "id:1" INT, "name:1" TEXT,
  idi_number INT, speech_part TEXT, comment TEXT,
  rules TEXT, rules_test TEXT, example_word TEXT,
  "speech_part:1" TEXT, pos TEXT
);

INSERT INTO main.rechko_lemma SELECT
	*,
	rwt.speech_part,
	CASE
		WHEN rwt.speech_part LIKE 'verb%' THEN 'V'
		WHEN rwt.speech_part = 'adjective' THEN 'A'
		WHEN rwt.speech_part = 'adverb' THEN 'D'
		WHEN rwt.speech_part LIKE 'pronominal%' THEN 'P'
		WHEN rwt.speech_part LIKE 'name%' THEN 'Np' -- proper nouns
		WHEN rwt.speech_part LIKE 'noun_plurale-tantum' THEN 'N' -- nouns only plural
		WHEN rwt.speech_part LIKE 'numeral%' THEN 'M'
		WHEN rwt.speech_part = 'conjunction' THEN 'C'
		WHEN rwt.speech_part = 'interjection' THEN 'I'
		WHEN rwt.speech_part = 'particle' THEN 'T'
		WHEN rwt.speech_part = 'preposition' THEN 'R'
		ELSE 'N' -- assumed to be common nouns
			|| CASE rwt.speech_part
					WHEN 'noun_male' THEN 'cm'
					WHEN 'noun_female' THEN 'cf'
					WHEN 'noun_neutral' THEN 'cn'
					ELSE '' -- abbreviation, other, phrase, prefix, suffix
				END
	END AS pos
FROM rechko.rechko_lemma rl
LEFT JOIN rechko_word_type rwt
	ON rl.type_id = rwt.id;

-- fix some mistakes in rechko
UPDATE main.rechko_lemma SET pos = 'V' WHERE name = 'недей';
UPDATE main.rechko_lemma SET name_stressed = name WHERE name_stressed IS NULL;
UPDATE main.rechko_lemma SET name = 'Мезозой', name_stressed = 'Мезозо`й' WHERE id = 84008;
UPDATE main.rechko_lemma SET name = 'екзистенц-минимум', name_stressed = 'екзисте`нц-ми`нимум' WHERE name_stressed = 'екзисте`нц-ми`ниму';

-- fix accidental double stressing
UPDATE main.rechko_lemma SET name_stressed = 'боя`' WHERE id = 114442;

UPDATE main.rechko_lemma SET name_stressed = remove_first_char(name_stressed, '`')
WHERE name_stressed IN (
	'осо`ля`вам'
);

-- fix other stressing mistakes
UPDATE main.rechko_lemma SET name_stressed = 'чета`' WHERE id = 98942;
UPDATE main.rechko_lemma SET name_stressed = 'просека`' WHERE id = 101830;
UPDATE main.rechko_lemma SET name_stressed = 'хиля`да' WHERE id = 102948;
UPDATE main.rechko_lemma SET name_stressed = 'разме`ням' WHERE id = 97770;
UPDATE main.rechko_lemma SET name_stressed = 'госпожа`' WHERE id = 83823;
UPDATE main.rechko_lemma SET name_stressed = 'клада`' WHERE id = 98937;

-- fix some spelling mistakes
-- dont forget to delete corresponding wordforms from rechko_wordform
UPDATE main.rechko_lemma SET name = 'четиринайсет', name_stressed = 'четирина`йсет' WHERE id = 102923;
UPDATE main.rechko_lemma SET pos = 'P' WHERE name_stressed = 'се`бе си';
DELETE FROM main.rechko_lemma WHERE id = 782; -- прираст is misspelled as приръст
DELETE FROM main.rechko_lemma WHERE id = 901; -- скуош is misspelled as скоуш

-- this helps evade rechko mismatches for reflexive verbs and participles
UPDATE main.rechko_lemma
SET
	name = REPLACE(name, ' се', ''),
	name_stressed = REPLACE(name_stressed, ' се', ''),
	pos = 'Vr'
WHERE classification = 'reflexive' or classification = '+reflexive';

UPDATE main.rechko_lemma
SET
	name = SUBSTR(name, 1, LENGTH(name) - 3),
	name_stressed = SUBSTR(name_stressed, 1, LENGTH(name_stressed) - 3),
	pos = 'Vr'
WHERE (name LIKE '% се' OR name LIKE '% ми' OR name LIKE '% си' OR name LIKE '% ме') AND pos != 'P';

-- some verbs have two particles attached at the end
UPDATE main.rechko_lemma
SET
	name = SUBSTR(name, 1, LENGTH(name) - 3),
	name_stressed = SUBSTR(name_stressed, 1, LENGTH(name_stressed) - 3),
	pos = 'Vr'
WHERE name LIKE '% ми';

-- separates words that have two possiblе stresses
CREATE TEMP TABLE lemmata_with_two_possible_stresses AS
VALUES ('на`пре`чно'), ('о`гни`ца'), ('пади`нка`');

INSERT INTO main.rechko_lemma (name, name_stressed, pos, source)
SELECT
    name, remove_last_char(name_stressed, '`'), pos, source
FROM main.rechko_lemma
WHERE name_stressed IN (
    SELECT * FROM lemmata_with_two_possible_stresses
);

UPDATE main.rechko_lemma
SET name_stressed = remove_first_char(name_stressed, '`')
WHERE name_stressed IN (
    SELECT * FROM lemmata_with_two_possible_stresses
);

DROP TABLE lemmata_with_two_possible_stresses;

-- here we join rechko and rbe lemmata, but lemma_id column contains repetitions
CREATE TEMPORARY TABLE _lemma_ AS SELECT
	rl.id as lemma_id,
	rl.name as lemma,
	COALESCE(rl.name_stressed, rl.name) AS lemma_stressed,
	CASE WHEN m.lemma IS NULL THEN rl.source ELSE 'rbe, ' || rl.source END AS source,
	CASE WHEN COALESCE(m.source_definition, rl.meaning) IS NULL
		THEN NULL
		ELSE IFNULL(m.source_definition, '') || IFNULL(rl.meaning, '')
	END AS source_definition,
	m.comment as comment,
	rl.pos as pos
FROM main.rechko_lemma rl
LEFT JOIN rbe_lemma m
	ON m.lemma_with_stress = rl.name_stressed -- monosyllabic words are not marked as stressed in either rbe and rechko
	AND rl.pos = m.pos;

-- here we autoincrement lemma_id correctly to make it unique
CREATE TABLE lemma (
	lemma_id INTEGER PRIMARY KEY,
	lemma,
	lemma_stressed,
	definition TEXT,
	comment TEXT,
	ner TEXT,
	pos TEXT,
	source TEXT DEFAULT 'manual',
	num_syllables INT,
	num_stresses INT GENERATED ALWAYS AS (LENGTH(lemma_stressed) - LENGTH(REPLACE(lemma_stressed, '`', ''))) STORED, -- only supported in sqlite >= 3.31.0
	accent_model TEXT
);

INSERT INTO lemma (
	lemma_id, lemma, lemma_stressed, definition, comment, pos, source, num_syllables
) SELECT
	CASE WHEN repetition > 0 
		THEN (SELECT MAX(lemma_id) FROM _lemma_) + offset
		ELSE lemma_id 
	END AS lemma_id,
	lemma,
	lemma_stressed,
	source_definition as definition,
	comment,
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
	lemma, lemma_stressed, definition, comment, pos, source, num_syllables
) SELECT
	lemma,
	COALESCE(lemma_with_stress, lemma) as lemma_stressed,
	m.source_definition as definition,
	m.comment,
	m.pos as pos,
	'rbe' as source,
	COUNT_SYLLABLES(lemma) as num_syllables
FROM rbe_lemma m
LEFT JOIN rechko_lemma rl
	ON m.lemma_with_stress = rl.name_stressed
	AND m.pos = rl.pos
WHERE rl.name_stressed IS NULL;

END TRANSACTION;
