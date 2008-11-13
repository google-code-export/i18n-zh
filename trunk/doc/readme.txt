Description
-----------
    defguide/ [1] ............. Translation "DocBook: The Definitive Guide" to simplified chinese.
    defguide5/ [1] ............ Translation "DocBook 5.0: The Definitive Guide" to simplified chinese.
    examples/ ................. DocBook 4.5 & 5.0 examples.
    svnbook/ .................. Translation "Version Control with Subversion" to simplified chinese.
    TortoiseMerge/ [1] ........ Translation TortoiseMerge manual to simplified chinese.
    TortoiseSVN/ [1] .......... Translation TortoiseSVN manual to simplified chinese.

    [1] Moved to official repository, if you want to help us, please contact dongsheng@users.sourceforge.net.

Update translation
------------------
    msgmerge --update zh_CN.po example.pot


Check translation
-----------------
    msgfmt --statistics -c zh_CN.po


Format translation
-----------------
    msgmerge --width=80 --sort-by-file -o zh_CN-new.po zh_CN.po example.pot
    mv -f zh_CN-new.po zh_CN.po


Merge translation
-----------------

Using po-merge.py from subversion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    subversion/tools/dev/po-merge.py zh_CN.po < zh_CN-other.po

Using pomerge from translation tookit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    pomerge -i zh_CN-other.po -o zh_CN-new.po -t zh_CN.po
