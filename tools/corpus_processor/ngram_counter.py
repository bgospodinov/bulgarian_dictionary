import argparse
import gc
import pickle
import signal
import sys
from collections import Counter
from multiprocessing import Process, Queue, cpu_count
from queue import Empty
from timeit import default_timer as timer

from ngram import ngram
from sentence_segmenter import flat_segment
from tokenizer import tokenize_list, filter_cyrillic_words
from util import scan_all_files, omit

STOP_MESSAGE = 'STOP'


def clean_counter(counter, min_freq):
    return Counter(el for el in counter.elements() if counter[el] >= min_freq)


def worker_process(input_queue, output_queue, n, min_freq, files_per_cycle, interning, stopwords):
    try:
        counter = Counter()

        def __clean_counter():
            nonlocal counter
            if min_freq > 0:
                counter = clean_counter(counter, min_freq)
                gc.collect()

        def __ngram(x):
            if n > 1:
                return ngram(x, n=n)
            return x

        for idx, task_file in enumerate(iter(input_queue.get, STOP_MESSAGE)):
            text = open(task_file).read().lower()
            sentences = flat_segment(text)
            tokens = tokenize_list(sentences)
            cyr_words = omit(stopwords, filter_cyrillic_words(tokens))
            if interning:
                cyr_words = [sys.intern(cyr_word) for cyr_word in cyr_words]
            ngram_keys = __ngram(cyr_words)
            counter.update(Counter(ngram_keys))
            completed = total_files_num - input_queue.qsize()

            if idx % files_per_cycle == 0 and idx > 0:
                __clean_counter()

            if completed % 100 == 0:
                sys.stdout.write(
                    f'\rFinished {completed}/{total_files_num} ({completed / total_files_num * 100:.2f}%)...')
                sys.stdout.flush()

        __clean_counter()
        output_queue.put(counter)
    except:
        print(f'Worker exited due to error: {sys.exc_info()[0]}')
        raise


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Simple token counter.')
    parser.add_argument('root_dir', help='Root directory to scan for files.')
    parser.add_argument('output_file', help='Output file path.')
    parser.add_argument('-n', default=1, type=int)
    parser.add_argument('--stopwords')
    parser.add_argument('--min-freq-per-cycle', default=0, type=int)
    parser.add_argument('--files-per-cycle', default=1_000, type=int)
    parser.add_argument('--no-interning', dest='interning', action='store_false')
    parser.add_argument('--serialize', action='store_true')
    args = parser.parse_args()

    print(args)
    file_paths = scan_all_files(args.root_dir)

    stopword_list = []
    if args.stopwords:
        print(f'Loading stopwords from {args.stopwords}...')
        with open(args.stopwords) as f:
            for line in f:
                stopword_list.append(line.strip())
        print(f'Loaded {len(stopword_list)} lines.')
        print(stopword_list)

    iq, oq = Queue(), Queue()
    processes = []
    total_files_num = len(file_paths)
    total_words_num = 0
    total_counter = Counter()
    num_processes = cpu_count()


    def finish():
        for p in processes:
            p.terminate()
        iq.close()
        oq.close()
        end = timer()
        print(f'Computation took {end - start} seconds in total.')


    def signal_handler(sig, frame):
        print()
        print('Interruption detected.')
        finish()
        sys.exit(0)


    print(f'Found {total_files_num} files. Starting to count n-grams...')

    start = timer()
    for file_path in file_paths:
        iq.put(file_path)

    worker_args = (iq, oq, args.n, args.min_freq_per_cycle, args.files_per_cycle, args.interning, stopword_list)
    for i in range(num_processes):
        iq.put(STOP_MESSAGE)
        process = Process(target=worker_process, args=worker_args)
        process.daemon = True
        process.start()
        processes.append(process)

    signal.signal(signal.SIGINT, signal_handler)

    try:
        for i in range(num_processes):
            if i == 0:
                total_counter.update(oq.get())
                print()
            else:
                total_counter.update(oq.get(block=True, timeout=10))
            sys.stdout.write(f'\rMerging results {i + 1}/{num_processes}')
            sys.stdout.flush()
    except Empty as e:
        print()
        print(f'Process result queue was prematurely empty: {e}', file=sys.stderr)

    print()
    print('Done.')

    if args.serialize:
        print('Serializing the counters...')
        with open(args.output_file, 'wb') as w:
            pickle.dump(total_counter, w)
    else:
        print('Saving results to file...')
        with open(args.output_file, 'w') as w:
            for (word, freq) in total_counter.most_common():
                w.write(f"{word}\t{freq:,}\n")

    print(f'Total number of n-grams counted is {sum(total_counter.values()):,}')
    finish()
