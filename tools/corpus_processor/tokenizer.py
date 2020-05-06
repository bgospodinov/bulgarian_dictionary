import re

word_punct_pattern = r"[‐‑‒–—\-']"  # punctuation permissible inside words
r_tokenize = re.compile(rf'''(?x)               # set flag to allow verbose regexps
            (?:[A-ZА-Я]\.)+|                    # acronyms
            \w+(?:{word_punct_pattern}\w+)*|    # possibly hyphenated words
            \.\.\.|                             # ellipsis
            \S                                  # every other non-whitespace character is assumed to be punctuation
''')
# regex definition of a valid Cyrillic word
r_cyrillic_word = re.compile(rf'[\u0410-\u044F\d]+(?:{word_punct_pattern}[\u0410-\u044F]+)*')


def tokenize(text):
    """Simple Cyrillic tokenization."""
    return r_tokenize.findall(text)


def filter_cyrillic_tokens(tokens):
    return filter(lambda t: r_cyrillic_word.fullmatch(t), tokens)
