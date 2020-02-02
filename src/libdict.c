#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <stdio.h>
#include <assert.h>
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
	wchar_t * wprop = convert_to_wstring(prop);
	wchar_t * wword_o = wword;
	wchar_t * wprop_o = wprop;
	char *res = (char *) malloc(20 * sizeof(char));
	*res = '\0';

	// NOUNS
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
		else if (strncmp(pos, "female", 6) == 0) {
			strcat(res, "f");
		}
		else if (strncmp(pos, "neutral", 7) == 0) {
			strcat(res, "n");
			goto noun_number;
		}
		else if (strncmp(pos, "plurale", 7) == 0) {
			wprop += 5; // jump over count information in rechko
			strcat(res, "-l");
			goto noun_article;
		}

noun_case:
		if (wcsncmp(wprop, L"звателна", 8) == 0) {
			strcat(res, "s-v");
			goto end;
		}
		// no archaic accusative or dative in rechko

noun_number:
		if (wcsncmp(wprop, L"ед.ч.", 5) == 0) {
			wprop += 5; // jump over delimiter as well
			strcat(res, "s");
		}
		else if (wcsncmp(wprop, L"мн.ч.", 5) == 0) {
			wprop += 5;
			strcat(res, "p");
		}
		else if (wcsncmp(wprop, L"бройна", 6) == 0) {
			strcat(res, "t");
			goto end;
		}

noun_article:
		if(!*wprop) {
			strcat(res, "i");
			goto end;
		}

		wprop++;

		if (wcsncmp(wprop, L"член", 4) == 0) {
			strcat(res, "d");
		}
		else if (wcsncmp(wprop, L"непълен", 7) == 0) {
			strcat(res, "h");
		}
		else if (wcsncmp(wprop, L"пълен", 5) == 0) {
			strcat(res, "f");
		}
		else {
			// shouldn't be possible
			assert(0);
		}
	}
	// ADJECTIVES
	else if (strncmp(pos, "adj", 3) == 0) {
		strcpy(res, "A");

		if (wcsncmp(wprop, L"ж.р.", 4) == 0) {
			wprop += 4;
			strcat(res, "fs");
		}
		else if (wcsncmp(wprop, L"м.р.", 4) == 0) {
			wprop += 4;
			strcat(res, "ms");
		}
		else if (wcsncmp(wprop, L"ср.р.", 5) == 0) {
			wprop += 5;
			strcat(res, "ns");
		}
		else if (wcsncmp(wprop, L"мн.ч.", 5) == 0) {
			wprop += 5;
			strcat(res, "-p");
		}

		if(!*wprop) {
			strcat(res, "i");
			goto end;
		}

		wprop++;

		if (wcsncmp(wprop, L"член", 4) == 0) {
			strcat(res, "d");
		}
		else if (wcsncmp(wprop, L"непълен", 7) == 0) {
			strcat(res, "h");
		}
		else if (wcsncmp(wprop, L"пълен", 5) == 0) {
			strcat(res, "f");
		}
	}
	// NAMES
	else if (strncmp(pos, "name", 4) == 0) {
		pos += 12;

		if (strncmp(pos, "family", 6) == 0) {
			strcpy(res, "H");
		}
		else if (strncmp(pos, "name", 4) == 0) {
			strcpy(res, "Np");
		}

		if (wcsncmp(wprop, L"мъжка", 5) == 0) {
			strcat(res, "msi");
		}
		else if (wcsncmp(wprop, L"женска", 6) == 0) {
			strcat(res, "fsi");
		}
	}
	// PRONOUNS
	else if (strncmp(pos, "pron", 4) == 0) {
		pos += 11;
		strcpy(res, "P");

		if (strncmp(pos, "personal", 4) == 0) {
			strcat(res, "pe");
		}
		else if (strncmp(pos, "demonstrative", 4) == 0) {
			strcat(res, "de");
		}
		else if (strncmp(pos, "relative", 4) == 0) {
			strcat(res, "r");
		}
		else if (strncmp(pos, "general", 4) == 0) {
			// pronominal_general in rechko corresponds to collective pronouns
			strcat(res, "c");
		}
		else if (strncmp(pos, "interrogative", 4) == 0) {
			strcat(res, "i");
		}
		else if (strncmp(pos, "indefinite", 4) == 0) {
			strcat(res, "f");
		}
		else if (strncmp(pos, "negative", 4) == 0) {
			strcat(res, "n");
		}
		else if (strncmp(pos, "possessive", 4) == 0) {
			strcat(res, "s");
		}
	}

end:
	free(wword_o);
	free(wprop_o);
	return res;
}
