import re
r_sentence = re.compile(r'(?:.*?[:.!?]+\s*[\"“]*(?=[„\s]*[A-ZА-Я]|,|—|$))|.+')


def flat_segment(text):
    """Naive flat sentence segmentation"""
    return r_sentence.findall(text)
