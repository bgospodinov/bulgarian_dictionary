#include <sqlite3ext.h>
#include <stdio.h>
#include <string.h>
#include <locale.h>
#include <stdlib.h>
#include "../inc/libdict.h"
#include "../inc/string_aux.h"
SQLITE_EXTENSION_INIT1

static void sqlite_is_lemma(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_is_vocal(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_count_syllables(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_rechko_tag(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_stress_syllable(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_replace_last_stress(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_remove_last_char(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_find_nth_stressed_syllable(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_find_nth_stressed_syllable_rev(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_diminutive_to_base(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_accent_model(sqlite3_context *context, int argc, sqlite3_value **argv);
static void sqlite_reverse(sqlite3_context *context, int argc, sqlite3_value **argv);

int sqlite3_extfun_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi) {
	setlocale(LC_ALL, "");
	int rc = SQLITE_OK;
	SQLITE_EXTENSION_INIT2(pApi);
	// registering all custom sqlite functions
	sqlite3_create_function(db, "is_lemma", 3, SQLITE_UTF8, NULL, &sqlite_is_lemma, NULL, NULL);
	sqlite3_create_function(db, "is_vocal", 1, SQLITE_UTF8, NULL, &sqlite_is_vocal, NULL, NULL);
	sqlite3_create_function(db, "count_syllables", 1, SQLITE_UTF8, NULL, &sqlite_count_syllables, NULL, NULL);
	sqlite3_create_function(db, "rechko_tag", 3, SQLITE_UTF8, NULL, &sqlite_rechko_tag, NULL, NULL);
	sqlite3_create_function(db, "stress_syllable", 2, SQLITE_UTF8, NULL, &sqlite_stress_syllable, NULL, NULL);
	sqlite3_create_function(db, "replace_last_stress", 2, SQLITE_UTF8, NULL, &sqlite_replace_last_stress, NULL, NULL);
	sqlite3_create_function(db, "remove_last_char", 2, SQLITE_UTF8, NULL, &sqlite_remove_last_char, NULL, NULL);
	sqlite3_create_function(db, "find_nth_stressed_syllable", 2, SQLITE_UTF8, NULL, &sqlite_find_nth_stressed_syllable, NULL, NULL);
	sqlite3_create_function(db, "find_nth_stressed_syllable_rev", 2, SQLITE_UTF8, NULL, &sqlite_find_nth_stressed_syllable_rev, NULL, NULL);
	sqlite3_create_function(db, "diminutive_to_base", 1, SQLITE_UTF8, NULL, &sqlite_diminutive_to_base, NULL, NULL);
	sqlite3_create_function(db, "accent_model", 1, SQLITE_UTF8, NULL, &sqlite_accent_model, NULL, NULL);
	sqlite3_create_function(db, "reverse", 1, SQLITE_UTF8, NULL, &sqlite_reverse, NULL, NULL);
	return rc;
}

static void sqlite_is_lemma(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 3) {
		const char *word = sqlite3_value_text(argv[0]);
		const char *lemma = sqlite3_value_text(argv[1]);
		const char *tag = sqlite3_value_text(argv[2]);
		if (word && lemma && tag) {
			int result = is_lemma(word, lemma, tag);
			sqlite3_result_int(context, result);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_is_vocal(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 1) {
		const char * word = sqlite3_value_text(argv[0]);
		if (word) {
			wchar_t wchar = 0;
			wchar_t * pwchar = &wchar;
			mbstowcs(pwchar, word, 1);
			int result = is_vocal(*pwchar);
			sqlite3_result_int(context, result);
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
			char result[15];
			rechko_tag(result, word, pos, prop);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_stress_syllable(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 2) {
		const char * text = sqlite3_value_text(argv[0]);
		int n = sqlite3_value_int(argv[1]);
		if (text) {
			char * result = (char *)stress_syllable(text, n);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			free(result);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_replace_last_stress(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 2) {
		const char * text = sqlite3_value_text(argv[0]);
		int n = sqlite3_value_int(argv[1]);
		if (text) {
			char * result = (char *)stress_syllable(remove_last_char(mbcopy(text), "`"), n);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			free(result);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_remove_last_char(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 2) {
		const char * text = sqlite3_value_text(argv[0]);
		const char * c = sqlite3_value_text(argv[1]);
		if (text) {
			char * result = (char *)remove_last_char(text, c);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			free(result);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_find_nth_stressed_syllable(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 2) {
		const char * text = sqlite3_value_text(argv[0]);
		int n = sqlite3_value_int(argv[1]);
		if (text) {
			int result = find_nth_stressed_syllable(text, n);
			sqlite3_result_int(context, result);
			return;
		}
	}

	sqlite3_result_int(context, -1);
}

static void sqlite_find_nth_stressed_syllable_rev(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 2) {
		const char * text = sqlite3_value_text(argv[0]);
		int n = sqlite3_value_int(argv[1]);
		if (text) {
			int result = find_nth_stressed_syllable_rev(text, n);
			sqlite3_result_int(context, result);
			return;
		}
	}

	sqlite3_result_int(context, -1);
}

static void sqlite_diminutive_to_base(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 1) {
		const char * text = sqlite3_value_text(argv[0]);
		if (text) {
			char * result = (char *)diminutive_to_base(text);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			free(result);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_accent_model(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 1) {
		const char * text = sqlite3_value_text(argv[0]);
		if (text) {
			char result[strlen(text) + 1];
			accent_model(result, text);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			return;
		}
	}

	sqlite3_result_null(context);
}

static void sqlite_reverse(sqlite3_context *context, int argc, sqlite3_value **argv) {
	if (argc == 1) {
		const char * text = sqlite3_value_text(argv[0]);
		if (text) {
			char * result = mbcopy(text);
			utf8rev(result);
			sqlite3_result_text(context, result, -1, SQLITE_TRANSIENT);
			free(result);
			return;
		}
	}

	sqlite3_result_null(context);
}