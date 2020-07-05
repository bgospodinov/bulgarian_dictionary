BEGIN TRANSACTION;

ALTER TABLE unigram ADD num_syllables INTEGER;
UPDATE unigram SET num_syllables = count_syllables(wordform), frequency = REPLACE(frequency, ',', '');

END TRANSACTION;