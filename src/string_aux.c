#include <wchar.h>
#include <locale.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int is_capitalized(wchar_t * word) {
	return *word >= u'\u0410' && *word < u'\u0430';
}

wchar_t * convert_to_wstring(const char *str) {
	setlocale(LC_ALL, "");
	int strl = strlen(str);
	wchar_t *wstr = (wchar_t *) calloc(strl, sizeof(wchar_t));
	int rc = mbstowcs(wstr, str, strl);

	if (rc < 0) {
		fprintf(stderr, "Error converting to wide char string.");
		exit(EXIT_FAILURE);
	}

	return wstr;
}
