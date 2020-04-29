import os
from os.path import expanduser, join
import lxml.html

# path to website downloaded by wayback_machine_downloader from Archive Wayback Machine
murdarov_path = expanduser('~/websites/wiki.workroom.chitanka.info/'
                           'Page:Murdarov-Rechnik_na_sljatoto_polusljatoto_i_razdelnoto_pisane.djvu')
output_path = 'murdarov.txt'
pages = sorted([i for i in list(map(int, os.listdir(murdarov_path))) if 31 <= i <= 198])

with open(output_path, 'w') as output:
    for page in pages:
        fname = join(murdarov_path, str(page), 'index.html')
        with open(fname, 'r') as file:
            if os.path.isfile(fname):
                print('Processing page {}'.format(page))
                html = lxml.html.parse(file)
                for elem in html.xpath('.//div[@class="pagetext"]//li'):
                    entry = elem.text.strip()
                    # some words have multiple variants per line
                    for word in entry.split('/'):
                        output.write(word.strip())
                        output.write('\n')
