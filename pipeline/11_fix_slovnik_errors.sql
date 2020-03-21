UPDATE slovnik_wordform
SET wordform = REPLACE(wordform, 'е', 'я')
WHERE lemma = 'додрямва';

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'всякъде',
    num_syllables = 3
WHERE lemma = 'всякъде';

INSERT INTO slovnik_wordform
VALUES ('всъде', 'всъде', 'Pcl', 1, 2);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'къде',
    num_syllables = 2
WHERE lemma = 'къде';

INSERT INTO slovnik_wordform
VALUES ('где', 'где', 'Pil', 1, 1);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'където',
    num_syllables = 3
WHERE lemma = 'където';

INSERT INTO slovnik_wordform
VALUES ('гдето', 'гдето', 'Prl', 1, 2);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'кога',
    num_syllables = 2
WHERE lemma = 'кога';

INSERT INTO slovnik_wordform
VALUES ('докога', 'докога', 'Pit', 1, 3);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'когато',
    num_syllables = 3
WHERE lemma = 'когато';

INSERT INTO slovnik_wordform
VALUES ('докогато', 'докогато', 'Prt', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'колко',
    num_syllables = 2
WHERE lemma = 'колко';

INSERT INTO slovnik_wordform
VALUES ('доколко', 'доколко', 'Piq', 1, 3);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'колкото',
    num_syllables = 3
WHERE lemma = 'колкото';

INSERT INTO slovnik_wordform
VALUES ('доколкото', 'доколкото', 'Prq', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'никъде',
    num_syllables = 3
WHERE lemma = 'никъде';

INSERT INTO slovnik_wordform
VALUES ('доникъде', 'доникъде', 'Pnl', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'някъде',
    num_syllables = 3
WHERE lemma = 'някъде';

INSERT INTO slovnik_wordform
VALUES ('донякъде', 'донякъде', 'Pfl', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'там',
    num_syllables = 1
WHERE lemma = 'там';

INSERT INTO slovnik_wordform
VALUES ('дотам', 'дотам', 'Pdl', 1, 2);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'тогава',
    num_syllables = 3
WHERE lemma = 'тогава';

INSERT INTO slovnik_wordform
VALUES ('дотогава', 'дотогава', 'Pdt', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'толкова',
    num_syllables = 3
WHERE lemma = 'толкова';

INSERT INTO slovnik_wordform
VALUES ('дотолкова', 'дотолкова', 'Pdq', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'някак',
    num_syllables = 2
WHERE lemma = 'някак';

INSERT INTO slovnik_wordform
VALUES ('еди-как си', 'еди-как си', 'Pfm', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'някаква',
    num_syllables = 3
WHERE lemma = 'някаква';

INSERT INTO slovnik_wordform
VALUES ('еди-каква си', 'еди-каква си', 'Pfa--s-f', 1, 5);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'някакви',
    num_syllables = 3
WHERE lemma = 'някакви';

INSERT INTO slovnik_wordform
VALUES ('еди-какви си', 'еди-какви си', 'Pfa--p', 1, 5);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'някакво',
    num_syllables = 3
WHERE lemma = 'някакво';

INSERT INTO slovnik_wordform
VALUES ('еди-какво си', 'еди-какво си', 'Pfa--s-n', 1, 5);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'някога',
    num_syllables = 3
WHERE lemma = 'някога';

INSERT INTO slovnik_wordform
VALUES ('еди-кога си', 'еди-кога си', 'Pft', 1, 5);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'това-онова',
    num_syllables = 5
WHERE lemma = 'това-онова';

INSERT INTO slovnik_wordform
VALUES ('едно-друго', 'едно-друго', 'Pfe--s-n', 1, 4);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'така',
    num_syllables = 2
WHERE lemma = 'така';

INSERT INTO slovnik_wordform
VALUES ('инак', 'инак', 'Pdm', 1, 2);

-------------------

UPDATE slovnik_wordform
SET
    wordform = 'мене',
    num_syllables = 2
WHERE lemma = 'мене';

INSERT INTO slovnik_wordform
VALUES ('мен', 'мен', 'Ppelas1', 1, 1);

-------------------

UPDATE slovnik_wordform
SET
    is_lemma = 1
WHERE wordform IN (
    'година-две', 'два-три', 'двайсетина', 'двамка',
    'дванадесетина', 'дванайсетина', 'две', 'две-три', 
    'двенки', 'двесте', 'двечки', 'деветмина', 'ден-два', 
    'десет-петнадесет', 'десет-петнайсет', 'десетина-дванадесет', 
    'десетина-дванайсет', 'десетина-единадесет', 'десетина-единайсет', 
    'десетина-петнадесет', 'десетина-петнайсет', 'един-два', 'единайсетина', 
    'лев-два', 'миг-два', 'минута-две', 'неколкостотин', 'пет-шест', 
    'пет-шестима', 'пет-шестина', 'пет-шестстотин', 'петнайсетина', 
    'половин', 'половина', 'седем-осем', 'седмина', 
    'сто-двеста', 'стотина', 'три-четирима', 'тридесетина', 
    'трийсетина', 'трима', 'тримца', 'тринки', 'трички', 'троица', 
    'час-два', 'четворица', 'четвърт', 'четиридесетина', 
    'четирийсетина', 'четирима', 'четиринайсет', 'четирма', 'шейсет', 
    'шейсетина', 'шестдесетина', 'шестима', 'шестнадесетина', 'шестнайсетина',
    'стотина-двеста'
);