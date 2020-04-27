DROP TABLE IF EXISTS syllable;

CREATE TABLE syllable (
  syllable_id INTEGER PRIMARY KEY,
  pronunciation_id INT,
  wordform_id INT,
  syllable TEXT,
  onset TEXT,
  nucleus TEXT,
  coda TEXT,
  position INT(2),
  offset INT(2),
  is_stressed BOOLEAN DEFAULT 0,
  is_open BOOLEAN GENERATED ALWAYS AS (CASE WHEN LENGTH(coda) > 0 THEN 0 ELSE 1 END) STORED, -- only supported in sqlite >= 3.31.0
  FOREIGN KEY(pronunciation_id) REFERENCES pronunciation(pronunciation_id) ON DELETE CASCADE,
  FOREIGN KEY(wordform_id) REFERENCES wordform(wordform_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_syllable_pronunciation_id ON syllable(pronunciation_id);
CREATE INDEX IF NOT EXISTS idx_syllable_wordform_id ON syllable(wordform_id);
CREATE INDEX IF NOT EXISTS idx_syllable_syllable ON syllable(syllable);
CREATE INDEX IF NOT EXISTS idx_syllable_position ON syllable(position);