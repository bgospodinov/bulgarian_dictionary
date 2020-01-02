DROP TABLE IF EXISTS rbe_lemma;

CREATE TABLE rbe_lemma (
  lemma VARCHAR(100),
  lemma_with_stress VARCHAR(100),
  source_definition TEXT
);