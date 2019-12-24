#include <sqlite3.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <locale.h>

void initialize_memory_db(sqlite3 **db);
int persist_db(sqlite3 *pInMemory, const char *zFilename);
void import_slovnik_wordforms(char* path);
int count_syllables(char *str);
char * read_file_into_string(char * filename);

sqlite3 *db = NULL;

int main(int argc, char **argv) {
	setlocale(LC_ALL, "");

	if (argc != 2) {
		fprintf(stderr, "You must pass the path to \
the scratchpad as an argument.\n");
		exit(1);
	}

	char *err_msg = 0;
	initialize_memory_db(&db);

	char *sql = read_file_into_string("scripts/10_create_slovnik_wordform.sql");
	int rc = sqlite3_exec(db, sql, 0, 0, &err_msg);
	free(sql);

	if (rc != SQLITE_OK ) {
		fprintf(stderr, "SQL error: %s\n", err_msg);
		sqlite3_free(err_msg);
		sqlite3_close(db);
		return 1;
	}

	import_slovnik_wordforms(strcat(argv[1], "/slovnik.txt"));

	persist_db(db, "dictionary.db");
	sqlite3_close(db);
	return 0;
}

void initialize_memory_db(sqlite3 **db) {
	int rc = sqlite3_open(":memory:", db);

	if (rc != SQLITE_OK) {
		fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(*db));
		sqlite3_close(*db);
		exit(1);
	}	
}

int persist_db(sqlite3 *pInMemory, const char *zFilename) {
	int rc;
	sqlite3 *pFile;
	sqlite3_backup *pBackup;

	rc = sqlite3_open(zFilename, &pFile);
	if(rc == SQLITE_OK) {
		pBackup = sqlite3_backup_init(pFile, "main", pInMemory, "main");
		if( pBackup ){
			(void)sqlite3_backup_step(pBackup, -1);
			(void)sqlite3_backup_finish(pBackup);
		}

		rc = sqlite3_errcode(pFile);
	}

	(void)sqlite3_close(pFile);
	return rc;
}

void import_slovnik_wordforms(char* path) {
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

	while ((read = getline(&line, &len, fp)) != -1) {
		int ncols = 0;
		char *tok = strtok(line, delim);

		while (tok != NULL && ncols < maxcols) {
			toks[ncols] = tok;
			ncols++;
			tok = strtok(NULL, delim);
		}

		char *nwp;
		if((nwp = strchr(toks[2], '\n')) != NULL)
			*nwp = '\0';

		if (ncols == maxcols) {
			rc = sqlite3_bind_int(stmt, 4, strcmp(toks[0], toks[2]) == 0);
			rc = sqlite3_bind_int(stmt, 5, count_syllables(toks[0]));
			rc = sqlite3_bind_text(stmt, 1, toks[0], -1, SQLITE_TRANSIENT);
			rc = sqlite3_bind_text(stmt, 2, toks[2], -1, SQLITE_TRANSIENT);
			rc = sqlite3_bind_text(stmt, 3, toks[1], -1, SQLITE_TRANSIENT);
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

int count_syllables(char *str) {
	int cnt = 0;
	int strl = strlen(str);
	int wstrl = (strl / 2) + 1; // we don't expect more than 2 bytes per character
	wchar_t *wstr = (wchar_t *) malloc(sizeof(wchar_t) * wstrl);
	int rc = mbstowcs(wstr, str, wstrl);

	for (size_t i = 0; wstr[i]; ++i) {
		wchar_t wc = wstr[i];
    	if (wc == u'\u0430' || wc == u'\u0435' || wc == u'\u0438' \
|| wc == u'\u043E' || wc == u'\u0443' || wc == u'\u044A' || wc == u'\u044E' \
|| wc == u'\u044F') {
			cnt++;
    	}
	}

	free(wstr);
	return cnt;
}

char *read_file_into_string(char * filename) {
	char * buffer = 0;
	long length;
	FILE * f = fopen (filename, "rb");

	if (f) {
		fseek (f, 0, SEEK_END);
		length = ftell (f);
		fseek (f, 0, SEEK_SET);
		buffer = malloc (length);

		if (buffer) {
			fread (buffer, 1, length, f);
		}

		fclose (f);
	}

	return buffer;
}
