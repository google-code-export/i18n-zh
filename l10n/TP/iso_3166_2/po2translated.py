#!/usr/bin/env python

import sys

def foo(line):
    line = line[3:]
    words = [x.strip() for x in line.split(',')]
    for x in words:
        assert x.startswith('name for ')
    return [x[9:] for x in words]

def main():
    ifile = file(sys.argv[1])
    
    res = []
    subres = []
    for line in ifile:
        if line.startswith('#.'):
            res.extend(subres)
            subres = foo(line)
        elif line.startswith('#, fuzzy'):
            subres = []
        elif line.startswith('msgstr ""'):
            subres = []

    print '\n'.join(res)

if __name__ == '__main__':
    main()
