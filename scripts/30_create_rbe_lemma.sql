DROP TABLE IF EXISTS lemma;

CREATE TABLE lemma (
  id INTEGER PRIMARY KEY,
  name VARCHAR(100),
  name_with_stress VARCHAR(100),
  source_definition TEXT
);

CREATE INDEX IF NOT EXISTS idx_name ON lemma(name);
