BEGIN TRANSACTION;

-- join all wordforms from the morphological dictionary (slovnik_wordform table)
-- with their corresponding lemmata and stresses from the RBE dictionary (lemma table)
INSERT INTO wordform SELECT
	s.wordform as wordform,
	CASE WHEN s.is_lemma = 1 THEN COALESCE(l.name_stressed, s.wordform) ELSE s.wordform END AS wordform_stressed,
	l.lemma_id as lemma_id,
	s.is_lemma as is_lemma,
	s.tag as tag,
	'slovnik' as source,
	s.num_syllables as num_syllables
FROM
	slovnik_wordform s
LEFT JOIN
	lemma l
ON
	s.lemma = l.name AND 
	SUBSTR(s.tag, 1, 1) = l.pos
WHERE (SELECT COUNT(*) FROM wordform w WHERE w.wordform = s.wordform and w.tag = s.tag) == 0;

END TRANSACTION;
