#ifndef SQLITE3_AUX_H_
#define SQLITE3_AUX_H_

void initialize_db(sqlite3 **db, char *db_path);
char *read_file_into_string(char *filename);
int run_sql_file(sqlite3 *db, char *path);

#endif // SQLITE3_AUX_H_