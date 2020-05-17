#!/bin/bash
source "${BASH_SOURCE%/*}/include.sh"

# unigrams
python3 "${BASH_SOURCE%/*}/ngram_counter.py" "$PATH_TO_CORPUS" --marshal "$MODEL_PATH/unigram.pkl" \
  --export "$MODEL_PATH/unigram.tsv" --no-interning
cut -f1 -d$'\t' "$MODEL_PATH/unigram.tsv" | head -n 132 |\
  grep -Ev "^(път|човек|попита|очи|глава|ръка|години|<s>|</s>)" >"$MODEL_PATH/stopwords.txt"
