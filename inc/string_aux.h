#ifndef STRING_AUX_H_
#define STRING_AUX_H_

wchar_t * strip_longest_suffix(wchar_t * const wword, const wchar_t * const suff[], size_t suffsz, int * sfxmidx);
wchar_t * convert_to_wstring(const char * str);
char * convert_to_mbstring(const wchar_t * wstr);
char * mbcopy(const char * str);
void utf8rev(char * str);

#endif // STRING_AUX_H_
