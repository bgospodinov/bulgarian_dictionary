import re
import itertools

cyrillic_range = r'[\u0410-\u044F\d]'
hyphens = r'‐‑‒–—\-'
apostrophes = r"'’"
mid_word_punct_range = rf"[{hyphens}{apostrophes}]"  # punctuation permissible inside words
end_word_punct_range = rf"[{hyphens}]"  # punctuation permissible at end of words
r_tokenize = re.compile(rf'''(?x)               # set flag to allow verbose regexps
            [\d.,]+|                            # dates or floating numbers
            [а-я]\.|                            # abbreviations
            (?:[A-ZА-Я]\.)+|                    # acronyms
            \w+(?:{mid_word_punct_range}\w+)*{end_word_punct_range}*|    # possibly hyphenated words
            \.\.\.|                             # ellipsis
            \S                                  # every other non-whitespace character is assumed to be punctuation
''')
# regex definition of a valid Cyrillic word
r_cyrillic_word = re.compile(rf'{cyrillic_range}+(?:{mid_word_punct_range}{cyrillic_range}+)*{end_word_punct_range}*')


def tokenize_list(sentences):
    return list(itertools.chain.from_iterable([tokenize_string(sentence) for sentence in sentences]))


def tokenize_string(text):
    """Simple Cyrillic tokenization."""
    return r_tokenize.findall(text)


def filter_cyrillic_words(tokens):
    """Only leaves standalone Cyrillic words"""
    return filter(lambda t: r_cyrillic_word.fullmatch(t), tokens)
