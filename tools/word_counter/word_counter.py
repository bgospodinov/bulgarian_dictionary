from collections import Counter
from os.path import join
from os import walk
import re
import sys
import signal
import argparse

parser = argparse.ArgumentParser(description='Simple word counter.')
parser.add_argument('root', help='Root directory to scan for files.')
args = parser.parse_args()
file_paths = []

print("Root scan dir is {}".format(args.root))

for (dirpath, dirnames, filenames) in walk(args.root):
    if '.git' in dirnames:
        dirnames.remove('.git')
    file_paths += [join(dirpath, name) for name in filenames]

total_files_num = len(file_paths)
total_words_num = 0
counter = Counter()


def finish():
    print('Saving results to file...')
    with open('counter', 'w') as w:
        for (word, freq) in counter.most_common():
            w.write("{}\t{:,}\n".format(word, freq))

    print("Total number of words counted is {:,}".format(sum(counter.values())))


def signal_handler(sig, frame):
    print()
    print('Interruption detected.')
    finish()
    sys.exit(0)


signal.signal(signal.SIGINT, signal_handler)
print('Found {} books. Starting to count...'.format(total_files_num))

for idx, file_path in enumerate(file_paths):
    words = re.findall(r'\w+', open(file_path).read().lower())
    counter.update(Counter(words))
    if idx % 10 == 0:
        sys.stdout.write("\rFinished {}/{} ({}%)...".format(idx, total_files_num, idx / total_files_num * 100))
        sys.stdout.flush()

print()
print('Done.')
finish()
