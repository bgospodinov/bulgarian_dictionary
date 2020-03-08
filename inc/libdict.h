#ifndef LIBDICT_H_
#define LIBDICT_H_

int is_lemma(char *wordform, char *lemma, char *tag);
int count_syllables(const char *str);
const char * stress_first_syllable(const char *word);
const char * rechko_tag(const char *word, const char *pos, const char *prop);

#endif // LIBDICT_H_
