import pickle
import re
from argparse import ArgumentParser
from collections import defaultdict
from math import inf

import nltk
from nltk import FreqDist
from nltk.collocations import BigramCollocationFinder, TrigramCollocationFinder

if __name__ == '__main__':
    parser = ArgumentParser(description='Collocations explorer.')
    parser.add_argument('-n', default=2, type=int, choices=[2, 3])
    parser.add_argument('-t', '--top', default=20, type=int)
    parser.add_argument('-f', '--freq-filter', default=15, type=int)
    parser.add_argument('-s', '--min-score', default=-inf, type=float)
    parser.add_argument('-r', '--word-filter')
    parser.add_argument('-m', '--measure', default='chi_sq',
                        choices=['raw_freq', 'student_t', 'chi_sq', 'mi_like', 'pmi', 'likelihood_ratio',
                                 'poisson_stirling', 'jaccard', 'phi_sq', 'fisher', 'dice'])
    parser.add_argument('--unigram', default='models/unigram.pkl', help='Path to unigrams.')
    parser.add_argument('--bigram', default='models/bigram.pkl', help='Path to bigrams.')
    parser.add_argument('--trigram', default='models/trigram.pkl', help='Path to trigrams.')
    args = parser.parse_args()
    print(args)

    unigrams = FreqDist(pickle.load(open(args.unigram, 'rb')))
    bigrams = FreqDist(pickle.load(open(args.bigram, 'rb')))

    if args.n == 3:
        trigrams = FreqDist(pickle.load(open(args.trigram, 'rb')))
        wildcards = defaultdict(int)
        for key in trigrams.keys():
            wildcards[(key[0], key[2])] += trigrams.get(key)
        wildcards = FreqDist(wildcards)
        ngram_measures = nltk.collocations.TrigramAssocMeasures()
        finder = TrigramCollocationFinder(unigrams, bigrams, wildcards, trigrams)
    else:
        ngram_measures = nltk.collocations.BigramAssocMeasures()
        finder = BigramCollocationFinder(unigrams, bigrams)

    if args.freq_filter > 0:
        finder.apply_freq_filter(args.freq_filter)

    if args.word_filter:
        finder.apply_ngram_filter(lambda *words: not any(re.match(args.word_filter, word) for word in words))

    scored = finder.score_ngrams(eval("ngram_measures." + args.measure))

    if args.top:
        scored = scored[:args.top]

    for (ngram, score) in scored:
        if score >= args.min_score:
            print(f"{ngram}\t{score:,}")
        else:
            break
