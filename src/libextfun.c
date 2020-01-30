#include <sqlite3ext.h>
#include <stdio.h>
#include "../inc/libdict.h"
SQLITE_EXTENSION_INIT1

static void sqlite_count_syllables(sqlite3_context *context, int argc, sqlite3_value **argv);

int sqlite3_extfun_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi){
	int rc = SQLITE_OK;
	SQLITE_EXTENSION_INIT2(pApi);
	printf("%s\n", "Loading libextfun.so...");
	// registering all custom sqlite functions
	sqlite3_create_function(db, "count_syllables", 1, SQLITE_UTF8, NULL, &sqlite_count_syllables, NULL, NULL);
	return rc;
}

static void sqlite_count_syllables(sqlite3_context *context, int argc, sqlite3_value **argv)
{
	if (argc == 1) {
		const char *text = sqlite3_value_text(argv[0]);
		if (text && text[0]) {
			int num = count_syllables(text);
			sqlite3_result_int(context, num);
			return;
		}
	}

	sqlite3_result_null(context);
}
