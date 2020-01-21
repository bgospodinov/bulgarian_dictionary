ALTER TABLE rbe_lemma ADD pos CHAR(1);

UPDATE rbe_lemma SET pos = "D"
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>нареч." OR "нареч. от" OR "нареч. разг." OR "спец. нареч." OR "нареч.</"');

UPDATE rbe_lemma SET pos = "A"
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>прил." OR "мн. прил." OR "остар. прил." OR "прил.</i>" OR "прил от</i>" OR "прил. Остар."');

UPDATE rbe_lemma SET pos = "V"
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>несв."');

UPDATE rbe_lemma SET pos = "N"
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>м." OR "<i>ж." OR "<i>ср."');

UPDATE rbe_lemma SET pos = "R"
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>предл."');

UPDATE rbe_lemma SET pos = "M"
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>числ."');

-- fix exceptions
UPDATE rbe_lemma SET pos = "A"
WHERE pos IS NULL AND lemma IN ("полуграмотен");

UPDATE rbe_lemma SET pos = "N"
WHERE pos IS NULL AND lemma IN ("поляни", "померанци");

-- all the rest are assumed to be verbs
UPDATE rbe_lemma SET pos = "V" WHERE pos IS NULL;
