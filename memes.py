#!/usr/bin/env python

import json
from fuzzywuzzy import process

MEMEFILE = "/home/fakedrake/bin/memes.json"

def get_memes(fname=MEMEFILE):
    try:
        return json.load( open(fname) )
    except IOError:
        return {}

def save_meme(name, url, fname=MEMEFILE):
    """
    Save in the json.
    """

    memes = get_memes(fname)

    memes[name] = url
    with open(fname, 'w') as fd:
        fd.write(json.dumps(memes))

def get_meme(name, fname=MEMEFILE):
    memes = get_memes(fname)
    realname, rate = process.extractOne(name,memes.keys())
    return rate, realname, memes[realname]


if __name__ == "__main__":
    import sys

    if len(sys.argv) == 1:
        for m in get_memes().iteritems():
            sys.stdout.write("%s :\t%s\n", m)
    elif len(sys.argv) == 2:
        try:
            sys.stdout.write("(%d)%s :\t%s\n" % get_meme(sys.argv[1]))
        except TypeError:
            sys.stderr.write("No meme found.\n")
    elif len(sys.argv) == 3:
        save_meme(sys.argv[1], sys.argv[2])
    else:
        sys.stderr.write("Why would you give %d arguments?\n" % len(sys.argv))
