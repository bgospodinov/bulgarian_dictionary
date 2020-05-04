from collections import Counter
from os.path import join
from os import walk
import re
import sys
import signal
import argparse
from timeit import default_timer as timer
from multiprocessing import Process, Queue, cpu_count

STOP_MESSAGE = 'STOP'


def worker_process(input_queue, output_queue):
    counter = Counter()
    for task in iter(input_queue.get, STOP_MESSAGE):
        words = re.findall(r'\w+', open(task).read().lower())
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

    print('Root scan dir is {}'.format(args.root))

    for (dirpath, dirnames, filenames) in walk(args.root):
        if '.git' in dirnames:
            dirnames.remove('.git')
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
        print('Computation took {} seconds in total.'.format(end - start))


    def signal_handler(sig, frame):
        print()
        print('Interruption detected.')
        finish()
        sys.exit(0)


    print('Found {} files. Starting to count...'.format(total_files_num))

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
        sys.stdout.write(f'\rMerging results {i}/{num_processes}')
        sys.stdout.flush()

    print()
    print('Done.')
    print('Saving results to file...')

    with open('counter', 'w') as w:
        for (word, freq) in total_counter.most_common():
            w.write("{}\t{:,}\n".format(word, freq))

    print('Total number of words counted is {:,}'.format(sum(total_counter.values())))
    finish()
