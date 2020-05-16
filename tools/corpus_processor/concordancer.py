import re
from argparse import ArgumentParser

from nltk.text import ConcordanceIndex

from tokenizer import tokenize_string
from util import scan_all_files

if __name__ == '__main__':
    parser = ArgumentParser(description='Simple NLTK-based concordancer.')
    parser.add_argument('root_dir', help='Root directory to scan for files.')
    parser.add_argument('word_regex')
    parser.add_argument('-w', '--width', type=int, default=80)
    args = parser.parse_args()
    print(args)
    word_regex = re.compile(args.word_regex, flags=re.IGNORECASE)
    file_paths = scan_all_files(args.root_dir)
    for file_path in file_paths:
        with open(file_path) as f:
            tokens = tokenize_string(f.read())
            concordance_index = ConcordanceIndex(tokens, key=lambda s: s.lower())
            for search_token in filter(word_regex.fullmatch, concordance_index._offsets):
                concordance_list = concordance_index.find_concordance(search_token, width=args.width)
                if concordance_list:
                    for concordance_line in concordance_list:
                        print(" ".join([concordance_line.left_print, concordance_line.query.upper(),
                                        concordance_line.right_print]))
