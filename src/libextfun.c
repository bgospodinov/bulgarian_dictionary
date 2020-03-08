#include <sqlite3ext.h>
#include <stdio.h>
#include <stdlib.h>
#include "../inc/libdict.h"
SQLITE_EXTENSION_INIT1

static void sqlite_stress_first_syllable(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_count_syllables(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_rechko_tag(sqlite3_context *context, int argc, sqlite3_value **argv);

int sqlite3_extfun_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi) {
	int rc = SQLITE_OK;
	SQLITE_EXTENSION_INIT2(pApi);
	printf("%s\n", "Loading libextfun.so...");
	// registering all custom sqlite functions
	sqlite3_create_function(db, "count_syllables", 1, SQLITE_UTF8, NULL, &sqlite_count_syllables, NULL, NULL);
	sqlite3_create_function(db, "rechko_tag", 3, SQLITE_UTF8, NULL, &sqlite_rechko_tag, NULL, NULL);
	sqlite3_create_function(db, "stress_first_syllable", 1, SQLITE_UTF8, NULL, &sqlite_stress_first_syllable, NULL, NULL);
	return rc;
}


static void sqlite_stress_first_syllable(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 1) {
		const char * text = sqlite3_value_text(argv[0]);
		if (text) {
			char * result = (char *)stress_first_syllable(text);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			free(result);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_count_syllables(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 1) {
		const char * text = sqlite3_value_text(argv[0]);
		if (text) {
			int num = count_syllables(text);
			sqlite3_result_int(context, num);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_rechko_tag(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 3) {
		const char *word = sqlite3_value_text(argv[0]);
		const char *pos = sqlite3_value_text(argv[1]);
		const char *prop = sqlite3_value_text(argv[2]);
		if (word && pos && prop) {
			char * result = (char *)rechko_tag(word, pos, prop);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			free(result);
			return;
		}
	}

	sqlite3_result_null(context);
}
