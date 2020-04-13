BEGIN TRANSACTION;

-- adds trivial stress to monosyllabic words
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma_stressed, 1)
WHERE num_syllables = 1 AND num_stresses = 0;

-- adds stress to murdarov lemmata that dont have it
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma_stressed, num_syllables)
WHERE source = 'murdarov' AND num_stresses = 0;

-- here we use the fact thah some suffixes are very likely (or not) to be stressed, especially as heuristic for disyllabic words
-- e.g. always stress first syllable of disyllabic adjectives ending in -ов
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ов' AND pos = 'A';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ис' AND pos LIKE 'Nc%';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ок' AND lemma_id not in (84346);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ак';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%як';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ан' and pos = 'Ncm' and lemma_id NOT IN (35191, 35518, 31732);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ян' and pos = 'Ncm';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%яр' and pos = 'Ncm';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ун' and pos = 'Ncm' ;

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ел' AND lemma_id not in (36621, 119194);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ер';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%вед' AND pos = 'Ncm';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%въд' ;

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%яд';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ар';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%рък' AND lemma NOT LIKE '%ярък' AND pos = 'A';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ач';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%тел' AND pos != 'Np' AND lemma_id NOT IN (31436, 35036, 35790);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%еж' AND lemma_id NOT IN (33067);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables = 3 AND num_stresses = 0 AND lemma LIKE '%ница' AND lemma_id NOT IN (14735, 18621, 19087, 21069, 21097, 22700);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%нича' AND lemma_id NOT IN (96881, 102265, 100420, 100428, 180802);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%авица' and pos = 'Ncf' AND lemma_id NOT IN (72692, 23085);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%алня' and pos = 'Ncf';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ачка' and pos = 'Ncf';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%итба' and pos = 'Ncf';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%улка' and pos = 'Ncf';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%урка' and pos = 'Ncf';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%алище' and pos = 'Ncn';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ало' and pos = 'Ncn';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ение' and pos = 'Ncn';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ание' and pos = 'Ncn';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%овище' and pos = 'Ncn';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ат' AND lemma_id NOT IN (33690);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ебен' and lemma_id NOT IN (4665, 109888);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ив' and pos = 'A';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%есен' and pos = 'A';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%мина' and pos = 'M';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%авам' and pos = 'V';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%явам' and pos = 'V';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 2)
WHERE num_syllables > 2 AND num_stresses = 0 AND lemma LIKE '%ие' and pos LIKE 'N%' AND lemma_id NOT IN(39281, 40870, 42146);

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables = 2 AND num_stresses = 0 AND lemma LIKE '%ост';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables > 0 AND num_stresses = 0 AND lemma LIKE '%ест' and pos != 'Np';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
where num_stresses = 0 and pos = 'Ncm' and num_syllables = 2 and lemma like '%инг';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
where num_stresses = 0 and pos = 'Ncm' and num_syllables = 2 and lemma like '%ий';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
where num_stresses = 0 and pos = 'Ncm' and num_syllables = 2 and lemma like '%ър';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
where num_stresses = 0 and pos = 'Ncm' and num_syllables = 2 and lemma like '%ьо';

UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
where num_stresses = 0 and pos = 'Ncm' and num_syllables = 2 and lemma like '%чо';

-- stress lemma that are duplicated with the same stress as their siblings
UPDATE lemma
SET lemma_stressed = IFNULL(
	(select l2.lemma_stressed from lemma l2
	where lemma.lemma = l2.lemma
	and lemma.lemma_id != l2.lemma_id
	and l2.num_stresses > 0
	and SUBSTR(lemma.pos, 1, 1) = SUBSTR(l2.pos, 1, 1)),
	lemma.lemma_stressed
)
where lemma.num_stresses = 0;

-- most verbs (84%) have stress on their penultimate syllable, for the rest it is on the last syllable (with very few exceptions)
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables = 2 AND num_stresses = 0 and pos = 'V' and lemma in (
    'дъхтя', 'кълбя', 'сърбя', 'лумтя', 'рося', 'сладя',
    'хладя', 'снежа', 'двоя', 'слоя', 'дуя', 'плуя',
    'скривя', 'сдуша', 'спеша', 'вдълбя', 'взломя', 'вледя',
    'влудя', 'вплътня', 'вродя', 'вталя', 'свеня', 'сградя',
    'сдвоя', 'снизя', 'спластя', 'стъмня', 'вклиня', 'сговня',
    'стъжня', 'сноша', 'удам', 'превра', 'всмърдя', 'възвря',
    'повря', 'превря', 'развря', 'слетя', 'вмета', 'впреда',
    'втреса', 'враста', 'всека', 'вчета', 'еба', 'смълча',
    'поям', 'доспя', 'отспя', 'отям', 'приям', 'отща', 'прища',
    'поям', 'презра', 'гоя', 'боде', 'боли', 'вали', 'втресе',
    'върви', 'горчи', 'доспи', 'доще', 'здрачи', 'люти',
    'мързи', 'отще', 'поще', 'приспи', 'прище', 'тежи',
    'роси', 'ръми', 'слади', 'смрачи', 'снежи', 'стъмни',
    'тресе', 'цари', 'завря', 'зоря', 'мъгля', 'мълзя',
    'помра', 'сгоря', 'сдробя', 'словя', 'смърся', 'сребря',
    'студя', 'стървя', 'сцедя', 'троя', 'тумтя', 'томя',
    'тълмя', 'търня', 'фиря', 'хитря', 'хруптя', 'язвя'
);

-- assume penultimate stress for the rest
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables = 2 AND num_stresses = 0 and pos = 'V';

