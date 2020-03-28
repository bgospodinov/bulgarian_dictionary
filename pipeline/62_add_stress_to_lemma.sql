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
UPDATE lemma SET lemma_stressed = 'черирина`йсет' WHERE lemma_id = 102923; -- FIX SPELLING
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
UPDATE lemma SET lemma_stressed = 'годи`на-две`' WHERE lemma_id = 171342;
UPDATE lemma SET lemma_stressed = 'два`-три`' WHERE lemma_id = 171343;
UPDATE lemma SET lemma_stressed = 'двай`сетина' WHERE lemma_id = 171344;
UPDATE lemma SET lemma_stressed = 'два`мка' WHERE lemma_id = 171345;
UPDATE lemma SET lemma_stressed = 'дванадесети`на' WHERE lemma_id = 171346;
UPDATE lemma SET lemma_stressed = 'дванайсети`на' WHERE lemma_id = 171347;
UPDATE lemma SET lemma_stressed = 'две`-три`' WHERE lemma_id = 171351;
UPDATE lemma SET lemma_stressed = 'две`нки' WHERE lemma_id = 171352;
UPDATE lemma SET lemma_stressed = 'две`сте' WHERE lemma_id = 171353; -- FIX SPELLING
UPDATE lemma SET lemma_stressed = 'двесто`тен' WHERE lemma_id = 171354;
UPDATE lemma SET lemma_stressed = 'две`чки' WHERE lemma_id = 171355;
UPDATE lemma SET lemma_stressed = 'двусто`тен' WHERE lemma_id = 171356;
UPDATE lemma SET lemma_stressed = 'деветми`на' WHERE lemma_id = 171357;
UPDATE lemma SET lemma_stressed = 'деветсто`тен' WHERE lemma_id = 171358;
UPDATE lemma SET lemma_stressed = 'де`н-два`' WHERE lemma_id = 171359;
UPDATE lemma SET lemma_stressed = 'де`сет-петна`десет' WHERE lemma_id = 171360;
UPDATE lemma SET lemma_stressed = 'де`сет-петна`йсет' WHERE lemma_id = 171361;
UPDATE lemma SET lemma_stressed = 'десети`на-двана`десет' WHERE lemma_id = 171362;
UPDATE lemma SET lemma_stressed = 'десети`на-двана`йсет' WHERE lemma_id = 171363;
UPDATE lemma SET lemma_stressed = 'десети`на-едина`десет' WHERE lemma_id = 171364;
UPDATE lemma SET lemma_stressed = 'десети`на-едина`йсет' WHERE lemma_id = 171365;
UPDATE lemma SET lemma_stressed = 'десети`на-петна`десет' WHERE lemma_id = 171366;
UPDATE lemma SET lemma_stressed = 'десети`на-петна`йсет' WHERE lemma_id = 171367;
UPDATE lemma SET lemma_stressed = 'десе`тохи`ляден' WHERE lemma_id = 171368;
UPDATE lemma SET lemma_stressed = 'еди`н-два`' WHERE lemma_id = 171369;
UPDATE lemma SET lemma_stressed = 'еди`н-еди`нствен' WHERE lemma_id = 171370;
UPDATE lemma SET lemma_stressed = 'еди`н-едни`чък' WHERE lemma_id = 171371;
UPDATE lemma SET lemma_stressed = 'единайсети`на' WHERE lemma_id = 171372;
UPDATE lemma SET lemma_stressed = 'ле`в-два`' WHERE lemma_id = 171373;
UPDATE lemma SET lemma_stressed = 'ма`лко' WHERE lemma_id = 171374;
UPDATE lemma SET lemma_stressed = 'ми`г-два`' WHERE lemma_id = 171375;
UPDATE lemma SET lemma_stressed = 'милиа`рден' WHERE lemma_id = 171376;
UPDATE lemma SET lemma_stressed = 'милио`нен' WHERE lemma_id = 171377;
UPDATE lemma SET lemma_stressed = 'мину`та-две`' WHERE lemma_id = 171378;
UPDATE lemma SET lemma_stressed = 'мно`го' WHERE lemma_id = 171379;
UPDATE lemma SET lemma_stressed = 'мно`жко' WHERE lemma_id = 171380;
UPDATE lemma SET lemma_stressed = 'мъ`ничко' WHERE lemma_id = 171381;
UPDATE lemma SET lemma_stressed = 'не`колкосто`тин' WHERE lemma_id = 171382;
UPDATE lemma SET lemma_stressed = 'нема`лко' WHERE lemma_id = 171383;
UPDATE lemma SET lemma_stressed = 'немно`го' WHERE lemma_id = 171384;
UPDATE lemma SET lemma_stressed = 'о`семсто`тен' WHERE lemma_id = 171385;
UPDATE lemma SET lemma_stressed = 'пе`т-ше`ст' WHERE lemma_id = 171386;
UPDATE lemma SET lemma_stressed = 'пе`т-шести`ма' WHERE lemma_id = 171387;
UPDATE lemma SET lemma_stressed = 'пе`т-шести`на' WHERE lemma_id = 171388;
UPDATE lemma SET lemma_stressed = 'пе`т-ше`стсто`тин' WHERE lemma_id = 171389;
UPDATE lemma SET lemma_stressed = 'петнайсети`на' WHERE lemma_id = 171390;
UPDATE lemma SET lemma_stressed = 'петсто`тен' WHERE lemma_id = 171391;
UPDATE lemma SET lemma_stressed = 'по`вече' WHERE lemma_id = 171392;
UPDATE lemma SET lemma_stressed = 'по`вечко' WHERE lemma_id = 171393;
UPDATE lemma SET lemma_stressed = 'полови`н' WHERE lemma_id = 171394;
UPDATE lemma SET lemma_stressed = 'полови`на' WHERE lemma_id = 171395;
UPDATE lemma SET lemma_stressed = 'пъ`рви' WHERE lemma_id = 171396;
UPDATE lemma SET lemma_stressed = 'се`дем-о`сем' WHERE lemma_id = 171397;
UPDATE lemma SET lemma_stressed = 'се`демсто`тен' WHERE lemma_id = 171398;
UPDATE lemma SET lemma_stressed = 'седми`на' WHERE lemma_id = 171399;
UPDATE lemma SET lemma_stressed = 'сто`-две`ста' WHERE lemma_id = 171400;
UPDATE lemma SET lemma_stressed = 'сто`тен' WHERE lemma_id = 171401;
UPDATE lemma SET lemma_stressed = 'стоти`на' WHERE lemma_id = 171402;
UPDATE lemma SET lemma_stressed = 'стоти`на' WHERE lemma_id = 171403;
UPDATE lemma SET lemma_stressed = 'стоти`на-две`ста' WHERE lemma_id = 171404;
UPDATE lemma SET lemma_stressed = 'три`-четири`ма' WHERE lemma_id = 171405;
UPDATE lemma SET lemma_stressed = 'тридесети`на' WHERE lemma_id = 171406;
UPDATE lemma SET lemma_stressed = 'трийсети`на' WHERE lemma_id = 171407;
UPDATE lemma SET lemma_stressed = 'трийсети`на' WHERE lemma_id = 171408;
UPDATE lemma SET lemma_stressed = 'три`ма' WHERE lemma_id = 171409;
UPDATE lemma SET lemma_stressed = 'три`мца' WHERE lemma_id = 171410;
UPDATE lemma SET lemma_stressed = 'три`нки' WHERE lemma_id = 171411;
UPDATE lemma SET lemma_stressed = 'тристо`тен' WHERE lemma_id = 171412;
UPDATE lemma SET lemma_stressed = 'три`чки' WHERE lemma_id = 171413;
UPDATE lemma SET lemma_stressed = 'тро`ица' WHERE lemma_id = 171414;
UPDATE lemma SET lemma_stressed = 'хи`ляден' WHERE lemma_id = 171415;
UPDATE lemma SET lemma_stressed = 'ча`с-два`' WHERE lemma_id = 171416;
UPDATE lemma SET lemma_stressed = 'четво`рица' WHERE lemma_id = 171417;
UPDATE lemma SET lemma_stressed = 'че`твърт' WHERE lemma_id = 171418;
UPDATE lemma SET lemma_stressed = 'четиридесети`на' WHERE lemma_id = 171419;
UPDATE lemma SET lemma_stressed = 'четирийсети`на' WHERE lemma_id = 171420;
UPDATE lemma SET lemma_stressed = 'четири`ма' WHERE lemma_id = 171421;
UPDATE lemma SET lemma_stressed = 'четирина`йсет' WHERE lemma_id = 171422;
UPDATE lemma SET lemma_stressed = 'четиристо`тен' WHERE lemma_id = 171423;
UPDATE lemma SET lemma_stressed = 'чети`рма' WHERE lemma_id = 171424; -- FIX SPELLING
UPDATE lemma SET lemma_stressed = 'шейсе`т' WHERE lemma_id = 171425;
UPDATE lemma SET lemma_stressed = 'шейсе`ти' WHERE lemma_id = 171426;
UPDATE lemma SET lemma_stressed = 'шейсети`на' WHERE lemma_id = 171427;
UPDATE lemma SET lemma_stressed = 'шестдесети`на' WHERE lemma_id = 171428;
UPDATE lemma SET lemma_stressed = 'шести`ма' WHERE lemma_id = 171429;
UPDATE lemma SET lemma_stressed = 'шестнадесети`на' WHERE lemma_id = 171430;
UPDATE lemma SET lemma_stressed = 'шестнайсети`на' WHERE lemma_id = 171431;
UPDATE lemma SET lemma_stressed = 'шестсто`тен' WHERE lemma_id = 171432;

END TRANSACTION;