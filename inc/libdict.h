#ifndef LIBDICT_H_
#define LIBDICT_H_

int is_lemma(char *wordform, char *lemma, char *tag);
int count_syllables(const char *str);
const char * rechko_tag(const char *pos, const char *prop);

#endif // LIBDICT_H_
