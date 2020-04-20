DROP TABLE IF EXISTS pronunciation;

CREATE TABLE pronunciation (
  pronunciation_id INTEGER PRIMARY KEY,
  wordform_id INT(11),
  pronunciation TEXT,
  is_normative INT DEFAULT 1,
  FOREIGN KEY(wordform_id) REFERENCES wordform(wordform_id)
  ON DELETE CASCADE
);
