#include <sqlite3ext.h>
#include <stdio.h>
SQLITE_EXTENSION_INIT1

static void firstchar(sqlite3_context *context, int argc, sqlite3_value **argv);

int sqlite3_extfun_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi){
	int rc = SQLITE_OK;
	SQLITE_EXTENSION_INIT2(pApi);
	printf("%s\n", "Loading libextfun.so...");
	// registering all custom sqlite functions
	sqlite3_create_function(db, "firstchar", 1, SQLITE_UTF8, NULL, &firstchar, NULL, NULL);
	return rc;
}

// doesn't work with utf-8 for now
static void firstchar(sqlite3_context *context, int argc, sqlite3_value **argv)
{
	if (argc == 1) {
		const char *text = sqlite3_value_text(argv[0]);
		if (text && text[0]) {
			char result[2];
			result[0] = text[0];
			result[1] = '\0';
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			return;
		}
	}

	sqlite3_result_null(context);
}
