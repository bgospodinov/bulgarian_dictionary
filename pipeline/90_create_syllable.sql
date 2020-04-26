DROP TABLE IF EXISTS syllable;

CREATE TABLE syllable (
  syllable_id INTEGER PRIMARY KEY,
  wordform_id INT(11),
  position INT(2),
  is_stressed BOOLEAN DEFAULT 0,
  FOREIGN KEY(wordform_id) REFERENCES wordform(wordform_id)
  ON DELETE CASCADE
);
