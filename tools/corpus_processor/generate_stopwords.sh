#!/bin/bash
PATH_TO_CORPUS=../../corpora/chitanka/
COUNTER_FILE=counter.tsv

python3 token_counter.py $PATH_TO_CORPUS $COUNTER_FILE
cut -f1 -d$'\t' $COUNTER_FILE | head -n 99 > stopwords.txt
