#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <stdio.h>
#include <assert.h>
#include <locale.h>
#include "../inc/libdict.h"
#include "../inc/string_aux.h"

int is_lemma(const char * wordform, const char * lemma, const char * tag) {
	// these are the only possible tags for lemmata
	static const char * const tags[] = {
		"Ncmsi", "Ncfsi", "Ncnsi", "Nc-li", "Npmsi", "Npfsi", "Npnsi", "Np-li",
		"Amsi", "A",
		"Vpiif-r1s", "Vpitf-r1s", "Vppif-r1s", "Vpptf-r1s", "Vniif-r3s", "Vnitf-r3s", "Vnpif-r3s", "Vnptf-r3s", "Vxitf-r1s", "Vyptf-r1s", "Viitf-r1s",
		"Dm", "Dt", "Dl", "Dq", "Dd",
		"Mcmsi", "Momsi", "Md-pi", "My-pi",
		"Ppelas1", "Pcl", "Pil", "Pit", "Piq", "Pnl", "Pfl", "Pdl", "Pdt", "Pdq", "Pfm", "Pfa--s-f", "Pfa--p", "Pdm", "Prl", "Prt", "Prq", "Pft", "Pfa--s-n", "Pfe--s-n",
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

int count_syllables(const char * str) {
	int cnt = 0;
	wchar_t * wstr = convert_to_wstring(str);

	for (size_t i = 0; wstr[i]; ++i) {
		// count vowels as a proxy
		if (is_vowel(wstr[i]))
			cnt++;
	}

	free(wstr);
	return cnt;
}

const char * diminutive_to_base(const char * word) {
	setlocale(LC_ALL, "");
	static const wchar_t * const suff[] = 
				{ L"че", L"це", L"йка", L"чица", L"джийка" };
	static const size_t suffsz = sizeof(suff) / sizeof(suff[0]);

	int matchedsfx;
	wchar_t * wword = 
		strip_longest_suffix(convert_to_wstring(word), suff, suffsz, &matchedsfx);

	// only concatenate if the appended string is shorter than the removed suffix
	switch (matchedsfx) {
		case 2:
			wcscat(wword, L"я");
			break;
		case 3:
			wcscat(wword, L"ка");
			break;
	}

	char * res = convert_to_mbstring(wword);
	free(wword);
	return res;
}

const char * stress_first_syllable(const char * word) {
	setlocale(LC_ALL, "");
	wchar_t * wword = convert_to_wstring(word);
	wchar_t * const wword_o = wword;
	const size_t wword_len = wcslen(wword);
	const size_t wres_len = wword_len + 1;
	wchar_t * const wres = (wchar_t *) calloc(wres_len + 1, sizeof(wchar_t));
	int k = 0;
	for (; *wword != '\0' && !is_vowel(*wword); k++, wword++);

	if (!*wword) {
		wcsncpy(wres, wword_o, wword_len);
	}
	else {
		wcsncpy(wres, wword_o, k + 1);
		wcscat(wres, L"`");
		wcsncpy(wres + k + 2, wword + 1, wword_len - k);
	}

	free(wword_o);
	char * res = convert_to_mbstring(wres);
	free(wres);
	return res;
}

const char * rechko_tag(const char * word, const char * pos, const char * prop) {
	wchar_t * wword = convert_to_wstring(word);
	wchar_t * wprop = convert_to_wstring(prop);
	wchar_t * const wword_o = wword;
	wchar_t * const wprop_o = wprop;
	char *res = (char *) malloc(15 * sizeof(char));
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
	// VERBS
	else if (strncmp(pos, "verb", 4) == 0) {
		pos += 5;
		// we assume all verbs are personal (which is not true for the dataset)
		strcpy(res, "Vp--f---s");

		if (strncmp(pos, "transitive", 3) == 0) {
			pos += 11;
			*(res + 3) = 't';
		}
		else if (strncmp(pos, "intransitive", 3) == 0) {
			pos += 13;
			*(res + 3) = 'i';
		}

		if (strncmp(pos, "imperfective", 3) == 0) {
			*(res + 2) = 'i';
		}
		else {
			// terminative = perfective in this case
			*(res + 2) = 'p';
		}

		// mood and participles
		if (wcsncmp(wprop, L"повелително наклонение", 7) == 0) {
			wprop += 22;
			*(res + 4) = 'z';
			*(res + 7) = '2';
		}
		else if (wcsncmp(wprop, L"мин.деят.несв.прич.", 12) == 0) {
			wprop += 19;
			*(res + 4) = 'c';
			*(res + 5) = 'a';
			*(res + 6) = 'm';
			strcat(res, "-i");
		}
		else if (wcsncmp(wprop, L"мин.деят.св.прич.", 12) == 0) {
			wprop += 17;
			*(res + 4) = 'c';
			*(res + 5) = 'a';
			*(res + 6) = 'o';
			strcat(res, "-i");
		}
		else if (wcsncmp(wprop, L"мин.страд.прич.", 9) == 0) {
			wprop += 15;
			*(res + 4) = 'c';
			*(res + 5) = 'v';
			strcat(res, "-i");
		}
		else if (wcsncmp(wprop, L"сег.деят.прич.", 7) == 0) {
			wprop += 14;
			*(res + 4) = 'c';
			*(res + 5) = 'a';
			*(res + 6) = 'r';
			strcat(res, "-i");
		}
		else if (wcsncmp(wprop, L"деепричастие", 7) == 0) {
			*(res + 4) = 'g';
			*(res + 5) = '\0';
			goto end;
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else if (*wprop == L' ') {
			wprop += 1;
		}

		// tense
		if (wcsncmp(wprop, L"сег.вр.", 6) == 0) {
			wprop += 7;
			*(res + 6) = 'r';
		}
		else if (wcsncmp(wprop, L"мин.несв.вр.", 6) == 0) {
			wprop += 12;
			*(res + 6) = 'm';
		}
		else if (wcsncmp(wprop, L"мин.св.вр.", 6) == 0) {
			wprop += 10;
			*(res + 6) = 'o';
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else if (*wprop == L' ') {
			wprop += 1;
		}

		// person
		if (wcsncmp(wprop, L"1л.", 3) == 0) {
			wprop += 3;
			*(res + 7) = '1';
		}
		else if (wcsncmp(wprop, L"2л.", 3) == 0) {
			wprop += 3;
			*(res + 7) = '2';
		}
		else if (wcsncmp(wprop, L"3л.", 3) == 0) {
			wprop += 3;
			*(res + 7) = '3';
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else if (*wprop == L' ') {
			wprop += 1;
		}

		// number
		if (wcsncmp(wprop, L"ед.ч.", 4) == 0) {
			wprop += 5;
			*(res + 8) = 's';
		}
		else if (wcsncmp(wprop, L"мн.ч.", 4) == 0) {
			wprop += 5;
			*(res + 8) = 'p';
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else if (*wprop == L' ') {
			wprop += 1;
		}

		// gender
		if (wcsncmp(wprop, L"м.р.", 4) == 0) {
			wprop += 4;
			*(res + 9) = 'm';
		}
		else if (wcsncmp(wprop, L"ж.р.", 4) == 0) {
			wprop += 4;
			*(res + 9) = 'f';
		}
		else if (wcsncmp(wprop, L"ср.р.", 5) == 0) {
			wprop += 5;
			*(res + 9) = 'n';
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else if (*wprop == L' ') {
			wprop += 1;
		}

		// article
		if (wcsncmp(wprop, L"членувано", 5) == 0) {
			*(res + 10) = 'd';
		}
		else if (wcsncmp(wprop, L"непълен член", 5) == 0) {
			*(res + 10) = 'h';
		}
		else if (wcsncmp(wprop, L"пълен член", 5) == 0) {
			*(res + 10) = 'f';
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
			strcat(res, "d");
			if (wcsncmp(wword, L"инак", 4) == 0) {
				strcat(res, "a");
			}
			else {
				strcat(res, "e");
			}
		}
		else if (strncmp(pos, "relative", 4) == 0) {
			strcat(res, "r");

			if (wcsncmp(wword, L"чи", 2) == 0) {
				strcat(res, "p");
			}
			else if (wcsncmp(wword, L"ка", 2) == 0) {
				strcat(res, "a");
			}
			else {
				strcat(res, "e");
			}
		}
		else if (strncmp(pos, "general", 4) == 0) {
			// pronominal_general in rechko corresponds to collective pronouns
			strcat(res, "c");
			if (wcsncmp(wword, L"всич", 4) == 0) {
				strcat(res, "q");
			}
			else if (wcsncmp(wword, L"всякак", 6) == 0) {
				strcat(res, "a");
			}
			else {
				strcat(res, "e");
			}
		}
		else if (strncmp(pos, "interrogative", 4) == 0) {
			strcat(res, "i");
			if (wcsncmp(wword, L"чи", 2) == 0) {
				strcat(res, "p");
			}
			else if (wcsncmp(wword, L"ка", 2) == 0) {
				strcat(res, "a");
			}
			else {
				strcat(res, "e");
			}
		}
		else if (strncmp(pos, "indefinite", 4) == 0) {
			strcat(res, "f");
			if (wcsncmp(wword, L"неч", 3) == 0) {
				strcat(res, "p");
			}
			else {
				strcat(res, "e");
			}
		}
		else if (strncmp(pos, "negative", 4) == 0) {
			strcat(res, "n");
			if (wcsncmp(wword, L"нич", 3) == 0) {
				strcat(res, "p");
			}
			else if (wcsncmp(wword, L"никак", 5) == 0) {
				strcat(res, "a");
			}
			else {
				strcat(res, "e");
			}
		}
		else if (strncmp(pos, "possessive", 4) == 0) {
			strcat(res, "s");
			if (wcsncmp(wword, L"сво", 3) == 0) {
				strcat(res, "x");
			}
			else if (wcsncmp(wword, L"в", 1) == 0) {
				strcat(res, "h");
			}
			else if (wcsncmp(wword, L"наш", 3) == 0 || wcsncmp(wword, L"т", 1) == 0) {
				strcat(res, "z");
			}
			else {
				strcat(res, "o");
			}
		}

		strcat(res, "l"); // assume long form for now

		if (wcsncmp(wprop, L"имен", 4) == 0) {
			strcat(res, "o");
			wprop += 16;
		}
		else if (wcsncmp(wprop, L"вин", 3) == 0) {
			strcat(res, "a");
			wprop += 15;
		}
		else if (wcsncmp(wprop, L"дат", 3) == 0) {
			strcat(res, "d");
			wprop += 13;
		}
		else {
			strcat(res, "-");
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else {
			goto end;
		}

		if (wcsncmp(wprop, L"крат", 4) == 0) {
			*(res + 3) = 't';
			goto end;
		}
	}
	// NUMERALS
	else if (strncmp(pos, "num", 3) == 0) {
		pos += 8;
		strcpy(res, "M");

		if (strncmp(pos, "cardinal", 1) == 0) {
			strcat(res, "c");
		}
		else {
			strcat(res, "o");
		}

		strcat(res, "-si");

		if (wcsncmp(wprop, L"м.р.", 2) == 0) {
			wprop += 4;
			*(res + 2) = 'm';
		}
		else if (wcsncmp(wprop, L"ж.р.", 2) == 0) {
			wprop += 4;
			*(res + 2) = 'f';
		}
		else if (wcsncmp(wprop, L"ср.р.", 3) == 0) {
			wprop += 5;
			*(res + 2) = 'n';
		}
		else if (wcsncmp(wprop, L"приблизителен брой", 4) == 0) {
			*(res + 1) = 'y';
			*(res + 3) = 'p';
			wprop += 18;
		}
		else if (wcsncmp(wprop, L"мъжколична форма", 4) == 0) {
			wprop += 16;
		}
		else if (wcsncmp(wprop, L"бройна форма", 4) == 0) {
			wprop += 12;
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else if(!*wprop) {
			goto end;
		}

		if (wcsncmp(wprop, L"ед.ч.", 3) == 0) {
			wprop += 5;
		}
		else if (wcsncmp(wprop, L"мн.ч.", 3) == 0) {
			wprop += 5;
			*(res + 3) = 'p';
		}

		if (*wprop == L',') {
			wprop += 2;
		}
		else if(!*wprop) {
			goto end;
		}

		if (wcsncmp(wprop, L"членувано", 2) == 0) {
			*(res + 4) = 'd';
		}
		else if (wcsncmp(wprop, L"пълен", 2) == 0) {
			*(res + 4) = 'f';
		}
		else if (wcsncmp(wprop, L"непълен", 3) == 0) {
			*(res + 4) = 'h';
		}
	}

end:
	free(wword_o);
	free(wprop_o);
	return res;
}
