#!/bin/sh

Update & Format
---------------
msgmerge --sort-by-file --no-wrap -o tmp.po zh_CN.po subversion.pot
mv -f tmp.po zh_CN.po

msgmerge --sort-by-file --no-wrap -o tmp.po zh_CN-1.4.x.po subversion-1.4.x.pot
mv -f tmp.po zh_CN-1.4.x.po


Check
-----

msgfmt --statistics -c zh_CN.po
msgfmt --statistics -c zh_CN-1.4.x.po


Merge
-----

Using po-merge.py from subversion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    subversion/tools/dev/po-merge.py zh_CN.po < zh_CN-other.po

Using pomerge from translation tookit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    pomerge -i zh_CN-other.po -o zh_CN-new.po -t zh_CN.po
