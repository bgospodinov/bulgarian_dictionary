#ifndef IMPORT_SLOVNIK_H_
#define IMPORT_SLOVNIK_H_

#define DB_FILE_NAME "temp.db"
#define SLOVNIK_FILE_NAME "slovnik.csv"

void import_slovnik_wordforms(char *path);
int count_syllables(char *str);

#endif // IMPORT_SLOVNIK_H_