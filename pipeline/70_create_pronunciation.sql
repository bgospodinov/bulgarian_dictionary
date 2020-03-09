DROP TABLE IF EXISTS pronunciation;

CREATE TABLE pronunciation (
  pronunciation_id INTEGER PRIMARY KEY,
  wordform_id INT(11),
  pronunciation TEXT,
  FOREIGN KEY(wordform_id) REFERENCES wordform(wordform_id)
  ON DELETE CASCADE
);