-- 85% of disyllabic Ncf is stressed on penultimate syllable
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables = 2 AND num_stresses = 0 and pos = 'Ncf' and lemma in (
    'свръхмощ', 'катма', 'дрисня', 'пикня', 'скрипя', 'смутня',
    'тъпня', 'фукня', 'черпня', 'свръхсплав', 'секснощ', 'спецчаст',
    'евзон', 'мадам', 'махла', 'мъзда', 'ритня', 'тасма'
);

-- assume penultimate stress for the rest
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables = 2 AND num_stresses = 0 and pos = 'Ncf';

-- 70% of disyllabic Ncm is stressed on last syllable
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables - 1)
WHERE num_syllables = 2 AND num_stresses = 0 and pos = 'Ncm' and lemma in (
    'тайбрек', 'тъчпад', 'тъчскрийн', 'фейсбук', 'фейслифт', 'фрийстайл', 'хардкор', 'айдъл',
    'булшит', 'бърбън', 'допуск', 'енджин', 'епъл', 'изглас', 'изказ', 'изрез', 'йогурт', 'каперс',
    'капсул', 'каркас', 'карлсберг', 'карнет', 'картоп', 'картридж', 'келвин',
    'киликс', 'кокпит', 'команч', 'конкум', 'концепт', 'кончов', 'кортекс',
    'кромлех', 'левъл', 'лейбъл', 'лексус', 'линкълн', 'магнум', 'макрос', 'Маргин',
    'маржин', 'матрикс', 'метъл', 'мишунг', 'морбил', 'морон',
    'мъпет', 'ориндж', 'отврат', 'памперс', 'паунд',  'пеналт',
    'пикчърс', 'пинбол', 'питбул', 'питлейн', 'плейлист',   'плимут',
    'плъгин', 'попъп', 'преслап', 'примас', 'припас', 'прицеп', 'провес',
    'профайл', 'пфениг',  'разсип', 'райком', 'резус', 'ролекс', 'самсунг',
    'санпласт', 'сексроб', 'сексфилм', 'сетбол', 'сешън', 'сименс', 'симплекс',
    'ситком', 'скендъл', 'скинхед', 'скрабъл', 'скрупул', 'слоган', 'смартфон',
    'сникърс',  'сокет',  'софтбол', 'софткор',  'спандекс', 'стейшън', 'стилет', 'сторидж',
    'суплекс', 'сървлет', 'талвег', 'тамбур', 'татус', 'телбод', 'тетрев', 'техникс',  'топлес', 'трайбъл',
    'тракшън', 'требъл', 'тременс', 'туборг', 'тъчпад', 'тъчскрийн', 'ултрас',
    'уплах', 'фасет', 'фейслифт', 'фешън', 'фикшън', 'филипс', 'форинт', 'франчайз', 'фрийстайл',
    'футзал', 'фюжън', 'фючърс', 'хайбол',  'хардкор',
    'хоркрукс',   'цикас', 'циркус', 'чадор', 'чекпойнт', 'ченъл', 'чикън', 'чипсет', 'шлаух',
    'шумол', 'щолен', 'ърбън', 'юникс', 'юнит',  'батсмен',
    'гоблин', 'грийнхорн', 'зулус', 'клитор',  'компир', 'кустос', 'могол',  'претор',
    'тайсън', 'херолд', 'хобит', 'юрод', 'русин', 'приказ', 'батик', 'готик', 'квасник',
    'клашник', 'кодек', 'крайшник', 'кубрик', 'листник', 'лучник', 'мимик', 'нетбук',
    'пчелник', 'ровник', 'сивик', 'сладник', 'снежник', 'стрелник', 'струнник', 'съсък',
    'тайбрек', 'тайник', 'тупик', 'фейсбук', 'фийдбек', 'хай-тек', 'ходник', 'хроник',
    'гадник', 'зуек', 'къщник', 'стражник', 'страшник', 'хулник',  'сървей',
    'калец', 'колец', 'сърнец', 'щипец', 'джингъл', 'спазъм', 'вартбург', 'кърчаг',
    'самсунг', 'туборг', 'Странджа', 'чичка', 'чукча', 'Етър', 'Лувър',
    'Гошо', 'зайко', 'зайо', 'мурджо', 'рамбо', 'снежко', 'сръчко',
    'хахо',   'шаро', 'ардъч', 'близък', 'бонза', 'желъд', 'запив', 'зарив', 'заръч', 'змейно',
    'издих', 'камен', 'кечуп', 'кечъп', 'клирос', 'клубен',  'крякот',
    'лелин', 'лепет', 'ликтор', 'лимец', 'логой', 'лодос',
    'магнет',  'молберт', 'момко',  'панцир', 'плътник', 'привод',
    'приглед', 'пробир', 'пролез', 'просек', 'пукъл', 'рабиц', 'росен', 'рупец',
    'ръбец',  'свършък', 'серей', 'сечник',  'скокот', 'скрежец',
    'скъпец', 'сламник', 'слапей',  'служещ', 'сметник', 'сопот', 'спонец',
    'столник', 'стратор', 'стрико', 'стропник', 'стълбец', 'схимник', 'съвлек',
    'сърпец', 'съсек', 'талог',   'тетин', 'тилник', 'титър',
    'тлъчник', 'топот', 'тревник', 'тъжек', 'тълчник', 'търсей', 'фьотър', 'хлопот',
    'хумник', 'цванец', 'цвъркот', 'църкот', 'чашник', 'черен', 'чукот', 'шерпа', 'шляхтич'
);

-- assume ultimate stress for the rest
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma, num_syllables)
WHERE num_syllables = 2 AND num_stresses = 0 and pos = 'Ncm';

END TRANSACTION;