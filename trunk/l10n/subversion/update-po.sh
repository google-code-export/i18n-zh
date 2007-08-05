#!/bin/sh

msgmerge --sort-by-file --update zh_CN.po subversion.pot
msgmerge --sort-by-file --update zh_CN.po subversion.pot

msgmerge --sort-by-file --update zh_CN-1.4.x.po subversion-1.4.x.pot
msgmerge --sort-by-file --update zh_CN-1.4.x.po subversion-1.4.x.pot
