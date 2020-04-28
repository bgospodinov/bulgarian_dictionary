#include <wchar.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string_aux.h>

int is_cyrillic(const wchar_t wc) {
	return wc >= u'\u0410' && wc <= u'\u044F';
}

void lowercase_char(wchar_t * wc) {
	if (*wc < u'\u0430') {
		*wc += 32;
	}
}

int is_wc_of_charset_ci_sc(wchar_t wc, const wchar_t charset[], size_t chssz) {
	// account for capital letters
	lowercase_char(&wc);

	for (int i = 0; i < chssz; i++) {
		int sign = (charset[i] > wc) - (charset[i] < wc);
		if (sign == -1) continue;
		else if (sign == 0) return i + 1;
		else break;
	}

	return false;
}

int is_wc_of_charset_ci(wchar_t wc, const wchar_t charset[], size_t chssz) {
	// account for capital letters
	lowercase_char(&wc);

	for (int i = 0; i < chssz; i++) {
		if (charset[i] == wc) return i + 1;
	}

	return false;
}

wchar_t * strip_longest_suffix(wchar_t * const wword, 
										const wchar_t * const suff[],
										size_t suffsz, int * sfxmidx) {
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

size_t convert_to_wstring_h(wchar_t * result, const char * str, size_t strl) {
	int rc = mbstowcs(result, str, strl);

	if (rc < 0) {
		fprintf(stderr, "Error converting to wide char string.\n");
		exit(EXIT_FAILURE);
	}

	return rc;
}

wchar_t * convert_to_wstring(const char * str) {
	size_t strl = strlen(str);
	wchar_t *wstr = (wchar_t *) calloc(strl, sizeof(wchar_t));
	convert_to_wstring_h(wstr, str, strl);
	return wstr;
}

size_t convert_to_mbstring_h(char * buffer, const wchar_t * wstr, size_t buffsz) {
	size_t rc = wcstombs(buffer, wstr, buffsz);

	if (rc < 0) {
		fprintf(stderr, "Error converting to multibyte string: %s \n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	if (rc == buffsz)
		buffer[buffsz - 1] = '\0';

	return rc;
}

char * convert_to_mbstring(const wchar_t * wstr) {
	size_t wstrl = wcslen(wstr) * 4 + 1;
	char * str = (char *) calloc(wstrl, sizeof(char));
	convert_to_mbstring_h(str, wstr, wstrl);
	return str;
}

const char * remove_char(const char * word, const char * c, const bool last) {
	wchar_t * wword = convert_to_wstring(word);
	const size_t wword_len = wcslen(wword);
	wchar_t * wc = convert_to_wstring(c);
	wchar_t * const wc_o = wc;

	// last occurence of char
	wchar_t * lwc = last ? wcsrchr(wword, *wc) : wcschr(wword, *wc);

	if (lwc != NULL) {
		wmemmove(lwc, lwc + 1, wword_len - (lwc - wword));
	}

	free(wc_o);
	char * res = convert_to_mbstring(wword);
	free(wword);
	return res;
}

char * mbcopy(const char * str) {
	const size_t lenstr = strlen(str) + 1;
	char * copy = malloc(lenstr * sizeof(char));
	strcpy(copy, str);
	return copy;
}

// see https://stackoverflow.com/a/199453
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