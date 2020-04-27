#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <libdict.h>
#include <string_aux.h>

// all of these arrays should be ordered ascendingly
// includes ю and я, which are not vowels
static const wchar_t lc_vocals[] = { L'а', L'е', L'и', L'о', L'у', L'ъ', L'ю', L'я' };
// skipping й
static const wchar_t lc_sonorants[] = { L'л', L'м', L'н', L'р' };
// ignoring дж and дз
static const wchar_t lc_voiced[] = { L'б', L'в', L'г', L'д', L'ж', L'з' };
static const wchar_t lc_unvoiced[] = { L'к', L'п', L'с', L'т', L'ф', L'х', L'ц', L'ч', L'ш', L'щ' };
// keep the elements of the bottom two arrays to be parallel for first 6 consonants
static const wchar_t lc_voiced_m[] = { L'б', L'в', L'г', L'д', L'ж', L'з' };
static const wchar_t lc_unvoiced_m[] = { L'п', L'ф', L'к', L'т', L'ш', L'с' };

void lowercase_string(wchar_t * wstr) {
	for (; *wstr; wstr++) {
		if (is_cyrillic(*wstr)) {
			lowercase_char(wstr);
		}
	}
}

int is_capitalized(const wchar_t * const word) {
	return *word >= u'\u0410' && *word < u'\u0430';
}

int is_vocal(wchar_t wc) {
	return is_wc_of_charset_ci_sc(wc, lc_vocals, sizeof(lc_vocals) / sizeof(wchar_t));
}

int is_sonorant(wchar_t wc) {
	return is_wc_of_charset_ci_sc(wc, lc_sonorants, sizeof(lc_sonorants) / sizeof(wchar_t));
}

int is_voiced(wchar_t wc) {
	return is_wc_of_charset_ci_sc(wc, lc_voiced, sizeof(lc_voiced) / sizeof(wchar_t));
}

int is_unvoiced(wchar_t wc) {
	return is_wc_of_charset_ci_sc(wc, lc_unvoiced, sizeof(lc_unvoiced) / sizeof(wchar_t));
}

int is_consonant(wchar_t wc) {
	return is_cyrillic(wc) && !is_vocal(wc);
}

wchar_t invert_voiced(wchar_t wc) {
	int idx = is_wc_of_charset_ci(wc, lc_voiced_m, sizeof(lc_voiced_m) / sizeof(wchar_t));
	if (idx) {
		wc = lc_unvoiced_m[idx - 1];
	}
	return wc;
}

wchar_t invert_unvoiced(wchar_t wc) {
	int idx = is_wc_of_charset_ci(wc, lc_unvoiced_m, sizeof(lc_unvoiced_m) / sizeof(wchar_t));
	if (idx) {
		wc = lc_voiced_m[idx - 1];
	}
	return wc;
}

int sonority_char(wchar_t wc) {
	if (is_voiced(wc)) {
		return 2;
	}
	else if(is_unvoiced(wc)) {
		return 1;
	}
	else if(is_sonorant(wc)) {
		return 3;
	}
	else if(is_vocal(wc)) {
		return 4;
	}

	return 0;
}

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
	size_t strl = strlen(str);
	wchar_t wstr[strl];
	convert_to_wstring_h(wstr, str, strl);

	for (size_t i = 0; wstr[i]; ++i) {
		// count graphemes corresponding to vowels as a proxy
		if (is_vocal(wstr[i]))
			cnt++;
	}

	return cnt;
}

void accent_model(char * result, const char * word) {
	result[0] = '\0';
	size_t wlen = strlen(word);
	wchar_t wword[wlen];
	size_t wwlen = convert_to_wstring_h(wword, word, wlen);

	int rlen = 0;
	for (int i = 0; i < wwlen; i++) {
		if (is_vocal(wword[i])) {
			strcat(result, "0");
			rlen++;
		}
		else if (wword[i] == L'`' && rlen > 0) {
			result[rlen - 1] = '1';
		}
	}
}

void sonority_model(char * result, const char * word) {
	size_t wlen = strlen(word);
	wchar_t wword[wlen];
	size_t wwlen = convert_to_wstring_h(wword, word, wlen);

	int rlen = 0;
	for (int i = 0; i < wwlen; i++) {
		int sonority = sonority_char(wword[i]);
		if (sonority > 0)
			result[rlen++] = sonority + '0';
	}

	result[rlen] = '\0';
}

