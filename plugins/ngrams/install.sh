#!/bin/bash
DICT_PATH=${1:-$(echo ${BASH_SOURCE%/*}/../../dictionary.*.db)}

echo Adding unigrams to $DICT_PATH...
sqlite3 $DICT_PATH ".read ${BASH_SOURCE%/*}/10_create_ngram.sql"
sqlite3 $DICT_PATH ".separator \t" ".import tools/corpus_processor/models/unigram.tsv unigram"
sqlite3 $DICT_PATH ".read ${BASH_SOURCE%/*}/20_create_view.sql"