#!/bin/bash
source "${BASH_SOURCE%/*}/include.sh"

# 2-skip-bigrams
python3 "${BASH_SOURCE%/*}/ngram_counter.py" "$PATH_TO_CORPUS" --marshal "$MODEL_PATH/2_skip_bigram.pkl" --export "$MODEL_PATH/2_skip_bigram.tsv" \
  -n 2 --min-freq-per-cycle=2 --files-per-cycle=400 --stopwords "$MODEL_PATH/stopwords.txt" --skipgram 2 --no-padding
