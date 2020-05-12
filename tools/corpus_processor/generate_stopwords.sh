#!/bin/bash
source include.sh

# unigrams
python3 ngram_counter.py $PATH_TO_CORPUS --marshal $MODEL_PATH/unigram.pkl --export $MODEL_PATH/unigram.tsv --no-interning
cut -f1 -d$'\t' $MODEL_PATH/unigram.tsv | head -n 130 |
  grep -Ev "^(път|човек|попита|очи|глава|ръка|години)" >$MODEL_PATH/stopwords.txt
