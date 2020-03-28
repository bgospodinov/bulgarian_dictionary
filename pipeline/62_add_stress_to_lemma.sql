BEGIN TRANSACTION;

-- adds trivial stress to monosyllabic words
UPDATE lemma
SET lemma_stressed = stress_syllable(lemma_stressed, 1)
WHERE num_syllables = 1 AND num_stresses = 0;

-- adds stress to diminutive lemmata
UPDATE lemma
SET lemma_stressed = 
        stress_syllable(lemma.lemma_stressed, 
            find_nth_stressed_syllable_rev(
                IFNULL(
                    (SELECT l2.lemma_stressed FROM lemma l2 WHERE l2.lemma_id = lemma.derivative_id AND l2.num_stresses > 0),
                    lemma.lemma_stressed
                ), 1
            )
        )
WHERE lemma.derivative_type = 'diminutive' AND
    lemma.num_stresses = 0 AND
    lemma.derivative_id IS NOT NULL;

-- stress some numerals manually
UPDATE lemma SET lemma_stressed = 'два`йсет' WHERE lemma_id = 102901;
UPDATE lemma SET lemma_stressed = 'двана`йсет' WHERE lemma_id = 102903;
UPDATE lemma SET lemma_stressed = 'деветна`йсет' WHERE lemma_id = 102906;
UPDATE lemma SET lemma_stressed = 'едина`йсет' WHERE lemma_id = 102909;
UPDATE lemma SET lemma_stressed = 'осемна`йсет' WHERE lemma_id = 102912;
UPDATE lemma SET lemma_stressed = 'петна`йсет' WHERE lemma_id = 102915;
UPDATE lemma SET lemma_stressed = 'седемна`йсет' WHERE lemma_id = 102918;
UPDATE lemma SET lemma_stressed = 'три`йсет' WHERE lemma_id = 102920;
UPDATE lemma SET lemma_stressed = 'трина`йсет' WHERE lemma_id = 102922;
UPDATE lemma SET lemma_stressed = 'четири`йсет' WHERE lemma_id = 102925;
UPDATE lemma SET lemma_stressed = 'шестна`йсет' WHERE lemma_id = 102929;
UPDATE lemma SET lemma_stressed = 'о`сем' WHERE lemma_id = 102933;
UPDATE lemma SET lemma_stressed = 'два`йсети' WHERE lemma_id = 102955;
UPDATE lemma SET lemma_stressed = 'двана`десети' WHERE lemma_id = 102956;
UPDATE lemma SET lemma_stressed = 'двана`йсети' WHERE lemma_id = 102957;
UPDATE lemma SET lemma_stressed = 'деветна`йсети' WHERE lemma_id = 102961;
UPDATE lemma SET lemma_stressed = 'едина`йсети' WHERE lemma_id = 102964;
UPDATE lemma SET lemma_stressed = 'осемна`йсети' WHERE lemma_id = 102967;
UPDATE lemma SET lemma_stressed = 'петна`десети' WHERE lemma_id = 102971;
UPDATE lemma SET lemma_stressed = 'петна`йсети' WHERE lemma_id = 102972;
UPDATE lemma SET lemma_stressed = 'седемде`сети' WHERE lemma_id = 102973;
UPDATE lemma SET lemma_stressed = 'седемна`десети' WHERE lemma_id = 102974;
UPDATE lemma SET lemma_stressed = 'седемна`йсети' WHERE lemma_id = 102975;
UPDATE lemma SET lemma_stressed = 'три`йсети' WHERE lemma_id = 102979;
UPDATE lemma SET lemma_stressed = 'трина`йсети' WHERE lemma_id = 102981;
UPDATE lemma SET lemma_stressed = 'четири`йсети' WHERE lemma_id = 102984;
UPDATE lemma SET lemma_stressed = 'четирина`йсети' WHERE lemma_id = 102986;
UPDATE lemma SET lemma_stressed = 'шестна`йсети' WHERE lemma_id = 102990;

