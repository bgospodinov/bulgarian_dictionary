#ifndef LIBDICT_H_
#define LIBDICT_H_

int is_lemma(const char * wordform, const char * lemma, const char * tag);
int count_syllables(const char *str);
const char * stress_syllable(const char * word, int n);
const char * diminutive_to_base(const char * word);
int find_nth_stressed_syllable(const char * word, int n);
const char * rechko_tag(const char * word, const char * pos, const char * prop);

#endif // LIBDICT_H_
