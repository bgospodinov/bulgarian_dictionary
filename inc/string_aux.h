#ifndef STRING_AUX_H_
#define STRING_AUX_H_

#include <stdbool.h>

int is_cyrillic(const wchar_t wc);
void lowercase_char(wchar_t * wc);
int is_wc_of_charset_ci_sc(wchar_t wc, const wchar_t charset[], size_t chssz);
int is_wc_of_charset_ci(wchar_t wc, const wchar_t charset[], size_t chssz);
wchar_t * strip_longest_suffix(wchar_t * const wword, const wchar_t * const suff[], size_t suffsz, int * sfxmidx);
wchar_t * convert_to_wstring(const char * str);
size_t convert_to_wstring_h(wchar_t * result, const char * str, size_t strl);
size_t convert_to_mbstring_h(char * buffer, const wchar_t * wstr, size_t buffsz);
char * convert_to_mbstring(const wchar_t * wstr);
const char * remove_char(const char * word, const char * c, const bool last);
char * mbcopy(const char * str);
void utf8rev(char * str);

#endif // STRING_AUX_H_
