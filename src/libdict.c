#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <stdio.h>
#include "../inc/libdict.h"
#include "../inc/string_aux.h"

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

int count_syllables(const char *str) {
	int cnt = 0;
	wchar_t * wstr = convert_to_wstring(str);
	wchar_t lc_vowels[] = { u'\u0430', u'\u0435', u'\u0438', u'\u043E', u'\u0443', u'\u044A', u'\u044E', u'\u044F' };

	for (size_t i = 0; wstr[i]; ++i) {
		wchar_t wc = wstr[i];

		// account for capital letters
		if (wc < u'\u0430') {
			wc += 32;
		}

		// count vowels as a proxy
		for (int j = 0; j < sizeof(lc_vowels) / 2; j++) {
			int sign = (lc_vowels[j] > wc) - (lc_vowels[j] < wc);
			if (sign == -1) continue;
			else if (sign == 0) cnt++;
			break;
    	}
	}

	free(wstr);
	return cnt;
}

const char * rechko_tag(const char *word, const char *pos, const char *prop) {
	wchar_t * wword = convert_to_wstring(word);
	char *res = (char *) malloc(20 * sizeof(char));
	*res = '\0';

	if (strncmp(pos, "noun", 4) == 0) {
		strcpy(res, "N");
		if (is_capitalized(wword)) {
			strcat(res, "p");
		}
		else {
			strcat(res, "c");
		}

		pos += 5; // include _

		if (strncmp(pos, "male", 4) == 0) {
			strcat(res, "m");
		}
	}

	free(wword);
	return res;
}
