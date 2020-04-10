BEGIN TRANSACTION;

ALTER TABLE murdarov_lemma ADD lemma TEXT;

CREATE INDEX IF NOT EXISTS idx_murdarov_lemma_lemma ON murdarov_lemma(lemma);
CREATE INDEX IF NOT EXISTS idx_murdarov_lemma_lemma_stressed ON murdarov_lemma(lemma_stressed);

-- replace secondary stress indicators with primary stress counterparts
UPDATE murdarov_lemma
SET lemma_stressed = REPLACE(lemma_stressed, '´', '`');

UPDATE murdarov_lemma
SET lemma = REPLACE(lemma_stressed, '`', '');

END TRANSACTION;