import re


def tokenize(text):
    """Simple Cyrillic tokenization."""
    return re.split(r'[A-Za-z\W_\d]*[\s/|]+[A-Za-z\W_]*', text)


def filter_non_cyrillic(tokens):
    r_legal_symbols = re.compile(r'[\u0410-\u044F\-\'–—,°’:.0-9]+')
    return list(filter(lambda t: r_legal_symbols.fullmatch(t), tokens))
