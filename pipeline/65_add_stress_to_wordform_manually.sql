BEGIN TRANSACTION;

-- add words with two possible stress patterns (dubletni formi)
-- дар
INSERT INTO wordform (lemma_id, wordform, wordform_stressed, tag, num_syllables) VALUES
(269, 'дарът', 'да`рът', 'Ncmsf', 2),
(269, 'дара', 'да`ра', 'Ncmsh', 2),
(269, 'дари', 'да`ри', 'Ncmt', 2),
(269, 'дари', 'да`ри', 'Ncmpi', 2);

-- дроб


-- грък, влас
-- чинове, клонове, колове, родове, духове

END TRANSACTION;