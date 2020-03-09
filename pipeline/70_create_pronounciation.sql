DROP TABLE IF EXISTS pronounciation;

CREATE TABLE pronounciation (
  pronounciation_id INTEGER PRIMARY KEY,
  wordform_id INT(11),
  pronounciation TEXT,
  FOREIGN KEY(wordform_id) REFERENCES wordform(wordform_id)
  ON DELETE CASCADE
);
