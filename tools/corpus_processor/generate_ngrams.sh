#!/bin/bash
PATH_TO_CORPUS=../../corpora/chitanka/
MODEL_PATH=models

mkdir -p $MODEL_PATH

# unigrams
python3 ngram_counter.py $PATH_TO_CORPUS $MODEL_PATH/unigram.pkl --serialize

# bigrams
python3 ngram_counter.py $PATH_TO_CORPUS $MODEL_PATH/bigram.pkl --serialize -n 2

# trigrams
python3 ngram_counter.py $PATH_TO_CORPUS $MODEL_PATH/trigram.pkl --serialize -n 3