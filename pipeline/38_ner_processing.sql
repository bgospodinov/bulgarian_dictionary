BEGIN TRANSACTION;

-- set all words starting with capital letter as named entities
UPDATE lemma
SET ner = 'other'
WHERE UNICODE(lemma) < UNICODE('а');

UPDATE lemma
SET ner = 'place'
WHERE lemma_id IN (
	SELECT id FROM rechko_lemma WHERE speech_part IN 
		('name_bg-various', 'name_bg-place', 'name_capital', 'name_city', 'name_country', 'name_various')
);

UPDATE lemma
SET ner = 'name'
WHERE lemma_id IN (
	SELECT id FROM rechko_lemma WHERE speech_part IN 
		('name_people_family', 'name_people_name', 'name_popular')
);

END TRANSACTION;