#!/bin/bash

strace -e write=13,4 -ff -o /tmp/firefox-trace.txt firefox https://codebender.cc/sketch:61301
# Show which children are candidates for plugin and avrdude
grep "open.*ACM"
