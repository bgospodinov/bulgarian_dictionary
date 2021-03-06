import argparse
import gc
import pickle
import signal
import sys
from collections import Counter
from itertools import chain
from multiprocessing import Process, Queue, cpu_count
from queue import Empty
from timeit import default_timer as timer

from ngram import ngram, skip_bigram
from sentence_segmenter import flat_segment
from tokenizer import filter_cyrillic_words, tokenize_string
from util import scan_all_files, omit, load_stopwords

STOP_MESSAGE = 'STOP'


def clean_counter(counter, min_freq):
    return Counter(el for el in counter.elements() if counter[el] >= min_freq)


def worker_process(input_queue, output_queue, n, min_freq, files_per_cycle, interning, stopwords, skipgram, lps, rps):
    try:
        counter = Counter()

        def __clean_counter():
            nonlocal counter
            if min_freq > 0:
                counter = clean_counter(counter, min_freq)
                gc.collect()

        def __ngram(x):
            if skipgram:
                return skip_bigram(x, max_step=skipgram)
            if n > 1:
                return ngram(x, n=n)
            return x

        for idx, task_file in enumerate(iter(input_queue.get, STOP_MESSAGE)):
            with open(task_file) as tf:
                text = tf.read().lower()
            sentences = flat_segment(text)
            exclude = []
            if lps or rps:
                exclude = [lps, rps]
                sentences = [lps + " " + sentence + " " + rps for sentence in sentences]
            token_sentences = [tokenize_string(sentence) for sentence in sentences]
            cyr_sentences = [omit(stopwords, filter_cyrillic_words(token_sentence, exclude=exclude)) for token_sentence
                             in
                             token_sentences]
            if interning:
                cyr_sentences = [(sys.intern(cyr_word) for cyr_word in cyr_sentence) for cyr_sentence in cyr_sentences]
            ngram_sentences = chain.from_iterable(__ngram(cyr_sentence) for cyr_sentence in cyr_sentences)
            counter.update(Counter(ngram_sentences))
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
    parser.add_argument('-n', default=1, type=int)
    parser.add_argument('--skipgram', help='Max step size for skipgrams (bigrams only)', type=int)
    parser.add_argument('--stopwords')
    parser.add_argument('--min-freq-per-cycle', default=0, type=int)
    parser.add_argument('--files-per-cycle', default=1_000, type=int)
    parser.add_argument('--no-interning', dest='interning', action='store_false')
    parser.add_argument('--marshal', help='Marshal output as pickle.')
    parser.add_argument('--export', help='Export output in human-readable format')
    parser.add_argument('-lps', '--left-pad-symbol', help='Left pad symbol at the beginning of sentences.',
                        default='<s>')
    parser.add_argument('-rps', '--right-pad-symbol', help='Right pad symbol at the beginning of sentences.',
                        default='</s>')
    parser.add_argument('--no-padding', dest='padding', action='store_false')
    args = parser.parse_args()

    if not args.padding:
        args.left_pad_symbol = None
        args.right_pad_symbol = None
    if args.skipgram and args.n != 2:
        print('Skipgrams only allowed for n = 2.', file=sys.stderr)
        sys.exit(1)

    print(args)
    file_paths = scan_all_files(args.root_dir)
    stopword_list = load_stopwords(args.stopwords)
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

    worker_args = (
        iq, oq, args.n, args.min_freq_per_cycle, args.files_per_cycle, args.interning, stopword_list, args.skipgram,
        args.left_pad_symbol, args.right_pad_symbol)

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

    if args.marshal:
        print('Serializing the counters...')
        with open(args.marshal, 'wb') as w:
            pickle.dump(total_counter, w)

    if args.export:
        print('Exporting results to file...')
        with open(args.export, 'w') as w:
            for (word, freq) in total_counter.most_common():
                w.write(f"{word}\t{freq:,}\n")

    print(f'Total number of n-grams counted is {sum(total_counter.values()):,}')
    finish()
