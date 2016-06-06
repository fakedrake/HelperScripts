#!/usr/bin/env python
"""
Journalctl output to prepend each line with the numebr of seconds.
"""

from datetime import datetime, timedelta


def read_date(line):
    """
    Get the datetime corresponding to the log line. Throws ValueError
    on failure.
    """

    dts = " ".join(line.split(" ")[:3])
    return datetime.strptime(dts, "%m %d %H:%M:%S")

def lineiter():
    while True:
        try:
            l = raw_input()
            yield (l, read_date(l))
        except EOFError:
            break
        except ValueError:
            pass

def main():
    last_time = None
    for (cl, cd) in dtl:
        print "[%ds] %s" % ((cl - (last_time or cl)).seconds, cl)

if __name__ == '__main__':
    main()
