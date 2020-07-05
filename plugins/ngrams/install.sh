#!/bin/bash
DICT_PATH=${1:-$(echo ${BASH_SOURCE%/*}/../../dictionary.*.db)}
LIB_PATH="${BASH_SOURCE%/*}/../../lib/libextfun"

echo Adding unigrams to $DICT_PATH...
sqlite3 $DICT_PATH ".read ${BASH_SOURCE%/*}/10_create_ngram.sql"
sqlite3 $DICT_PATH ".separator \t" ".import tools/corpus_processor/models/unigram.tsv unigram"
sqlite3 $DICT_PATH ".load $LIB_PATH" ".read ${BASH_SOURCE%/*}/11_add_metadata.sql"
sqlite3 $DICT_PATH ".read ${BASH_SOURCE%/*}/20_create_unknown_wordform_view.sql"
sqlite3 $DICT_PATH ".read ${BASH_SOURCE%/*}/21_create_frequency_view.sql"