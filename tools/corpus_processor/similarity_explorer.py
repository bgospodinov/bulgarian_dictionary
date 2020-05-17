from argparse import ArgumentParser
from collections import defaultdict
from sys import stdout, intern

from nltk.text import ContextIndex

from ngram import load_ngrams

if __name__ == '__main__':
    parser = ArgumentParser(description='Context explorer.')
    parser.add_argument('word')
    parser.add_argument('-n', '--number', default=20)
    args = parser.parse_args()
    print(args)
    trigrams = load_ngrams('models/trigram.pkl', n=3)
    word_to_contexts = {}
    context_to_words = {}
    total_trigrams = len(trigrams)
    print(f'Loading contexts from trigrams...')
    for idx, t in enumerate(trigrams):
        if len(t) == 3:
            word = intern(t[1])
            context = (intern(t[0]), intern(t[2]))
            count = trigrams[t]
            if word not in word_to_contexts:
                word_to_contexts[word] = defaultdict(int)
            if context not in context_to_words:
                context_to_words[context] = defaultdict(int)
            word_to_contexts[word][context] += count
            context_to_words[context][word] += count
        if idx % 100 == 0:
            stdout.write(
                f'\rFinished {idx}/{total_trigrams} ({idx / total_trigrams * 100:.2f}%)...')
            stdout.flush()
    del trigrams
    ci = ContextIndex([])
    ci._word_to_contexts = word_to_contexts
    ci._context_to_words = context_to_words
    print()
    print(f'Similar words: {ci.similar_words(args.word, n=args.number)}')
