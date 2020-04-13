BEGIN TRANSACTION;

DELETE FROM slovnik_wordform WHERE wordform = 'хилядо' and tag = 'Mc-pi';

-- join all wordforms from the morphological dictionary (slovnik_wordform table)
-- with their corresponding lemmata and stresses from the RBE dictionary (lemma table)
INSERT INTO wordform (lemma_id, wordform, wordform_stressed, is_lemma, tag, source, num_syllables)
SELECT
	l.lemma_id as lemma_id,
	s.wordform as wordform,
	CASE WHEN s.is_lemma = 1 THEN COALESCE(l.lemma_stressed, s.wordform) ELSE s.wordform END AS wordform_stressed,
	s.is_lemma as is_lemma,
	s.tag as tag,
	'slovnik' as source,
	s.num_syllables as num_syllables
FROM
	slovnik_wordform s
LEFT JOIN
	lemma l
ON
	s.lemma = l.lemma AND
	s.pos = l.pos
WHERE (SELECT COUNT(*) FROM wordform w WHERE w.wordform = s.wordform AND w.tag = s.tag) == 0;

-- add lemma manually for some slovnik wordforms
UPDATE wordform
SET lemma_id = (SELECT lemma_id FROM lemma WHERE lemma = 'повече' AND pos = 'M' AND source LIKE '%slovnik%')
WHERE wordform = 'повечето' AND lemma_id IS NULL;

END TRANSACTION;
