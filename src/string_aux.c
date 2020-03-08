#include <wchar.h>
#include <locale.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

wchar_t lc_vowels[] = { u'\u0430', u'\u0435', u'\u0438', u'\u043E', u'\u0443', u'\u044A', u'\u044E', u'\u044F' };

int is_capitalized(wchar_t * word) {
	return *word >= u'\u0410' && *word < u'\u0430';
}

int is_vowel(wchar_t wc) {
	// account for capital letters
	if (wc < u'\u0430') {
		wc += 32;
	}

	for (int j = 0; j < sizeof(lc_vowels) / 2; j++) {
		int sign = (lc_vowels[j] > wc) - (lc_vowels[j] < wc);
		if (sign == -1) continue;
		else if (sign == 0) return 1;
		else break;
	}

	return 0;
}

wchar_t * convert_to_wstring(const char * str) {
	setlocale(LC_ALL, "");
	size_t strl = strlen(str);
	wchar_t *wstr = (wchar_t *) calloc(strl, sizeof(wchar_t));
	int rc = mbstowcs(wstr, str, strl);

	if (rc < 0) {
		fprintf(stderr, "Error converting to wide char string.");
		exit(EXIT_FAILURE);
	}

	return wstr;
}

char * convert_to_mbstring(wchar_t * wstr) {
	setlocale(LC_ALL, "");
	size_t wstrl = wcslen(wstr) * 4 + 1;
	char * str = (char *) calloc(wstrl, sizeof(char));
	size_t rc = wcstombs(str, wstr, wstrl);

	if (rc < 0) {
		fprintf(stderr, "Error converting to multibyte string: %s \n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	return str;
}
