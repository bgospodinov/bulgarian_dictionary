BEGIN TRANSACTION;

UPDATE rbe_lemma SET lemma = 'войнстващ', lemma_with_stress = 'во`йнстващ' WHERE lemma = 'войнстващ  войнствуващ';
UPDATE rbe_lemma SET lemma = 'бъх', lemma_with_stress = 'бъх' WHERE lemma = 'бъ х';
UPDATE rbe_lemma SET lemma_with_stress = 'га`' WHERE lemma = 'га';
UPDATE rbe_lemma SET pos = 'Ncm' WHERE lemma = 'гъзар' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'опа`рям' WHERE lemma_with_stress = 'опаря`м' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'петдесе`ти' WHERE lemma_with_stress = 'петдесети`' AND pos = 'M';
UPDATE rbe_lemma SET pos = 'Ncm' WHERE lemma IN ('ден', 'двор', 'пол', 'ом', 'оджак', 'драмкръжок') AND pos != 'Ncm';
UPDATE rbe_lemma SET lemma = 'Бабинден', lemma_with_stress = 'Ба`бинден' WHERE lemma = 'бабинден' AND pos = 'Ncm';

-- separates words that have two possibl stresses
UPDATE rbe_lemma SET lemma_with_stress = 'боклу`ча' WHERE lemma_with_stress = 'боклу`ча`' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'бла`жа' WHERE lemma_with_stress = 'бла`жа`' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'ви`ся' WHERE lemma_with_stress = 'ви`ся`' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'вре`дя' WHERE lemma_with_stress = 'вре`дя`' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'начого`ля' WHERE lemma_with_stress = 'начого`ля`' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'пра`ся' WHERE lemma_with_stress = 'пра`ся`' AND pos = 'V';

INSERT INTO rbe_lemma (lemma, lemma_with_stress, pos) VALUES
    ('боклуча', 'боклуча`', 'V'),
    ('вися', 'вися`', 'V'),
    ('вредя', 'вредя`', 'V'),
    ('начоголя', 'начоголя`', 'V'),
    ('прася', 'прася`', 'V')
;

END TRANSACTION;