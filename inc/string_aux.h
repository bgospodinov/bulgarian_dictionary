#ifndef STRING_AUX_H_
#define STRING_AUX_H_

int is_capitalized(const wchar_t * const word);
wchar_t * strip_longest_suffix(wchar_t * const wword, const wchar_t * const suff[], size_t suffsz, int * sfxmidx);
wchar_t * convert_to_wstring(const char * str);
char * convert_to_mbstring(const wchar_t * wstr);
int is_vowel(wchar_t wc);
char * mbcopy(const char * str);
void utf8rev(char * str);

extern const wchar_t lc_vowels[8];

#endif // STRING_AUX_H_
