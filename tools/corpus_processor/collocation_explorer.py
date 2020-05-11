from nltk import FreqDist
import pickle

unigrams = pickle.load(open('models/unigram.pkl', 'rb'))
bigrams = pickle.load(open('models/bigram.pkl', 'rb'))
