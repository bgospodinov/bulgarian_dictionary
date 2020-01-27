#ifndef IMPORT_SLOVNIK_H_
#define IMPORT_SLOVNIK_H_

#define SLOVNIK_FILE_NAME "slovnik.csv"

void import_slovnik_wordforms(char *path);
int is_lemma(char *wordform, char *lemma, char *tag);
int count_syllables(char *str);

#endif // IMPORT_SLOVNIK_H_
