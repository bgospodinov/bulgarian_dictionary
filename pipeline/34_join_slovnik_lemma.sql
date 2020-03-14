BEGIN TRANSACTION;

INSERT INTO lemma (
	lemma, lemma_stressed, pos, source, num_syllables
) SELECT
    s.lemma as lemma,
    s.lemma as lemma_stressed,
    SUBSTR(s.tag, 1, 1) as pos,
    'slovnik' as source,
    COUNT_SYLLABLES(s.wordform) as num_syllables
FROM slovnik_wordform s
WHERE s.is_lemma = 1 AND 
(SELECT COUNT(*) FROM lemma WHERE lemma = s.wordform and pos = SUBSTR(s.tag, 1, 1)) = 0;

END TRANSACTION;
