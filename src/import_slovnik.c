#include <sqlite3.h>
#include "../inc/sqlite3_aux.h"
#include "../inc/import_slovnik.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <locale.h>

sqlite3 *db = NULL;
char *scratch_path = NULL;
char *db_path = NULL;
char *db_file_name = NULL;
char *slovnik_path = NULL;

int main(int argc, char **argv) {
	setlocale(LC_ALL, "");

	if (argc != 3) {
		fprintf(stderr, "You must pass the scratch path \
 and the database name as arguments.\n");
		exit(1);
	}

	scratch_path = argv[1];
	db_file_name = argv[2];
	db_path = malloc(strlen(scratch_path) + strlen(db_file_name) + 2);
	sprintf(db_path, "%s/%s", scratch_path, db_file_name);

	initialize_db(&db, db_path);

	slovnik_path = malloc(strlen(scratch_path) + strlen(SLOVNIK_FILE_NAME) + 2);
	sprintf(slovnik_path, "%s/%s", scratch_path, SLOVNIK_FILE_NAME);

	import_slovnik_wordforms(slovnik_path);

	free(db_path);
	free(slovnik_path);
	sqlite3_close(db);
	return 0;
}

void import_slovnik_wordforms(char* path) {
	printf("Importing table from %s...\n", path);
	FILE *fp = fopen(path, "r");
	if (fp == NULL) {
		fprintf(stderr, "Slovnik wordforms file does not exist \
in %s.", path);
		exit(1);
	}

	char *line = NULL;
	char *delim = "\t";
	size_t len = 0;
	ssize_t read;
	const int maxcols = 3;
	char *toks[maxcols];

	sqlite3_stmt* stmt = 0;
	int rc = sqlite3_prepare_v2(db, "INSERT INTO slovnik_wordform (wordform, lemma, tag, is_lemma, num_syllables) VALUES (?, ?, ?, ?, ?);", -1, &stmt, 0);
	rc = sqlite3_exec(db, "BEGIN TRANSACTION", 0, 0, 0);
	rc = sqlite3_exec(db, "PRAGMA synchronous = OFF", 0, 0, 0);
	rc = sqlite3_exec(db, "PRAGMA journal_mode = OFF", 0, 0, 0);

	while ((read = getline(&line, &len, fp)) != -1) {
		int ncols = 0;
		char *tok = strtok(line, delim);

		while (tok != NULL && ncols < maxcols) {
			toks[ncols] = tok;
			ncols++;
			tok = strtok(NULL, delim);
		}

		char *nwp = NULL;
		if((nwp = strchr(toks[2], '\n')) != NULL)
			*nwp = '\0';

		if (ncols == maxcols) {
			rc = sqlite3_bind_text(stmt, 1, toks[0], -1, SQLITE_TRANSIENT);
			rc = sqlite3_bind_text(stmt, 2, toks[2], -1, SQLITE_TRANSIENT);
			rc = sqlite3_bind_text(stmt, 3, toks[1], -1, SQLITE_TRANSIENT);
			rc = sqlite3_bind_int(stmt, 4, is_lemma(toks[0], toks[2], toks[1]));
			rc = sqlite3_bind_int(stmt, 5, count_syllables(toks[0]));
			rc = sqlite3_step(stmt);
		}

		rc = sqlite3_clear_bindings(stmt);
		rc = sqlite3_reset(stmt);
	}

	char *zErrMsg = 0;
	rc = sqlite3_exec(db, "END TRANSACTION", 0, 0, &zErrMsg);
	rc = sqlite3_finalize(stmt);

	fclose(fp);
	free(line);
}

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
