#!/bin/bash
source include.sh
COUNTER_FILE=frequency_list.tsv

python3 ngram_counter.py $PATH_TO_CORPUS --export $MODEL_PATH/$COUNTER_FILE --no-interning
cut -f1 -d$'\t' $MODEL_PATH/$COUNTER_FILE | head -n 130 |
  grep -Ev "^(път|човек|попита|очи|глава|ръка|години)" >$MODEL_PATH/stopwords.txt
