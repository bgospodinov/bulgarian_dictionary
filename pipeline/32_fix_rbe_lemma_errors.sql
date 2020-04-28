BEGIN TRANSACTION;

UPDATE rbe_lemma SET lemma = 'войнстващ', lemma_with_stress = 'во`йнстващ' WHERE lemma = 'войнстващ  войнствуващ';
UPDATE rbe_lemma SET lemma = 'печенеги', lemma_with_stress = 'печене`ги', pos = 'N' WHERE lemma = 'печенеги  печенези';
UPDATE rbe_lemma SET lemma = 'бъх', lemma_with_stress = 'бъх' WHERE lemma = 'бъ х';
UPDATE rbe_lemma SET lemma_with_stress = 'га`' WHERE lemma = 'га';
UPDATE rbe_lemma SET pos = 'Ncm' WHERE lemma = 'гъзар' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'опа`рям' WHERE lemma_with_stress = 'опаря`м' AND pos = 'V';
UPDATE rbe_lemma SET lemma_with_stress = 'петдесе`ти' WHERE lemma_with_stress = 'петдесети`' AND pos = 'M';
UPDATE rbe_lemma SET pos = 'Ncm' WHERE lemma IN ('ден', 'двор', 'пол', 'ом', 'оджак', 'драмкръжок') AND pos != 'Ncm';
UPDATE rbe_lemma SET lemma = 'Бабинден', lemma_with_stress = 'Ба`бинден' WHERE lemma = 'бабинден' AND pos = 'Ncm';

