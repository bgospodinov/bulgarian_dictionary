#include "../inc/libdict.h"
#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <stdio.h>

int is_lemma(char *wordform, char *lemma, char *tag) {
	// these are the only possible tags for lemmata
	static const char * const tags[] = {
		"Ncmsi", "Ncfsi", "Ncnsi", "Nc-li", "Npmsi", "Npfsi", "Npnsi", "Np-li",
		"Amsi", "A",
		"Vpiif-r1s", "Vpitf-r1s", "Vppif-r1s", "Vpptf-r1s", "Vniif-r3s", "Vnitf-r3s", "Vnpif-r3s", "Vnptf-r3s", "Vxitf-r1s", "Vyptf-r1s", "Viitf-r1s",
		"Dm", "Dt", "Dl", "Dq", "Dd",
		"Mcmsi", "Momsi", "Mc-pi", "Mo-pi", "Md-pi", "My-pi",
		"I",
		"R",
		"Ta", "Tn", "Ti", "Tx", "Tm", "Tv", "Te", "Tg", "T",
		"Cc", "Cs", "Cr", "Cp"
	};

	for (int i = 0; i < sizeof(tags) / sizeof(tags[0]); i++) {
		if (strcmp(tag, tags[i]) == 0) {
			return 1;
		}
	}

	// deal with pronouns separately
	if (*tag == 'P') {
		if (strcmp(wordform, lemma) == 0) {
			return 1;
		}
	}

	return 0;
}

int count_syllables(char *str) {
	int cnt = 0;
	int strl = strlen(str);
	int wstrl = (strl / 2) + 1; // we don't expect more than 2 bytes per character
	wchar_t *wstr = (wchar_t *) malloc(sizeof(wchar_t) * wstrl);
	int rc = mbstowcs(wstr, str, wstrl);

	for (size_t i = 0; wstr[i]; ++i) {
		wchar_t wc = wstr[i];
		// count vowels as a proxy
    	if (wc == u'\u0430' || wc == u'\u0435' || wc == u'\u0438' \
|| wc == u'\u043E' || wc == u'\u0443' || wc == u'\u044A' || wc == u'\u044E' \
|| wc == u'\u044F') {
			cnt++;
    	}
	}

	free(wstr);
	return cnt;
}
