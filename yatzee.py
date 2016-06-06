#!/usr/bin/env python

from urllib import urlopen
from bs4 import BeautifulSoup


def links(pg_num):
    url = "http://www.escapistmagazine.com/videos/view/zero-punctuation?page=%d" % pg_num
    bs = BeautifulSoup(urlopen(url).read())
    for l in bs.find_all(attrs={"class": "title"}):
        sbl = l.previous_sibling
        if 'href' in sbl.attrs:
            yield sbl.attrs['href']

if __name__ == "__main__":
    i = 1
    while 1:
        try:
            for l in links(i):
                print l

            i += 1
        except IOError:
            break
