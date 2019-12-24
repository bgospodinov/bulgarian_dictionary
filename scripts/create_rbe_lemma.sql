DROP TABLE IF EXISTS lemma;

CREATE TABLE lemma (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `name_with_stress` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `source_definition` longtext COLLATE utf8_unicode_ci NOT NULL,
  `workroom_page` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
)
