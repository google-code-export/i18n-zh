#!/usr/bin/python -u

import sys
import xml.parsers.expat

dc = 0
p = xml.parsers.expat.ParserCreate()
exclude = ['literal', 'quote', 'guimenu', 'guimenuitem', 'emphasis', 'xref',
    'firstterm', 'filename', 'command', 'computeroutput', 'option', 'replaceable']

def start_element(name, attrs):
    global dc, exclude
    if name not in exclude:
        print dc * 4 * ' ' + '<' + name + '>' + str((p.CurrentLineNumber, p.CurrentColumnNumber))
    dc = dc + 1
def end_element(name):
    global dc, exclude
    dc = dc - 1
    if name not in exclude:
        print dc * 4 * ' ' + '</' + name + '>'

p.StartElementHandler = start_element
p.EndElementHandler = end_element
p.ParseFile(sys.stdin)

