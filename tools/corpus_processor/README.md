First setup the conda environment:
```
conda env create -f environment.yml
conda activate corpus_processor
```
Then initialize git submodules under corpora/
```
git submodule update --init --recursive
```
Finally, generate n-gram data:
```
./generate_stopwords.sh
./generate_ngrams.sh
./generate_skipgrams.sh
```