#ifndef LIBDICT_H_
#define LIBDICT_H_

#include <wchar.h>

int is_lemma(const char * wordform, const char * lemma, const char * tag);
int count_syllables(const char *str);
const char * stress_syllable(const char * word, int n);
const char * remove_last_char(const char * word, const char * c);
const char * diminutive_to_base(const char * word);
int find_nth_stressed_syllable(const char * word, int n);
int find_nth_stressed_syllable_rev(const char * word, int n);
const char * rechko_tag(const char * word, const char * pos, const char * prop);
int is_vocal(wchar_t wc);
int is_capitalized(const wchar_t * const word);

extern const wchar_t lc_vocals[8];

#endif // LIBDICT_H_
