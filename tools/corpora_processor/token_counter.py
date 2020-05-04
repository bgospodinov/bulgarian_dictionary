import argparse
import signal
import sys
from collections import Counter
from multiprocessing import Process, Queue, cpu_count
from os import walk
from os.path import join
from timeit import default_timer as timer

from tokenizer import tokenize, filter_non_cyrillic

OUTPUT_FILE = 'counter.tsv'
STOP_MESSAGE = 'STOP'


def worker_process(input_queue, output_queue):
    counter = Counter()
    for task_file in iter(input_queue.get, STOP_MESSAGE):
        words = filter_non_cyrillic(tokenize(open(task_file).read().lower()))
        counter.update(Counter(words))
        completed = total_files_num - input_queue.qsize()
        if completed % 100 == 0:
            sys.stdout.write(
                f'\rFinished {completed}/{total_files_num} ({completed / total_files_num * 100}%)...')
            sys.stdout.flush()
    output_queue.put(counter)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Simple word counter.')
    parser.add_argument('root', help='Root directory to scan for files.')
    args = parser.parse_args()
    file_paths = []

    print(f'Root scan dir is {args.root}')

    for (dirpath, dirnames, filenames) in walk(args.root):
        for dirname in dirnames:
            if dirname.startswith('.'):
                dirnames.remove(dirname)
        file_paths += [join(dirpath, name) for name in filenames]

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


    print(f'Found {total_files_num} files. Starting to count...')

    start = timer()
    for file_path in file_paths:
        iq.put(file_path)

    for i in range(num_processes):
        iq.put(STOP_MESSAGE)
        process = Process(target=worker_process, args=(iq, oq))
        process.daemon = True
        process.start()
        processes.append(process)

    signal.signal(signal.SIGINT, signal_handler)

    for i in range(num_processes):
        total_counter.update(oq.get())
        if i == 0:
            print()
        sys.stdout.write(f'\rMerging results {i + 1}/{num_processes}')
        sys.stdout.flush()

    print()
    print('Done.')
    print('Saving results to file...')

    with open(OUTPUT_FILE, 'w') as w:
        for (word, freq) in total_counter.most_common():
            w.write(f"{word}\t{freq:,}\n")

    print(f'Total number of words counted is {sum(total_counter.values()):,}')
    finish()
