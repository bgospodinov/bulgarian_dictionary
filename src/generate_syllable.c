#include <sqlite3.h>
#include <sqlite3_aux.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>

static void generate_syllables();
static sqlite3 * db = NULL;

int main(int argc, char ** argv) {
	setlocale(LC_ALL, "");
    if (argc != 2) {
		fprintf(stderr, "You must pass the database path \
as argument.\n");
		exit(1);
	}

    char * db_path = argv[1];
    initialize_db(&db, db_path);
    generate_syllables();
    sqlite3_close(db);
	return 0;
}

static void generate_syllables() {

}