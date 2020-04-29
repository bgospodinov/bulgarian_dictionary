BEGIN TRANSACTION;

-- deal with reflexives
UPDATE slovnik_wordform
SET
	lemma = SUBSTR(lemma, 1, LENGTH(lemma) - 3),
	wordform = SUBSTR(wordform, 1, LENGTH(wordform) - 3),
	pos = 'Vr'
WHERE lemma LIKE '% си' AND pos = 'V';

INSERT INTO lemma (
	lemma, lemma_stressed, pos, source, num_syllables
) SELECT
	s.lemma as lemma,
	s.lemma as lemma_stressed,
	s.pos as pos,
	'slovnik' as source,
	COUNT_SYLLABLES(s.wordform) as num_syllables
FROM slovnik_wordform s
WHERE s.is_lemma = 1 AND
(SELECT COUNT(*) FROM lemma WHERE lemma = s.wordform and pos = s.pos) = 0;

END TRANSACTION;