#include <sqlite3.h>
#include <sqlite3_aux.h>
#include <import_slovnik.h>
#include <libdict.h>
#include <stdio.h>
#include <locale.h>
#include <string.h>
#include <stdlib.h>

sqlite3 * db = NULL;
char * slovnik_path = NULL;
char * db_path = NULL;

int main(int argc, char ** argv) {
	setlocale(LC_ALL, "");

	if (argc != 3) {
		fprintf(stderr, "You must pass the scratch path \
 and the database name as arguments.\n");
		exit(1);
	}

	slovnik_path = argv[1];
	db_path = argv[2];

	initialize_db(&db, db_path);
	import_slovnik_wordforms(slovnik_path);

	sqlite3_close(db);
	return 0;
}

void import_slovnik_wordforms(char * path) {
	printf("Importing table from %s...\n", path);
	FILE *fp = fopen(path, "r");
	if (fp == NULL) {
		fprintf(stderr, "Slovnik wordforms file does not exist in %s.\n", path);
		exit(1);
	}

	char * line = NULL;
	char * delim = "\t";
	size_t len = 0;
	size_t read;
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