-- slovnik lemmata do not have fixed lemma ids
UPDATE lemma SET lemma_stressed = 'годи`на-две`' WHERE lemma = 'година-две' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'два`-три`' WHERE lemma = 'два-три' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'двай`сетина' WHERE lemma = 'двайсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'два`мка' WHERE lemma = 'двамка' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'дванадесети`на' WHERE lemma = 'дванадесетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'дванайсети`на' WHERE lemma = 'дванайсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'две`-три`' WHERE lemma = 'две-три' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'две`нки' WHERE lemma = 'двенки' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'две`сте' WHERE lemma = 'двесте' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'двесто`тен' WHERE lemma = 'двестотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'две`чки' WHERE lemma = 'двечки' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'двусто`тен' WHERE lemma = 'двустотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'деветми`на' WHERE lemma = 'деветмина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'деветсто`тен' WHERE lemma = 'деветстотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'де`н-два`' WHERE lemma = 'ден-два' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'де`сет-петна`десет' WHERE lemma = 'десет-петнадесет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'де`сет-петна`йсет' WHERE lemma = 'десет-петнайсет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'десети`на-двана`десет' WHERE lemma = 'десетина-дванадесет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'десети`на-двана`йсет' WHERE lemma = 'десетина-дванайсет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'десети`на-едина`десет' WHERE lemma = 'десетина-единадесет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'десети`на-едина`йсет' WHERE lemma = 'десетина-единайсет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'десети`на-петна`десет' WHERE lemma = 'десетина-петнадесет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'десети`на-петна`йсет' WHERE lemma = 'десетина-петнайсет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'десе`тохи`ляден' WHERE lemma = 'десетохиляден' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'еди`н-два`' WHERE lemma = 'един-два' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'еди`н-еди`нствен' WHERE lemma = 'един-единствен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'еди`н-едни`чък' WHERE lemma = 'един-едничък' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'единайсети`на' WHERE lemma = 'единайсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'ле`в-два`' WHERE lemma = 'лев-два' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'ма`лко' WHERE lemma = 'малко' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'ми`г-два`' WHERE lemma = 'миг-два' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'милиа`рден' WHERE lemma = 'милиарден' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'милио`нен' WHERE lemma = 'милионен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'мину`та-две`' WHERE lemma = 'минута-две' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'мно`го' WHERE lemma = 'много' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'мно`жко' WHERE lemma = 'множко' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'мъ`ничко' WHERE lemma = 'мъничко' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'не`колкосто`тин' WHERE lemma = 'неколкостотин' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'нема`лко' WHERE lemma = 'немалко' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'немно`го' WHERE lemma = 'немного' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'о`семсто`тен' WHERE lemma = 'осемстотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'пе`т-ше`ст' WHERE lemma = 'пет-шест' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'пе`т-шести`ма' WHERE lemma = 'пет-шестима' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'пе`т-шести`на' WHERE lemma = 'пет-шестина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'пе`т-ше`стсто`тин' WHERE lemma = 'пет-шестстотин' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'петнайсети`на' WHERE lemma = 'петнайсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'петсто`тен' WHERE lemma = 'петстотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'по`вече' WHERE lemma = 'повече' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'по`вечко' WHERE lemma = 'повечко' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'полови`н' WHERE lemma = 'половин' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'полови`на' WHERE lemma = 'половина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'пъ`рви' WHERE lemma = 'първи' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'се`дем-о`сем' WHERE lemma = 'седем-осем' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'се`демсто`тен' WHERE lemma = 'седемстотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'седми`на' WHERE lemma = 'седмина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'сто`-две`ста' WHERE lemma = 'сто-двеста' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'сто`тен' WHERE lemma = 'стотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'стоти`на' WHERE lemma = 'стотина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'стоти`на' WHERE lemma = 'стотина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'стоти`на-две`ста' WHERE lemma = 'стотина-двеста' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'три`-четири`ма' WHERE lemma = 'три-четирима' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'тридесети`на' WHERE lemma = 'тридесетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'трийсети`на' WHERE lemma = 'трийсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'трийсети`на' WHERE lemma = 'трийсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'три`ма' WHERE lemma = 'трима' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'три`мца' WHERE lemma = 'тримца' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'три`нки' WHERE lemma = 'тринки' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'тристо`тен' WHERE lemma = 'тристотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'три`чки' WHERE lemma = 'трички' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'тро`ица' WHERE lemma = 'троица' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'хи`ляден' WHERE lemma = 'хиляден' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'ча`с-два`' WHERE lemma = 'час-два' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'четво`рица' WHERE lemma = 'четворица' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'че`твърт' WHERE lemma = 'четвърт' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'четиридесети`на' WHERE lemma = 'четиридесетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'четирийсети`на' WHERE lemma = 'четирийсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'четири`ма' WHERE lemma = 'четирима' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'четирина`йсет' WHERE lemma = 'четиринайсет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'четиристо`тен' WHERE lemma = 'четиристотен' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'чети`рма' WHERE lemma = 'четирма' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шейсе`т' WHERE lemma = 'шейсет' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шейсе`ти' WHERE lemma = 'шейсети' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шейсети`на' WHERE lemma = 'шейсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шестдесети`на' WHERE lemma = 'шестдесетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шести`ма' WHERE lemma = 'шестима' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шестнадесети`на' WHERE lemma = 'шестнадесетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шестнайсети`на' WHERE lemma = 'шестнайсетина' AND num_stresses = 0;
UPDATE lemma SET lemma_stressed = 'шестсто`тен' WHERE lemma = 'шестстотен' AND num_stresses = 0;

END TRANSACTION;