import pickle
from collections import deque, defaultdict
from itertools import islice, tee, cycle

from nltk import FreqDist
from toolz import sliding_window, concat


def ngram(words, n=1):
    return sliding_window(n, words)


def step_sliding_window(n, seq, step=1):
    return zip(cycle([step]), *(deque(islice(it, i * step), 0) or it for i, it in enumerate(tee(seq, n))))


def skip_bigram(words, min_step=1, max_step=2):
    return concat(step_sliding_window(2, words, step) for step in range(min_step, max_step + 1))


def load_ngrams(path, n):
    d = pickle.load(open(path, 'rb'))
    if n > 1:
        r = defaultdict(int)
        for k in d.keys():
            # this will remove positions from skip-grams if any
            r[k[-n:]] += d[k]
        return FreqDist(r)
    return FreqDist(d)