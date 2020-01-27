#include <sqlite3ext.h>
SQLITE_EXTENSION_INIT1

/* TODO: Change the entry point name so that "extension" is replaced by
 * ** text derived from the shared library filename as follows:  Copy every
 * ** ASCII alphabetic character from the filename after the last "/" through
 * ** the next following ".", converting each character to lowercase, and
 * ** discarding the first three characters if they are "lib".
 * */
int sqlite3_extfun_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi){
	int rc = SQLITE_OK;
	SQLITE_EXTENSION_INIT2(pApi);
	/* Insert here calls to
	 *   **     sqlite3_create_function_v2(),
	 *     **     sqlite3_create_collation_v2(),
	 *       **     sqlite3_create_module_v2(), and/or
	 *         **     sqlite3_vfs_register()
	 *           ** to register the new features that your extension adds.
	 *             */
	return rc;
}
