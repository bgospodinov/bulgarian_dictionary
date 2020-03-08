#ifndef STRING_AUX_H_
#define STRING_AUX_H_

int is_capitalized(wchar_t * word);
wchar_t * convert_to_wstring(const char * str);
char * convert_to_mbstring(wchar_t *wstr);
int is_vowel(wchar_t wc);

extern wchar_t lc_vowels[8];

#endif // STRING_AUX_H_
