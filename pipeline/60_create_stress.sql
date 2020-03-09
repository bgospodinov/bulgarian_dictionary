DROP TABLE IF EXISTS stress;

CREATE TABLE stress (
  stress_id INTEGER PRIMARY KEY,
  wordform_id INT(11),
  position INT(2),
  FOREIGN KEY(wordform_id) REFERENCES wordform(wordform_id)
  ON DELETE CASCADE
);
