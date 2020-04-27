#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <libdict.h>
#include <sqlite3.h>
#include <sqlite3_aux.h>
#include <string_aux.h>

static void generate_syllable();
static sqlite3 * db = NULL;

int main(int argc, char ** argv) {
    setlocale(LC_ALL, "");
    if (argc != 2) {
        fprintf(stderr, "You must pass the database path as argument.\n");
        exit(1);
    }
    char * db_path = argv[1];
    initialize_db(&db, db_path);
    generate_syllable();
    sqlite3_close(db);
    return 0;
}

static void generate_syllable() {
    sqlite3_stmt * select_stmt = 0, * insert_stmt = 0;
    int rc = sqlite3_prepare_v2(db, "SELECT pronunciation_id, wordform_id, pronunciation, pronunciation_stressed FROM pronunciation;", -1, &select_stmt, 0);
    rc = sqlite3_prepare_v2(db, "INSERT INTO syllable (pronunciation_id, wordform_id, syllable, position, is_stressed) VALUES(?, ?, ?, ?, ?);", -1, &insert_stmt, 0);
    rc = sqlite3_exec(db, "BEGIN TRANSACTION", 0, 0, 0);
    rc = sqlite3_exec(db, "PRAGMA synchronous = OFF", 0, 0, 0);
    rc = sqlite3_exec(db, "PRAGMA journal_mode = OFF", 0, 0, 0);

    int pronunciation_id, wordform_id;
    const unsigned char * pronunciation, * pronunciation_stressed;
    bool done = false;
    const int WORD_MAX_SZ = 100;
    wchar_t wpron[WORD_MAX_SZ], wprons[WORD_MAX_SZ]; // reuse same fixed-size stack array for all wide-char pronunciations

    while (!done) {
        switch (sqlite3_step(select_stmt)) {
            case SQLITE_ROW:
                pronunciation_id = sqlite3_column_int(select_stmt, 0);
                wordform_id = sqlite3_column_int(select_stmt, 1);
                pronunciation  = sqlite3_column_text(select_stmt, 2);
                pronunciation_stressed  = sqlite3_column_text(select_stmt, 3);
                if (pronunciation != NULL) {
                    size_t pron_len = strlen(pronunciation);
                    size_t wpron_len = convert_to_wstring_h(wpron, pronunciation, pron_len);
                    size_t prons_len = strlen(pronunciation_stressed);
                    size_t wprons_len = convert_to_wstring_h(wprons, pronunciation_stressed, prons_len);
                    int num_syllables = count_syllables(pronunciation);
                    int peak_pos[num_syllables];
                    bool stress_pos[num_syllables];
                    int syllable_endings[num_syllables];

                    for (int i = 0, j = 0; i < wprons_len; i++) {
                        if (is_vocal(wprons[i])) {
                            stress_pos[j++] = (i + 1 < wprons_len && wprons[i + 1] == L'`');
                        }
                    }

                    for (int i = 0, j = 0; i < wpron_len; i++) {
                        if (is_vocal(wpron[i])) {
                            peak_pos[j++] = i;
                        }
                    }

                    for (int i = 0; i < num_syllables - 1; i++) {
                        int left_peak = peak_pos[i], right_peak = peak_pos[i + 1];
                        int syllable_end_pos = left_peak;
                        int peak_distance = right_peak - left_peak;

                        // scan for hyphens or spaces first
                        for (int j = peak_pos[i] + 1; j < peak_pos[i + 1] - 1; j++) {
                            if (wpron[j] == L'-' || wpron[j] == L' ') {
                                syllable_end_pos = j - 1;
                                goto syllable_end;
                            }
                        }

                        if (peak_distance == 3) {
                            syllable_end_pos++;
                        }
                        else if (peak_distance > 3) {
                            syllable_end_pos++;
                            for (int j = peak_pos[i] + 2;
                                    j < (peak_pos[i + 1] - 1) &&
                                        sonority_char(wpron[j]) <= sonority_char(wpron[j - 1]) &&
                                        wpron[j] != L'й';
                                j++, syllable_end_pos++
                            );
                        }

                        syllable_end: syllable_endings[i] = syllable_end_pos;
                    }

                    syllable_endings[num_syllables - 1] = wpron_len - 1;

                    int start = 0;
                    for (int i = 0; i < num_syllables; i++) {
                        if (wpron[start] == L'-' || wpron[start] == L' ') {
                            start++;
                        }
                        int syllable_wide_length = syllable_endings[i] - start + 1;
                        int syllable_char_buffer_length = syllable_wide_length * 2;
                        char syllable[syllable_char_buffer_length];
                        size_t syllable_char_length = wcstombs(syllable, &wpron[start], syllable_char_buffer_length);
                        syllable[syllable_char_length] = '\0';
                        start = syllable_endings[i] + 1;
                        // insert into sqlite db
                        rc = sqlite3_bind_int(insert_stmt, 1, pronunciation_id);
                        rc = sqlite3_bind_int(insert_stmt, 2, wordform_id);
                        rc = sqlite3_bind_text(insert_stmt, 3, syllable, -1, SQLITE_TRANSIENT);
                        rc = sqlite3_bind_int(insert_stmt, 4, i + 1);
                        rc = sqlite3_bind_int(insert_stmt, 5, stress_pos[i]);
                        rc = sqlite3_step(insert_stmt);
                        rc = sqlite3_clear_bindings(insert_stmt);
                        rc = sqlite3_reset(insert_stmt);
                    }
                }
                break;
            case SQLITE_DONE:
                done = true;
                break;
            default:
                fprintf(stderr, "Reading from table failed.\n");
                exit(1);
        }
    }

    char * zErrMsg = 0;
	rc = sqlite3_exec(db, "END TRANSACTION", 0, 0, &zErrMsg);
    rc = sqlite3_finalize(select_stmt);
    rc = sqlite3_finalize(insert_stmt);
}