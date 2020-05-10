from collections import deque
from itertools import islice, tee, cycle

from toolz import sliding_window, concat


def ngram(words, n=1):
    return sliding_window(n, words)


def step_sliding_window(n, seq, step=1):
    return zip(cycle([step]), *(deque(islice(it, i * step), 0) or it for i, it in enumerate(tee(seq, n))))


def skip_bigram(words, min_step=1, max_step=None):
    if max_step is None:
        max_step = len(words)
    return concat(step_sliding_window(2, words, step) for step in range(min_step, max_step))
