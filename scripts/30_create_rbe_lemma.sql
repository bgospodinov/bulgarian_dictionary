DROP TABLE IF EXISTS lemma;

CREATE TABLE lemma (
  lemma VARCHAR(100),
  lemma_with_stress VARCHAR(100),
  source_definition TEXT
);

CREATE INDEX IF NOT EXISTS idx_lemma ON lemma(lemma);