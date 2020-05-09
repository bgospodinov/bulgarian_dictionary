import re
r_sentence = re.compile(r'(?:.*?[:.!?]+\s*[\"“]*(?=[„\s]*[A-ZА-Я]|,|—|$))|.+')


def flat_segment(text):
    """Naive flat sentence segmentation"""
    return [sent.strip() for sent in r_sentence.findall(text)]
