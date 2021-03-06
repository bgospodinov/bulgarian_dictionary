CREATE TEMP TABLE _res(key TEXT, value INTEGER);

INSERT INTO _res VALUES("красиф", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'красиф'));
INSERT INTO _res VALUES("раскас", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'раскас'));
INSERT INTO _res VALUES("снйак", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'снйак'));
INSERT INTO _res VALUES("брйак", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'брйак'));
INSERT INTO _res VALUES("свот", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'свот'));
INSERT INTO _res VALUES("весник", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'весник'));
INSERT INTO _res VALUES("радосно", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'радосно'));
INSERT INTO _res VALUES("червенокръсци", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'червенокръсци'));
INSERT INTO _res VALUES("штаслиф", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'штаслиф'));
INSERT INTO _res VALUES("звезна", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'звезна'));
INSERT INTO _res VALUES("кръсник", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'кръсник'));
INSERT INTO _res VALUES("месност", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'месност'));
INSERT INTO _res VALUES("врапче", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'врапче'));
INSERT INTO _res VALUES("исток", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'исток'));
INSERT INTO _res VALUES("връсник", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'връсник'));
INSERT INTO _res VALUES("извесни", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'извесни'));
INSERT INTO _res VALUES("златограт", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'златограт'));
INSERT INTO _res VALUES("свадба", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'свадба'));
INSERT INTO _res VALUES("исхот", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'исхот'));
INSERT INTO _res VALUES("зборник", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'зборник'));
INSERT INTO _res VALUES("зграда", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'зграда'));
INSERT INTO _res VALUES("книшка", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'книшка'));
INSERT INTO _res VALUES("гратски", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'гратски'));
INSERT INTO _res VALUES("младоста", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'младоста'));
INSERT INTO _res VALUES("бйала", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'бйала'));
INSERT INTO _res VALUES("йулийа", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'йулийа'));
INSERT INTO _res VALUES("булйон", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'булйон'));
INSERT INTO _res VALUES("говорйъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'говорйъ'));
INSERT INTO _res VALUES("говорйа", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'говорйа'));
INSERT INTO _res VALUES("оборйъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'оборйъ'));
INSERT INTO _res VALUES("оборйът", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'оборйът'));
INSERT INTO _res VALUES("говорйът", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'говорйът'));
INSERT INTO _res VALUES("говорйат", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'говорйат'));
INSERT INTO _res VALUES("испитъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'испитъ'));
INSERT INTO _res VALUES("испитът", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'испитът'));
INSERT INTO _res VALUES("испита", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'испита'));
INSERT INTO _res VALUES("испитат", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'испитат'));
INSERT INTO _res VALUES("моментъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'моментъ'));
INSERT INTO _res VALUES("сънйъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'сънйъ'));
INSERT INTO _res VALUES("сънйа", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'сънйа'));
INSERT INTO _res VALUES("сънйът", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'сънйът'));
INSERT INTO _res VALUES("сънйат", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'сънйат'));
INSERT INTO _res VALUES("метъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'метъ'));
INSERT INTO _res VALUES("четъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'четъ'));
INSERT INTO _res VALUES("пийъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'пийъ'));
INSERT INTO _res VALUES("стойъ", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'стойъ'));
INSERT INTO _res VALUES("имич", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'имич'));
INSERT INTO _res VALUES("кеймбрич", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'кеймбрич'));
INSERT INTO _res VALUES("бач", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'бач'));
INSERT INTO _res VALUES("ксенц", (SELECT COUNT(*) > 0 FROM pronunciation WHERE pronunciation = 'ксенц'));

SELECT * FROM _res;
DROP TABLE _res;