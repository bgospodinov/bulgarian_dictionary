DROP TABLE IF EXISTS unigram;
CREATE TABLE unigram (wordform, frequency);
CREATE UNIQUE INDEX IF NOT EXISTS idx_unigram_wordform ON unigram(wordform);