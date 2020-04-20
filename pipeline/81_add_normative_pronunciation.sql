BEGIN TRANSACTION;

INSERT INTO pronunciation (wordform_id, pronunciation)
SELECT wordform_id, pronounce(wordform) FROM wordform;

END TRANSACTION;