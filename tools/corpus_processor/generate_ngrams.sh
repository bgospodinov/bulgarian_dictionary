#!/bin/bash
source include.sh

# bigrams
python3 ngram_counter.py $PATH_TO_CORPUS --marshal $MODEL_PATH/bigram.pkl --export $MODEL_PATH/bigram.tsv -n 2 \
  --min-freq-per-cycle=2 --stopwords $MODEL_PATH/stopwords.txt

# trigrams
python3 ngram_counter.py $PATH_TO_CORPUS --marshal $MODEL_PATH/trigram.pkl --export $MODEL_PATH/trigram.tsv -n 3 \
  --min-freq-per-cycle=2 --stopwords $MODEL_PATH/stopwords.txt
