from os import walk
from os.path import join


def scan_all_files(root):
    file_paths = []
    for (dirpath, dirnames, filenames) in walk(root):
        for dirname in dirnames:
            if dirname.startswith('.'):
                dirnames.remove(dirname)
        file_paths += [join(dirpath, name) for name in filenames]
    return file_paths


def omit(blacklist, lst):
    return (wrd for wrd in lst if wrd not in blacklist)
