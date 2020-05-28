BEGIN TRANSACTION;
-- don't remove from here, because rbe import file does not have this column and throws a warning during import
ALTER TABLE rbe_lemma ADD comment TEXT;
ALTER TABLE rbe_lemma ADD pos CHAR(4);

UPDATE rbe_lemma SET pos = 'D'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>нареч." OR "нареч. от" OR "нареч. разг." OR "спец. нареч." OR "нареч.</"');

UPDATE rbe_lemma SET pos = 'A'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>прил." OR "мн. прил." OR "остар. прил." OR "прил.</i>" OR "прил от</i>" OR "прил. Остар."');

UPDATE rbe_lemma SET pos = 'V'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>несв."');

UPDATE rbe_lemma SET pos = 'C'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>съюз." OR "<i>съчинителен съюз."');

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

UPDATE rbe_lemma SET pos = 'P'
WHERE (pos IS NULL OR pos LIKE 'Nc%') AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"<i>местоим." OR "<i>показ. местоим." OR "<i>лич. местоим."');

-- pluralia tantum and singularia tantum
UPDATE rbe_lemma SET pos = 'N'
WHERE pos IS NULL AND ROWID IN (select ROWID from rbe_lemma_ft WHERE rbe_lemma_ft MATCH '"само <i>мн." OR "<i>мн. Истор." OR "обикн. <i>мн." OR "<i>ед."');

-- fix exceptions
UPDATE rbe_lemma SET pos = 'A'
WHERE pos IS NULL AND lemma IN ('полуграмотен', 'получер', 'всявгашен', 'глъбок', 'гот', 'ачигьоз', 'параспор', 'персон');

UPDATE rbe_lemma SET pos = 'D'
WHERE pos IS NULL AND lemma IN ('всявга', 'надол', 'отгор', 'отдол');

UPDATE rbe_lemma SET pos = 'Ncm'
WHERE pos IS NULL AND lemma IN ('преговор', 'геронт', 'гуверньор', 'бальор', 'покой');

UPDATE rbe_lemma SET pos = 'Ncn'
WHERE pos IS NULL AND lemma IN ('бельо');

UPDATE rbe_lemma SET pos = 'N'
WHERE pos IS NULL AND lemma IN ('печенези');

UPDATE rbe_lemma SET pos = 'M'
WHERE pos IS NULL AND lemma IN ('втор', 'едно');

UPDATE rbe_lemma SET pos = 'P'
WHERE pos IS NULL AND lemma IN ('онова', 'онез', 'онези', 'он', 'оназ', 'оногова', 'оногози', 'го', 'онаквоз', 'оногоз', 'едного', 'ной');

UPDATE rbe_lemma SET pos = 'R'
WHERE pos IS NULL AND lemma IN ('в', 'вов', 'до');

UPDATE rbe_lemma SET pos = 'T'
WHERE pos IS NULL AND lemma IN ('воз', 'во', 'вос', 'год', 'о', 'об', 'от', 'дор', 'по', 'под');

-- all the rest are assumed to be verbs
UPDATE rbe_lemma SET pos = 'V', comment = 'pos-assumed' WHERE pos IS NULL;

END TRANSACTION;
