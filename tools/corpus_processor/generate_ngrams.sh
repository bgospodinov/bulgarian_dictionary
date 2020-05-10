#!/bin/bash
PATH_TO_CORPUS=../../corpora/chitanka/
MODEL_PATH=models

mkdir -p $MODEL_PATH

# unigrams
python3 ngram_counter.py $PATH_TO_CORPUS $MODEL_PATH/unigram.pkl --serialize --no-interning

# bigrams
python3 ngram_counter.py $PATH_TO_CORPUS $MODEL_PATH/bigram.pkl --serialize -n 2 --min-freq-per-cycle=2 --stopwords stopwords.txt

# trigrams
python3 ngram_counter.py $PATH_TO_CORPUS $MODEL_PATH/trigram.pkl --serialize -n 3 --min-freq-per-cycle=2 --stopwords stopwords.txt