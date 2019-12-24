DROP TABLE IF EXISTS slovnik_wordform;

CREATE TABLE slovnik_wordform (
	id INTEGER PRIMARY KEY,
	wordform VARCHAR(45),
	lemma VARCHAR(45),
	tag VARCHAR(25),
	is_lemma BOOLEAN DEFAULT 0,
	num_syllables INT(2)
);
