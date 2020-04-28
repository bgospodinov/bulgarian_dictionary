#ifndef LIBDICT_H_
#define LIBDICT_H_

#include <wchar.h>

void lowercase_string(wchar_t * wstr);
int is_lemma(const char * wordform, const char * lemma, const char * tag);
int count_syllables(const char *str);
const char * stress_syllable(const char * word, int n);
const char * diminutive_to_base(const char * word);
int find_nth_stressed_syllable(const char * word, int n);
int find_nth_stressed_syllable_rev(const char * word, int n);
void rechko_tag(char * res, const char * word, const char * pos, const char * prop);
int is_vocal(wchar_t wc);
void sonority_model(char * result, const char * word);
void accent_model(char * result, const char * word);
int is_capitalized(const wchar_t * const word);
int is_sonorant(wchar_t wc);
int is_voiced(wchar_t wc);
int is_unvoiced(wchar_t wc);
wchar_t invert_voiced(wchar_t wc);
int sonority_char(wchar_t wc);
void pronounce(char * result, size_t rlen, const char * word);

#endif // LIBDICT_H_
