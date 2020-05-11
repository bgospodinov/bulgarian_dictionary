#!/bin/bash
PATH_TO_CORPUS=../../corpora/chitanka/
MODEL_PATH=models

mkdir -p $MODEL_PATH

# 2-skip-bigrams
python3 ngram_counter.py $PATH_TO_CORPUS $MODEL_PATH/2_skip_bigram.pkl --serialize -n 2 --min-freq-per-cycle=2 --files-per-cycle=400 --stopwords stopwords.txt --skipgram 2