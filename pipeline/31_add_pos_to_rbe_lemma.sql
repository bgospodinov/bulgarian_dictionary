BEGIN TRANSACTION;
-- don't remove from here, because rbe import file does not have this column and throws a warning during import
ALTER TABLE rbe_lemma ADD pos CHAR(4);

UPDATE rbe_lemma SET pos = 'D'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>нареч." OR "нареч. от" OR "нареч. разг." OR "спец. нареч." OR "нареч.</"');

UPDATE rbe_lemma SET pos = 'A'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>прил." OR "мн. прил." OR "остар. прил." OR "прил.</i>" OR "прил от</i>" OR "прил. Остар."');

UPDATE rbe_lemma SET pos = 'V'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>несв."');

UPDATE rbe_lemma SET pos = 'C'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>съюз."');

UPDATE rbe_lemma SET pos = 'T'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>частица" OR "Първа съставна част" OR "Втора съставна част"');

UPDATE rbe_lemma SET pos = 'I'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>междум."');

UPDATE rbe_lemma SET pos = 'Ncm'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>м."');

UPDATE rbe_lemma SET pos = 'Ncf'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>ж."');

UPDATE rbe_lemma SET pos = 'Ncn'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>ср."');

UPDATE rbe_lemma SET pos = 'R'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>предл."');

UPDATE rbe_lemma SET pos = 'M'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>числ."');

-- fix exceptions
UPDATE rbe_lemma SET pos = 'A'
WHERE pos IS NULL AND lemma IN ('полуграмотен');

UPDATE rbe_lemma SET pos = 'N'
WHERE pos IS NULL AND lemma IN ('поляни', 'померанци');

-- all the rest are assumed to be verbs
UPDATE rbe_lemma SET pos = 'V' WHERE pos IS NULL;

END TRANSACTION;