void pronounce(char * result, size_t rlen, const char * word) {
	size_t wlen = strlen(word);
	wchar_t wword[wlen + 2];
	size_t wwlen = convert_to_wstring_h(wword, word, wlen);
	wword[wwlen++] = '$'; // word terminator
	wword[wwlen] = '\0';
	wchar_t wres[rlen];

	// lowercase entire wordform
	lowercase_string(wword);

	int k = 0;
	int cc = 0; // consecutive consonants
	for (int i = 0; i < wwlen; i++) {
		wchar_t wc = wword[i];
		if (is_consonant(wc)) {
			cc++;
		}
		else {
			if (cc == 2) {
				if (wres[k - 2] == L'т' && wres[k - 1] == L'т') {
					wres[k - 2] = wres[k - 1];
					k--;
				}
			}
			else if (cc == 3) {
				if ((wres[k - 3] == L'с' && wres[k - 2] == L'т') || (wres[k - 3] == L'з' && wres[k - 2] == L'д')) {
					wres[k - 2] = wres[k - 1];
					k--;
				}
			}
			cc = 0;
		}

		if (wc == '$') {
			break;
		}

		if (i < wwlen - 1) {
			wchar_t nwc = wword[i + 1];
			int sonority_curr = sonority_char(wc);
			int sonority_nxt = sonority_char(nwc);
			if (sonority_curr == 2 && sonority_nxt == 1) {
				wres[k++] = invert_voiced(wc);
				continue;
			}
			else if (sonority_curr == 1 && sonority_nxt == 2 && nwc != L'в') {
				wres[k++] = invert_unvoiced(wc);
				continue;
			}
		}

		if (wc == L'щ') {
			wres[k++] = L'ш';
			wres[k++] = L'т';
		}
		else if (wc == L'я') {
			wres[k++] = L'й';
			wres[k++] = L'а';
		}
		else if (wc == L'ю') {
			wres[k++] = L'й';
			wres[k++] = L'у';
		}
		else if (wc == L'ь') {
			wres[k++] = L'й';
		}
		else {
			wres[k++] = wc;
		}
	}

	// check if it ends in дж or дз
	if (wres[k - 2] == L'д' && (wres[k - 1] == L'ж' || wres[k - 1] == L'з')) {
		if (wres[k - 1] == L'ж') {
			wres[k - 2] = L'ч';
		}
		else {
			wres[k - 2] = L'ц';
		}
		k--;
	}

	wres[k] = '\0';

	// loss of voice for last voiced consonant in the word
	wchar_t last_letter = wres[k - 1];
	if (is_voiced(last_letter)) {
		wres[k - 1] = invert_voiced(last_letter);
	}

	convert_to_mbstring_h(result, wres, rlen);
}

const char * diminutive_to_base(const char * word) {
	static const wchar_t * const suff[] = 
	// only append new elements to the end or check the switch statement below
				{ L"че", L"це", L"йка", L"чица", L"джийка", L"нце" };
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

const char * stress_syllable(const char * word, int n) {
	wchar_t * wword = convert_to_wstring(word);
	wchar_t * const wword_o = wword;
	const size_t wword_len = wcslen(wword);
	const size_t wres_len = wword_len + 1;
	wchar_t * const wres = (wchar_t *) calloc(wres_len + 1, sizeof(wchar_t));

	if (n <= 0)
		goto copy;

	int k = 0;
	for (; *wword != '\0' && n > 0; k++, wword++) {
		if (is_vocal(*wword)) {
			n--;
		}
	}

	if (!*wword && n > 0) {
	copy:
		wcsncpy(wres, wword_o, wword_len);
	}
	else {
		wcsncpy(wres, wword_o, k);
		wcscat(wres, L"`");
		wcsncpy(wres + k + 1, wword, wword_len - k);
	}

	free(wword_o);
	char * res = convert_to_mbstring(wres);
	free(wres);
	return res;
}

const char * remove_last_char(const char * word, const char * c) {
	wchar_t * wword = convert_to_wstring(word);
	const size_t wword_len = wcslen(wword);
	wchar_t * wc = convert_to_wstring(c);
	wchar_t * const wc_o = wc;

	// last occurence of char
	wchar_t * lwc = wcsrchr(wword, *wc);

	if (lwc != NULL) {
		wmemmove(lwc, lwc + 1, wword_len - (lwc - wword));
	}

	free(wc_o);
	char * res = convert_to_mbstring(wword);
	free(wword);
	return res;
}

int find_nth_stressed_syllable(const char * word, int n) {
	wchar_t * wword = convert_to_wstring(word);
	wchar_t * const wword_o = wword;
	const size_t wword_len = wcslen(wword);

	int syllable_count = 0;
	for (; *wword != '\0' && n > 0; wword++) {
		if (is_vocal(*wword)) {
			syllable_count++;
		}
		else if (*wword == L'`') {
			n--;
		}
	}

	free(wword_o);
	if (n == 0)
		return syllable_count;
	return -1;
}

int find_nth_stressed_syllable_rev(const char * word, int n) {
	char * copy = mbcopy(word);
	utf8rev(copy);
	int num_syllables = count_syllables(word);
	int result = find_nth_stressed_syllable(copy, n);
	free(copy);

	if (result > -1)
		return num_syllables - result;
	return result;
}

void rechko_tag(char * res, const char * word, const char * pos, const char * prop) {
	size_t word_len = strlen(word);
	wchar_t wword_a[word_len];
	wchar_t * wword = wword_a;
	convert_to_wstring_h(wword, word, word_len);

	size_t prop_len = strlen(prop);
	wchar_t wprop_a[prop_len];
	wchar_t * wprop = wprop_a;
	convert_to_wstring_h(wprop, prop, prop_len);

	wchar_t * const wword_o = wword;
	wchar_t * const wprop_o = wprop;

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
			return;
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
			return;
		}

	noun_article:
		if(!*wprop) {
			strcat(res, "i");
			return;
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
			return;
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
			return;
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
			return;
		}

		if (wcsncmp(wprop, L"крат", 4) == 0) {
			*(res + 3) = 't';
			return;
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
			return;
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
			return;
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
}
