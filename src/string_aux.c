#include <wchar.h>
#include <locale.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

const wchar_t lc_vowels[] = { u'\u0430', u'\u0435', u'\u0438', u'\u043E', u'\u0443', u'\u044A', u'\u044E', u'\u044F' };

int is_capitalized(const wchar_t * const word) {
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

wchar_t * strip_longest_suffix(wchar_t * const wword, 
										const wchar_t * const suff[],
										size_t suffsz, int * sfxmidx) {
	setlocale(LC_ALL, "");
	const size_t wlen = wcslen(wword);
	wchar_t * const pewword = wword + wlen - 1;
	wchar_t * pwword = pewword;
	const wchar_t * psuff[suffsz];
	bool suffp[suffsz]; // is corresponding suffix possible
	short suffl[suffsz]; // suffices length
	short suffi[suffsz]; // suffices indices
	memset(suffp, true, sizeof(bool) * suffsz);
	memset(suffi, 0, sizeof(short) * suffsz);

	// reset pointers at end of all suffices
	for (int i = 0; i < suffsz; i++) {
		suffl[i] = wcslen(suff[i]);
		psuff[i] = suff[i] + suffl[i] - 1;
	}

	for (int i = wlen - 1; i >= 0; i--, pwword--) {
		short suffleft = 0; // suffixes left to try
		for (int j = 0; j < suffsz; j++) {
			if (suffi[j] < suffl[j] && suffp[j]) {
				if (*pwword == *psuff[j]) {
					suffleft++;
					psuff[j]--;
					suffi[j]++;
				}
				else {
					suffp[j] = false;
				}
			}
		}

		if (suffleft == 0)
			break;
	}

	short mxpsfxsz = 0;
	*sfxmidx = -1;
	for (int i = 0; i < suffsz; i++) {
		if (suffp[i] && suffl[i] > mxpsfxsz) {
			mxpsfxsz = suffl[i];
			*sfxmidx = i;
		}
	}

	*(pewword - mxpsfxsz + 1) = '\0';
	return wword;
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

char * convert_to_mbstring(const wchar_t * wstr) {
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

char * mbcopy(const char * str) {
	const size_t lenstr = strlen(str) + 1;
	char * copy = malloc(lenstr * sizeof(char));
	strcpy(copy, str);
	return copy;
}

// https://stackoverflow.com/a/199453
void utf8rev(char * str) {
    /* this assumes that str is valid UTF-8 */
    char *scanl, *scanr, *scanr2, c;

    /* first reverse the string */
    for (scanl = str, scanr = str + strlen(str); scanl < scanr;)
        c= *scanl, *scanl++= *--scanr, *scanr= c;

    /* then scan all bytes and reverse each multibyte character */
    for (scanl = scanr = str; c = *scanr++;) {
        if ( (c & 0x80) == 0) // ASCII char
            scanl = scanr;
        else if ( (c & 0xc0) == 0xc0 ) { // start of multibyte
            scanr2 = scanr;
            switch (scanr - scanl) {
                case 4: c = *scanl, *scanl++= *--scanr, *scanr = c; // fallthrough
                case 3: // fallthrough
                case 2: c = *scanl, *scanl++= *--scanr, *scanr = c;
            }
            scanr = scanl = scanr2;
        }
    }
}