-- separates words that have two possiblе stresses
CREATE TEMP TABLE lemmata_with_two_possible_stresses AS
VALUES ('боклу`ча`'), ('бла`жа`'), ('ви`ся`'), ('вре`дя`'), ('начого`ля`'), ('пра`ся`'), ('позакръ`гля`'), ('неви`ди`мка'),
('вкле`щя`'), ('наока`ча`'), ('по`по`вски'), ('па`сти`рство'), ('накло`не`ност'), ('офо`рме`ност'), ('о`тсе`к'), ('па`те`нце'),
('а`ма`'), ('ба`ре`'), ('ба`щи`чко'), ('безкози`рка`'), ('бла`же`не'), ('бле`ни`ка'), ('бо`де`не'), ('бра`та`нец'),
('бра`та`ница'), ('бръ`сти`на'), ('вла`ка`'), ('во`дни`к'), ('отза`ра`н'), ('въ`рше`ц'), ('въ`се`ница'), ('га`ме`н'),
('га`ме`нщина'), ('го`рко`'), ('де`не`'), ('дола`кта`нка'), ('домо`вни`к'), ('домо`вни`ца'), ('на`ве`с'), ('надхи`тря`'),
('наме`стни`к'), ('на`по`р'), ('на`пре`чно'), ('на`пръ`стник'), ('на`пръ`стник'), ('на`у`ст'), ('не`ве`н'), ('не`во`д'),
('о`гни`чав'), ('ока`ни`ца'), ('о`кро`п'), ('о`рля`к'), ('о`тто`к'), ('ощъ`рбя`'), ('па`да`ло'), ('па`да`ло'),
('па`ла`вина'), ('па`ли`во'), ('пара`кли`с'), ('па`ри`к'), ('па`рте`р'), ('па`сти`р'), ('па`сха`лия'), ('пау`ни`ца'),
('пе`кло`'), ('по`ве`й'), ('повто`ре`ц'), ('по`ги`бел'), ('по`го`н'), ('по`дко`п'), ('по`дку`м'), ('по`дно`ктица'),
('пока`ча`'), ('покру`ся`'), ('по`ли`п'), ('по`лю`с'), ('пора`зе`ник'), ('по`ста`в'), ('по`ти`хом'), ('по`ли`пен'),
('по`ли`пен'), ('по`на`да'), ('по`на`дица'), ('попа`дя`'), ('по`по`в'), ('по`са`кци'), ('посва`ту`вам'), ('посва`ту`ване'),
('по`что`'), ('пра`ви`лец'), ('пре`га`ч'), ('предсе`дя`'), ('презмо`ря`нин'), ('аза`ле`я'), ('а`кне`'), ('ба`лса`ма'),
('безстра`шли`в'), ('би`бе`'), ('би`бе`нце'), ('би`го`р'), ('бо`жи`к'), ('боля`рки`ня'), ('бонси`стки`'), ('бо`ра`'),
('бо`сто`н'), ('бра`ви`чка'), ('бра`то`к'), ('брашне`вя`'), ('буда`лски`'), ('бу`ке`ла'), ('бу`мба`л'), ('бу`мба`р'),
('бу`ту`р'), ('бъ`лша`'), ('бъ`лше`не'), ('ва`га`нка'), ('ве`жде`н'), ('ве`но`'), ('ве`ру`вам'), ('ви`но`'),
('ви`нце`'), ('ви`се`не'), ('вка`ча`'), ('на`дво`рен'), ('на`дво`решен'), ('нади`гру`вам'), ('нади`гру`ване'), ('надхи`тру`вам'),
('надхи`тру`ване'), ('назо`бя`'), ('наковла`дя`'), ('на`кръ`пка'), ('на`ле`т'), ('на`ли`к'), ('на`по`ло'), ('на`по`рен'),
('на`пръ`стек'), ('на`пръ`стниче'), ('на`пръ`стниче'), ('на`ре`чник'), ('на`сло`н'), ('на`ста`н'), ('насъ`де`'), ('насъ`ду`'),
('насъ`дя`'), ('на`те`ма'), ('на`у`тре'), ('на`хлу`в'), ('нахъ`лме`н'), ('нахъ`лмя`'), ('начакъ`ля`'), ('начова`ля`'),
('начоко`ля`'), ('начуго`ря`'), ('нащъ`рбе`н'), ('нащъ`рбя`'), ('не`ве`нов'), ('неви`де`лица'), ('невта`са`л'), ('недога`дли`в'),
('недога`дли`вост'), ('неиздъ`ржа`н'), ('неиздъ`ржа`ност'), ('не`мо`щница'), ('непре`хо`ден'), ('непре`хо`дност'), ('непромъ`лве`н'), ('неразбо`рчи`в'),
('неразбо`рчи`во'), ('неразбо`рчи`вост'), ('неразкло`не`н'), ('неразра`бо`тен'), ('неразче`тли`в'), ('неразче`тли`вост'), ('не`си`т'), ('неупо`йго`ста'),
('ни`не`'), ('ниша`ня`'), ('ни`ши`на'), ('но`ми`зма'), ('но`щви`'), ('вла`кне`н'), ('вла`сту`вам'), ('вла`ся`'),
('вла`ша`'), ('вмера`ча`'), ('воле`ти`на'), ('во`щи`на'), ('вра`би`ца'), ('вра`жа`'), ('вра`жа`лка'), ('вра`жа`лка'),
('вра`жба`'), ('вра`же`не'), ('вра`тни`ло'), ('вру`ки`на'), ('всъ`де`'), ('втра`пе`н'), ('ву`йка`'), ('вцъ`кля`'),
('въ`жи`ца'), ('въ`рша`ч'), ('въчелове`ча`'), ('вя`ти`чи'), ('га`бро`в'), ('га`бро`вица'), ('гази`ба`ра'), ('гази`ба`рче'),
('га`йгу`р'), ('га`ли`ца'), ('га`ме`нка'), ('га`ме`нски'), ('га`ме`нче'), ('га`нга`л'), ('га`рги`я'), ('га`рдже`'),
('ге`бре`'), ('гла`ву`решки'), ('гне`зде`не'), ('го`ре`ц'), ('гра`пя`'), ('далма`ти`ка'), ('дебе`лшъ`к'), ('де`ла`нка'),
('денде`не`ска'), ('де`не`с'), ('де`не`си'), ('де`не`ска'), ('де`не`шен'), ('де`сту`р'), ('де`те`шки'), ('де`ти`шки'),
('де`чо`р'), ('джа`ба`'), ('ди`вя`к'), ('ди`вя`чка'), ('ди`ке`л'), ('ди`ми`тен'), ('ди`нче`'), ('до`бе`л'),
('добричи`на`'), ('добри`чка`та'), ('до`ве`чер'), ('до`ду`м'), ('до`ду`мен'), ('доду`ша`'), ('доизпле`вя`'), ('дола`та`нка'),
('доофо`рмя`'), ('дра`ску`л'), ('дре`жде`не'), ('дре`ждя`'), ('дрено`ви`на'), ('дръ`нче`'), ('ду`пе`ст'), ('набе`сне`я'),
('набъ`рди`ла'), ('на`ве`сче'), ('на`ви`лка'), ('навсъ`де`'), ('навъ`рвя`'), ('на`ги`змо'), ('нагла`вя`'), ('обезсра`мя`'),
('обръ`жа`'), ('о`гла`вец'), ('о`гла`вец'), ('о`гне`ви`ца'), ('огнеусто`йчи`в'), ('огнеусто`йчи`вост'), ('о`гня`н'), ('огъ`рли`чка'),
('ода`на`д'), ('о`жа`рница'), ('ока`ли`на'), ('окахъ`ря`'), ('о`ке`й'), ('о`кле`й'), ('окле`ти`я'), ('о`кно`'),
('о`кру`х'), ('оку`ме`'), ('окърва`вя`'), ('окьора`вя`'), ('олайня`вя`'), ('о`ма`ла'), ('она`ка`'), ('о`па`ш'),
('опе`ря`'), ('опра`ше`н'), ('опра`ше`ност'), ('ора`ли`ще'), ('о`рди`я'), ('о`ре`шки'), ('ославя`ня`'), ('отблъ`сну`вам'),
('отблъ`сну`ване'), ('отве`ля`'), ('отве`рже`нец'), ('о`твра`тки'), ('оте`чи`на'), ('о`тзе`вка'), ('о`тмо`р'), ('о`тпе`в'),
('отпо`стя`'), ('офо`рме`н'), ('офо`рмя`'), ('оче`рня`'), ('ошле`вя`'), ('па`ди`нка`'), ('паза`ри`ще'), ('па`ле`'),
('пани`че`'), ('па`рте`ница'), ('па`рто`рг'), ('па`ска`чам'), ('па`сти`рски'), ('пеле`нче`'), ('пе`лтя`'), ('пе`ня`з'),
('пе`рни`ца'), ('пе`рпе`р'), ('пе`тле`н'), ('пи`ко`лка'), ('пи`ко`чен'), ('пи`рла`чка'), ('пиро`ви`на'), ('пирпи`ри`я'),
('питу`ли`ца'), ('пла`зи`ца'), ('пла`чу`щ'), ('пле`те`нка'), ('пле`щи`'), ('пли`тня`'), ('плю`сни`ца'), ('по`во`дни`к'),
('по`вра`тки'), ('по`вто`р'), ('по`вто`ром'), ('по`га`н'), ('пога`ни`ч'), ('пога`че`'), ('по`го`нче'), ('по`ддя`л'),
('по`де`сен'), ('по`дзи`ме'), ('поди`гру`вам'), ('поди`гру`ване'), ('по`дно`жи'), ('по`дно`жки'), ('по`до`б'), ('по`ду`ши'),
('по`кла`ди'), ('покра`и`на'), ('покра`и`нка'), ('покру`се`н'), ('полви`ни`ца'), ('поле`ви`ца'), ('поле`нка`');

INSERT INTO rbe_lemma (lemma, lemma_with_stress, pos)
SELECT
    lemma, remove_last_char(lemma_with_stress, '`'), pos
FROM rbe_lemma
WHERE lemma_with_stress IN (
    SELECT * FROM lemmata_with_two_possible_stresses
);

UPDATE rbe_lemma
SET lemma_with_stress = remove_first_char(lemma_with_stress, '`')
WHERE lemma_with_stress IN (
    SELECT * FROM lemmata_with_two_possible_stresses
);

DROP TABLE lemmata_with_two_possible_stresses;

-- deal with reflexives
UPDATE rbe_lemma
SET
	lemma = SUBSTR(lemma, 1, LENGTH(lemma) - 3),
	lemma_with_stress = SUBSTR(lemma_with_stress, 1, LENGTH(lemma_with_stress) - 3),
	pos = 'V'
WHERE lemma LIKE '% ми' OR lemma LIKE '% ме';

END TRANSACTION;