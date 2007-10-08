Description
-----------
    docbook/ .......... Translation "DocBook 5.0: The Definitive Guide" to simplified chinese.
    examples/ ......... DocBook 4.5 & 5.0 examples.
    subversion/ ....... Translation "Version Control with Subversion" to simplified chinese.
    TortoiseMerge/ .... Translation TortoiseMerge manual to simplified chinese.
    TortoiseSVN/ ...... Translation TortoiseSVN manual to simplified chinese.


Update translation
------------------
    msgmerge --update zh_CN.po example.pot


Check translation
-----------------
    msgfmt --statistics -c zh_CN.po


Format translation
-----------------
    msgmerge --width=96 -o zh_CN-new.po zh_CN.po example.pot
    mv -f zh_CN-new.po zh_CN.po


Merge translation
-----------------

Using po-merge.py from subversion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    subversion/tools/dev/po-merge.py zh_CN.po < zh_CN-other.po

Using pomerge from translation tookit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    pomerge -i zh_CN-other.po -o zh_CN-new.po -t zh_CN.po
