-- set all words starting with capital letter as named entities
UPDATE lemma
SET ner = 'other'
WHERE UNICODE(lemma) < UNICODE('а');

UPDATE lemma
SET ner = 'place'
WHERE ner = 'other' AND
(
	(lemma_id >= 23645 AND lemma_id <= 27040) OR
	(lemma_id >= 82995 AND lemma_id <= 111432)
);

UPDATE lemma
SET ner = 'name_male'
WHERE ner = 'other' AND
(
	(lemma_id >= 45844 AND lemma_id <= 55795) OR
	(lemma_id >= 111433 AND lemma_id <= 114074)
);

UPDATE lemma
SET ner = 'name_female'
WHERE ner = 'other' AND
(
	(lemma_id >= 114075 AND lemma_id <= 114410)
);
