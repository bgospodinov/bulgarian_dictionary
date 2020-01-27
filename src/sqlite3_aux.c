#include <sqlite3.h>
#include "../inc/sqlite3_aux.h"
#include <stdio.h>
#include <stdlib.h>

void initialize_db(sqlite3 **db, char *db_path) {
	int rc = sqlite3_open(db_path, db);

	if (rc != SQLITE_OK) {
		fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(*db));
		sqlite3_close(*db);
		exit(1);
	}	
}

char *read_file_into_string(char *filename) {
	char *buffer = 0;
	long length;
	FILE *f = fopen (filename, "rb");

	if (f) {
		fseek (f, 0, SEEK_END);
		length = ftell (f);
		fseek (f, 0, SEEK_SET);
		buffer = malloc (length + 1);
		buffer[length] = '\0';

		if (buffer) {
			fread (buffer, 1, length, f);
		}

		fclose(f);
	}
	else {
		fprintf(stderr, "File not found: %s\n", filename);
		exit(1);
	}

	return buffer;
}

int run_sql_file(sqlite3 *db, char *path) {
	printf("Running %s...\n", path);
	char *err_msg = 0;
	char *sql = read_file_into_string(path);
	int rc = sqlite3_exec(db, sql, 0, 0, &err_msg);
	free(sql);

	if (rc != SQLITE_OK) {
		fprintf(stderr, "SQL error: %s\n", err_msg);
		sqlite3_free(err_msg);
		sqlite3_close(db);
	}

	free(err_msg);
	return rc;
}
